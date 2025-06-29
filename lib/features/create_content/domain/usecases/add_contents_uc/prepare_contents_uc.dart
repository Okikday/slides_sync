import 'dart:typed_data';

import 'package:collection/collection.dart';
import 'package:crypto/crypto.dart';
import 'package:path/path.dart' as p;
import 'package:slides_sync/core/models/file_details.dart';
import 'package:slides_sync/core/utils/file_utils.dart';
import 'package:slides_sync/core/utils/result.dart';
import 'package:slides_sync/data/models/course_model/course_model.dart';
import 'package:slides_sync/data/repos/course_repo.dart';
import 'package:slides_sync/features/create_content/domain/repos/allowed_file_extensions.dart';

class PrepareContentsUc {
  Future<bool> storeCourseContents(CourseSubCollection collection, List<File> selectedContents) async {
    final Result<bool?> outcome = await Result.tryRunAsync<bool>(() async {
      final String pathToStoreAt = collection.absolutePath;
      List<String> potentialPurgePaths = []; // This would be a later list that holds the paths of the purge in case the operation fails
      List<CourseContent> contentList = [];

      for (var file in selectedContents) {
        final storedAt = await FileUtils.storeFile(file: file, folderPath: pathToStoreAt);
        potentialPurgePaths.add(file.path);
        final fileName = p.basename(file.path);
        final fileNameWithoutExt = p.basenameWithoutExtension(fileName);
        // fileName.substring(0, fileName.indexOf('.').clamp(0, fileName.length));
        final Uint8List fileBytes = await File(storedAt).readAsBytes();
        final hash = sha256.convert(fileBytes).bytes.toString();

        final CourseContent content = CourseContent.create(
          title: fileNameWithoutExt,
          parentId: pathToStoreAt,
          path: FileDetails(filePath: storedAt, fileHash: hash),
          courseContentType: getCourseContentType(fileName),
        );
        contentList.add(content);
      }

      /// TODO LATER: Modifications can be made here to check if the collection parentId container a pathSeparator,
      /// which can then be used to determine whether it's right under the CourseModel or not.
      final CourseModel? course = await CourseRepo.getCourseById(collection.parentId.split(Platform.pathSeparator).first);
      if (course == null) return false;
      final CourseSubCollection? getCollection = course.subCollections.firstWhereOrNull(
        (test) => test.collectionId == collection.collectionId && test.parentId == collection.parentId,
      );
      if (getCollection == null) return false;
      collection = getCollection;

      final existingIds = <String>{for (final c in collection.courseContents) c.id};
      final existingHashes = <String>{for (final c in collection.courseContents) c.path.fileDetails.fileHash};

      final List<CourseContent> dedupedNewContents =
          contentList.where((c) {
            return !existingIds.contains(c.id) && !existingHashes.contains(c.path.fileDetails.fileHash);
          }).toList();

      final newCollection = collection.copyWith(courseContents: [...collection.courseContents, ...dedupedNewContents]);

      final updatedCollections = [
        for (final sub in course.subCollections)
          if (sub.collectionId != collection.collectionId) sub,
        newCollection,
      ];
      await CourseRepo.addCourse(course.copyWith(subCollections: updatedCollections));
      return true;
    });
    if (outcome.isSuccess) return true;
    return false;
  }

  /// Returns the CourseContentType for a file extension or path.
  /// E.g. `.md`, `file.txt`, `/path/to/image.jpg`
  CourseContentType getCourseContentType(String pathOrExt) {
    // Remove any leading dots and path parts
    String ext = pathOrExt.trim().toLowerCase();

    if (ext.contains(Platform.pathSeparator)) {
      ext = ext.split(Platform.pathSeparator).last;
    }
    if (ext.contains('.')) {
      ext = ext.split('.').last;
    }

    if (AllowedFileExtensions.allowedImageExtensions.contains(ext)) {
      return CourseContentType.image;
    } else if (AllowedFileExtensions.allowedVideoExtensions.contains(ext)) {
      return CourseContentType.video;
    } else if (AllowedFileExtensions.allowedDocumentExtensions.contains(ext)) {
      return CourseContentType.document;
    } else if (AllowedFileExtensions.allowedAudioExtensions.contains(ext)) {
      return CourseContentType.audio;
    } else if (['txt', 'md'].contains(ext)) {
      return CourseContentType.note;
    } else {
      return CourseContentType.unknown;
    }
  }
}
