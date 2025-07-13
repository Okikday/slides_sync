import 'dart:developer';
import 'dart:typed_data';

import 'package:collection/collection.dart';
import 'package:crypto/crypto.dart';
import 'package:flutter/services.dart';
import 'package:path/path.dart' as p;
import 'package:path_provider/path_provider.dart';
import 'package:pdfx/pdfx.dart';
import 'package:slides_sync/core/data/isar_data/isar_data.dart';
import 'package:slides_sync/core/data/isar_data/isar_schemas.dart';
import 'package:slides_sync/core/models/file_details.dart';
import 'package:slides_sync/core/utils/file_utils.dart';
import 'package:slides_sync/core/utils/result.dart';
import 'package:slides_sync/data/models/course_model/course_model.dart';
import 'package:slides_sync/data/repos/course_repo.dart';
import 'package:slides_sync/features/create_all/create_content/domain/repos/allowed_file_extensions.dart';
import 'package:slides_sync/features/create_all/create_content/domain/usecases/add_contents_uc/create_content_preview_image.dart';

class PrepareContentsUc {
  static CourseSubCollection colllectionFromJson(String source) => CourseSubCollection.fromJson(source);

  static Future<String?> storeCourseContents(Map<String, dynamic> args) async {
    final Result<String?> outcome = await Result.tryRunAsync<String?>(() async {
      CourseSubCollection collection = colllectionFromJson(args['collectionJson']);
      final selectedContentPaths = args['selectedContentsPaths'];
      final List<File> selectedContents = [for (final value in selectedContentPaths) File(value)];
      final RootIsolateToken rootIsolateToken = args['rootIsolateToken'] as RootIsolateToken;
      BackgroundIsolateBinaryMessenger.ensureInitialized(rootIsolateToken);

      final String dirToStoreAt = collection.absolutePath;
      final String parentId = collection.relativePath;
      List<String> potentialPurgePaths = []; // This would be a list that holds the paths of the purge in case the operation fails
      List<CourseContent> contentList = [];

      for (var file in selectedContents) {
        
        final storedAt = await FileUtils.storeFile(file: file, folderPath: dirToStoreAt);

        // potentialPurgePaths.add(file.path);
        final fileName = p.basename(file.path);
        final fileNameWithoutExt = p.basenameWithoutExtension(fileName);

        final Uint8List fileBytes = await File(storedAt).readAsBytes();
        final hash = sha256.convert(fileBytes).bytes.toString();

        final CourseContentType contentType = getCourseContentType(fileName);

        final CourseContent content = CourseContent.create(
          title: fileNameWithoutExt,
          parentId: parentId,
          path: FileDetails(filePath: storedAt, fileHash: hash),
          courseContentType: contentType,
        );
        await CreateContentPreviewImage.createPreviewImageForContent(
          storedAt,
          courseContentType: contentType,
          genPreviewPathRecord: CreateContentPreviewImage.genPreviewImagePathRecord(filePath: storedAt, contentId: content.id),
        );
        contentList.add(content);
      }

      await IsarData.initialize(collectionSchemas: isarSchemas);

      /// TODO LATER: Modifications can be made here to check if the collection parentId contains a pathSeparator,
      /// which can then be used to determine whether it's right under the CourseModel or not.
      final CourseModel? course = await CourseRepo.getCourseById(collection.parentId.split(Platform.pathSeparator).first);
      if (course == null) return "Couldn't find course!";
      final CourseSubCollection? getCollection = course.subCollections.firstWhereOrNull(
        (test) => test.collectionId == collection.collectionId && test.parentId == collection.parentId,
      );
      if (getCollection == null) return "Collection doesn't exist!";
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
      return null;
    });
    if (outcome.isSuccess && outcome.data == null) {
      return null;
    } else if (outcome.isSuccess) {
      return outcome.data;
    } else {
      log("${outcome.message}");
      return "An error occured while storing content!";
    }
  }

  /// Returns the CourseContentType for a file extension or path.
  /// E.g. `.md`, `file.txt`, `/path/to/image.jpg`
  static CourseContentType getCourseContentType(String pathOrExt) {
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
