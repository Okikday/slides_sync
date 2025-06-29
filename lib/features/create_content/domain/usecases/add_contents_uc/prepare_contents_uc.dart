import 'dart:typed_data';

import 'package:collection/collection.dart';
import 'package:crypto/crypto.dart';
import 'package:path/path.dart' as p;
import 'package:slides_sync/core/models/file_details.dart';
import 'package:slides_sync/core/utils/file_utils.dart';
import 'package:slides_sync/core/utils/result.dart';
import 'package:slides_sync/data/models/course_model/course_model.dart';
import 'package:slides_sync/data/models/course_model/sub/course_content_type.dart';
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
          path: FileDetails(filePath: storedAt, hash: hash),
          courseContentType: getCourseContentType(fileName),
        );
        contentList.add(content);
      }

      /// TODO LATER: Modifications can be made here to check if the collection parentId container a pathSeparator,
      /// which can then be used to determine whether it's right under the CourseModel or not.
      final CourseModel? course = await CourseRepo.getCourseById(collection.parentId.split(Platform.pathSeparator).first);
      if (course == null) return false;

      final CourseSubCollection newCollection = collection.copyWith(courseContents: [...collection.courseContents, ...contentList]);
      final List<CourseSubCollection> newCollections = [...course.subCollections.whereNot((test) => test == collection), newCollection];
      await CourseRepo.addCourse(course.copyWith(subCollections: newCollections));
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
