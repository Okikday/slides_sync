import 'dart:developer';
import 'dart:io';

import 'package:flutter/services.dart';
import 'package:path/path.dart' as p;
import 'package:pdfrx/pdfrx.dart';

import 'package:slides_sync/domain/models/file_details.dart';
import 'package:slides_sync/core/utils/image_utils.dart';
import 'package:slides_sync/core/utils/result.dart';
import 'package:slides_sync/domain/models/course_model/sub/course_content.dart';
import 'package:image/image.dart';

typedef PreviewImagePathRecord<Record> = ({String previewDirPath, String previewPath});

class CreateContentPreviewImage {
  /// Returns the preview path where the image file is stored at after making a compressed version of the image
  static Future<String?> _createForTypeImage(String path, PreviewImagePathRecord previewPathRecord) async {
    final Result<String?> result = await Result.tryRunAsync(() async {
      log("Creating preview for Type Image");
      final Result<File> result = await ImageUtils.compressImage(inputFile: File(path), targetMB: 0.05, outputFormat: 'png');

      if (result.isSuccess) {
        final String cachePath = result.data!.path;
        await Directory(previewPathRecord.previewDirPath).create();
        final file = File(cachePath);
        final copyToPath = previewPathRecord.previewPath;
        await file.copy(copyToPath);
        await file.delete();
        return copyToPath;
      }
      return null;
    });

    return result.data;
  }

  static Future<String?> _createForTypeDocument(String path, PreviewImagePathRecord previewPathRecord) async {
    final Result<String?> result = await Result.tryRunAsync(() async {
      log("Creating preview for Type Document");

      pdfrxFlutterInitialize();

      final PdfDocument document = await PdfDocument.openFile(path);
      try {
        if (document.pages.isEmpty) {
          log("PDF has no pages");
          await document.dispose();
          return null;
        }

        // first page (pages list is zero-indexed)
        final PdfPage page = document.pages[0];

        final int targetWidth = page.width.toInt();
        final int targetHeight = page.height.toInt();

        final PdfImage? pageImage = await page.render(width: targetWidth, height: targetHeight);

        if (pageImage == null) {
          log("Failed to render PDF page");
          await document.dispose();
          return null;
        }

        final imageObj = pageImage.createImageNF();

        final List<int> bytes = encodePng(imageObj);

        pageImage.dispose();

        // Create temporary file for the rendered PDF page
        final tempDir = await Directory.systemTemp.createTemp('pdf_preview_');
        final tempFile = File('${tempDir.path}/temp_pdf_page.png');
        await tempFile.writeAsBytes(bytes);

        // Compress the rendered PDF image
        final Result<File> compressionResult = await ImageUtils.compressImage(inputFile: tempFile, targetMB: 0.05, outputFormat: 'png');

        if (compressionResult.isSuccess) {
          await Directory(previewPathRecord.previewDirPath).create(recursive: true);
          final compressedFile = compressionResult.data!;
          final copyToPath = previewPathRecord.previewPath;
          await compressedFile.copy(copyToPath);

          // Clean up temporary files
          await compressedFile.delete();
          await tempDir.delete(recursive: true);

          await document.dispose();
          log("Created compressed preview for document: $copyToPath");
          return copyToPath;
        } else {
          await tempDir.delete(recursive: true);
          await document.dispose();
          log("Failed to compress PDF preview");
          return null;
        }
      } catch (e, st) {
        try {
          await document.dispose();
        } catch (_) {}
        log('Error rendering PDF preview: $e\n$st');
        rethrow;
      }
    });

    return result.data;
  }

  void createForTypeLink() {}

  static Future<void> createPreviewImageForContent(
    String path, {
    required CourseContentType courseContentType,
    required PreviewImagePathRecord genPreviewPathRecord,
  }) async {
    log("ContentType for preview: ${courseContentType.name}");
    switch (courseContentType) {
      case CourseContentType.image:
        await _createForTypeImage(path, genPreviewPathRecord);
        break;
      case CourseContentType.document:
        await _createForTypeDocument(path, genPreviewPathRecord);
        break;
      default:
        break;
    }
    return;
  }

  static String genPreviewImagePath({required String filePath}) => genPreviewImagePathRecord(filePath: filePath).previewPath;

  static PreviewImagePathRecord genPreviewImagePathRecord({required String filePath}) {
    final int lastIndexOfPathSep = filePath.lastIndexOf(Platform.pathSeparator);
    if (lastIndexOfPathSep == -1) {
      return (previewPath: '', previewDirPath: '');
    } else {
      final sep = Platform.pathSeparator;
      final previewDirPath =
          "${filePath.substring(0, lastIndexOfPathSep.clamp(0, filePath.length))}$sep"
          "preview_images";
      final previewPath = "$previewDirPath$sep${p.basenameWithoutExtension(filePath)}";
      return (previewPath: previewPath, previewDirPath: previewDirPath);
    }
  }

  static FileDetails fileDetailsFromJson(String source) => FileDetails.fromJson(source);
  static CourseContent courseContentFromJson(String source) => CourseContent.fromJson(source);

  /// Adding lots of contents image preview in Background/Isolate
  static Future<void> createPreviewImagesTask(Map<String, dynamic> args) async {
    final Result<bool?> outcome = await Result.tryRunAsync<bool>(() async {
      final RootIsolateToken rootIsolateToken = args['rootIsolateToken'] as RootIsolateToken;
      BackgroundIsolateBinaryMessenger.ensureInitialized(rootIsolateToken);

      final List<CourseContent> allContents = (args['courseContentsJsons'] as List<String>).map((e) => courseContentFromJson(e)).toList();

      for (int i = 0; i < allContents.length; i++) {
        final content = allContents[i];
        final String path = fileDetailsFromJson(content.path).filePath;
        final bool fileExists = await File(path).exists();
        if (fileExists) {
          final genPreviewPathRecord = genPreviewImagePathRecord(filePath: path);
          final previewPath = genPreviewPathRecord.previewPath;

          final bool previewExists = await File(previewPath).exists();
          if (previewExists) {
            continue;
          } else {
            log("Creating preview image");

            await createPreviewImageForContent(
              path,
              courseContentType: content.courseContentType,
              genPreviewPathRecord: genPreviewPathRecord,
            );
          }
        }
      }
      return true;
    });
    if (outcome.isSuccess) {
      log("Loaded image previews");
    } else {
      log("An exception occured!");
    }
  }

  static Future<List<CourseContent>> filterContentsWithoutPreview(List<CourseContent> courseContents) async {
    final List<CourseContent> nonExistingPreviewCourseContents = [];
    for (final content in courseContents) {
      final String previewPath = genPreviewImagePath(filePath: content.path.filePath);
      if (previewPath.isEmpty) continue;
      if (!(await File(previewPath).exists())) {
        nonExistingPreviewCourseContents.add(content);
      }
    }
    return nonExistingPreviewCourseContents;
  }
}
