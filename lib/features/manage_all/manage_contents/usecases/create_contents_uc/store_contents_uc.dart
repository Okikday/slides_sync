import 'dart:developer';

import 'package:flutter/services.dart';
import 'package:path/path.dart' as p;
import 'package:slides_sync/core/data/isar_data/isar_data.dart';
import 'package:slides_sync/core/data/isar_data/isar_schemas.dart';
import 'package:slides_sync/core/models/file_details.dart';
import 'package:slides_sync/core/utils/basic_utils.dart';
import 'package:slides_sync/core/utils/file_utils.dart';
import 'package:slides_sync/core/utils/result.dart';
import 'package:slides_sync/data/models/course_model/course.dart';
import 'package:slides_sync/data/repos/course_collection_repo.dart';
import 'package:slides_sync/data/repos/course_content_repo.dart';
import 'package:slides_sync/features/manage_all/manage_contents/repos/allowed_file_extensions.dart';
import 'package:slides_sync/features/manage_all/manage_contents/usecases/create_contents_uc/create_content_preview_image.dart';
import 'package:uuid/uuid.dart';

class StoreContentsUc {
  static CourseCollection collectionFromJson(String source) => CourseCollection.fromJson(source);

  static Future<String?> storeCourseContents(Map<String, dynamic> args) async {
    final Result<String?> outcome = await Result.tryRunAsync<String?>(() async {
      CourseCollection collection = collectionFromJson(args['collectionJson']);
      final selectedContentPaths = args['selectedContentsPaths'];
      final List<File> selectedContents = [for (final value in selectedContentPaths) File(value)];
      final RootIsolateToken rootIsolateToken = args['rootIsolateToken'] as RootIsolateToken;
      BackgroundIsolateBinaryMessenger.ensureInitialized(rootIsolateToken);
      await IsarData.initialize(collectionSchemas: isarSchemas);

      final String dirToStoreAt = collection.absolutePath;
      // This would be a list that holds the paths of the purge in case the operation fails
      List<CourseContent> contentList = [];

      for (var file in selectedContents) {
        // potentialPurgePaths.add(file.path);
        final fileName = p.basename(file.path);
        final fileNameWithoutExt = p.basenameWithoutExtension(fileName);
        final hash = await BasicUtils.calculateFileHash(file);
        final CourseContent? sameHashedContent = await CourseContentRepo.getByHash(hash);
        final CourseContentType contentType = checkContentType(fileName);

        if (sameHashedContent != null) {
          final CourseContent content = CourseContent.create(
            contentHash: hash,
            title: fileNameWithoutExt,
            parentId: collection.collectionId,
            path: sameHashedContent.path.fileDetails,
            courseContentType: contentType,
          );
          contentList.add(content);
          continue;
        } else {
          final String contentId = const Uuid().v4();
          final File storedAt = File(
            await FileUtils.storeFile(file: file, folderPath: dirToStoreAt, newFileName: p.setExtension(contentId, p.extension(file.path))),
          );

          final CourseContent content = CourseContent.create(
            contentHash: hash,
            contentId: contentId,
            title: fileNameWithoutExt,
            parentId: collection.collectionId,
            path: FileDetails(filePath: storedAt.path),
            courseContentType: contentType,
          );
          await CreateContentPreviewImage.createPreviewImageForContent(
            storedAt.path,
            courseContentType: contentType,
            genPreviewPathRecord: CreateContentPreviewImage.genPreviewImagePathRecord(filePath: storedAt.path),
          );
          contentList.add(content);
        }
      }
      await CourseCollectionRepo.addMultipleContents(contentList);
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
  static CourseContentType checkContentType(String pathOrExt) {
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
