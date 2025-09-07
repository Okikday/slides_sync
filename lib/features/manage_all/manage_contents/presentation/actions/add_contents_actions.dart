import 'dart:async';
import 'dart:developer';
import 'dart:io';
import 'dart:typed_data';

import 'package:another_flushbar/flushbar.dart';
import 'package:collection/collection.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:slides_sync/core/utils/basic_utils.dart';
import 'package:slides_sync/core/utils/result.dart';
import 'package:slides_sync/core/utils/ui_utils.dart';
import 'package:slides_sync/domain/models/course_model/course.dart';
import 'package:slides_sync/domain/models/file_details.dart';
import 'package:slides_sync/domain/repos/course_repo/course_collection_repo.dart';
import 'package:slides_sync/features/manage_all/manage_contents/presentation/views/add_contents/adding_content_overlay.dart';
import 'package:slides_sync/features/manage_all/manage_contents/usecases/add_contents_uc.dart';
import 'package:slides_sync/core/routes/routes.dart';
import 'package:super_clipboard/super_clipboard.dart';

enum AppClipboardContentType { empty, text, image, images, file, files, html, unsupported }

typedef AppClipboardData = ({dynamic data, AppClipboardContentType contentType});

class AddContentsActions {
  static Future<AppClipboardData> scanClipboardForData() async {
    AppClipboardData clipboardData = (data: null, contentType: AppClipboardContentType.empty);

    final Result<void> result = await Result.tryRunAsync(() async {
      final clipboard = SystemClipboard.instance;
      if (clipboard == null) return;

      final reader = await clipboard.read();

      // Priority 1: Check for direct image formats
      final List<Uint8List> images = [];

      if (reader.canProvide(Formats.png)) {
        log("Clipboard has PNG image data!");
        await _readImageFile(reader, Formats.png, images);
      }

      if (reader.canProvide(Formats.jpeg)) {
        log("Clipboard has JPEG image data!");
        await _readImageFile(reader, Formats.jpeg, images);
      }

      if (reader.canProvide(Formats.gif)) {
        log("Clipboard has GIF image data!");
        await _readImageFile(reader, Formats.gif, images);
      }

      if (reader.canProvide(Formats.webp)) {
        log("Clipboard has WebP image data!");
        await _readImageFile(reader, Formats.webp, images);
      }

      if (images.isNotEmpty) {
        final totalSize = images.fold(0, (sum, img) => sum + img.length) / (1024 * 1024);
        if (totalSize > 50) return; // 50MB total limit

        final newData = images.length == 1 ? images.first : images;
        final newContentType = images.length == 1 ? AppClipboardContentType.image : AppClipboardContentType.images;
        clipboardData = (data: newData, contentType: newContentType);
        return;
      }

      // Priority 2: Check for file URIs and determine their type
      if (reader.canProvide(Formats.fileUri)) {
        final Uri? uri = await reader.readValue(Formats.fileUri);
        if (uri == null) return;

        final List<String> filePaths = [uri.path];
        final List<String> imagePaths = [];
        final List<String> otherPaths = [];

        // Categorize files
        for (final path in filePaths) {
          if (_isImageFile(path) || _isImageContentUri(uri.toString())) {
            imagePaths.add(path);
          } else {
            otherPaths.add(path);
          }
        }

        // Handle image files by trying to load them
        if (imagePaths.isNotEmpty) {
          final List<Uint8List> loadedImages = [];
          for (final imagePath in imagePaths) {
            try {
              if (uri.scheme == 'content') {
                log("Content URI detected for image: ${uri.toString()}");
                continue;
              } else {
                final file = File(imagePath);
                if (await file.exists()) {
                  final bytes = await file.readAsBytes();
                  final sizeInMb = bytes.length / (1024 * 1024);
                  if (sizeInMb <= 5) {
                    loadedImages.add(bytes);
                  }
                }
              }
            } catch (e) {
              log("Failed to load image file: $imagePath - $e");
            }
          }

          if (loadedImages.isNotEmpty) {
            log("Clipboard has ${loadedImages.length} image file(s)");
            final newData = loadedImages.length == 1 ? loadedImages.first : loadedImages;
            final newContentType =
                loadedImages.length == 1 ? AppClipboardContentType.image : AppClipboardContentType.images;
            clipboardData = (data: newData, contentType: newContentType);
            return;
          }
        }

        // Handle other files
        if (otherPaths.isNotEmpty) {
          if (otherPaths.length > 20) return; // Limit file count

          log("Clipboard has ${otherPaths.length} file(s)");
          final newData = otherPaths.length == 1 ? otherPaths.first : otherPaths;
          final newContentType = otherPaths.length == 1 ? AppClipboardContentType.file : AppClipboardContentType.files;
          clipboardData = (data: newData, contentType: newContentType);
          return;
        }
      }

      // Priority 3: Check for HTML text
      if (reader.canProvide(Formats.htmlText)) {
        log("Clipboard has HTML data!");
        final String? htmlData = await reader.readValue(Formats.htmlText);
        if (htmlData != null && htmlData.isNotEmpty) {
          clipboardData = (data: htmlData, contentType: AppClipboardContentType.html);
          return;
        }
      }

      // Priority 4: Check for plain text
      if (reader.canProvide(Formats.plainText)) {
        log("Clipboard has text data!");
        final String? textData = await reader.readValue(Formats.plainText);
        if (textData != null && textData.isNotEmpty) {
          clipboardData = (data: textData, contentType: AppClipboardContentType.text);
          return;
        }
      }

      // If nothing is found, clipboard is empty or unsupported
      log("Clipboard is empty or contains unsupported data!");
      clipboardData = (data: null, contentType: AppClipboardContentType.empty);
    });

    if (result.isSuccess) {
      log("Finished scanning clipboard for data");
    } else {
      log("An error occurred while checking clipboard: ${result.message}");
    }

    return clipboardData;
  }

  static Future<void> _readImageFile(ClipboardReader reader, SimpleFileFormat format, List<Uint8List> images) async {
    try {
      final completer = Completer<void>();

      reader.getFile(format, (file) async {
        try {
          final stream = file.getStream();
          final bytes = <int>[];
          await for (final chunk in stream) {
            bytes.addAll(chunk);
          }
          final imageData = Uint8List.fromList(bytes);
          final sizeInMb = imageData.length / (1024 * 1024);
          if (sizeInMb <= 5) {
            // 5MB per image limit
            images.add(imageData);
          }
          completer.complete();
        } catch (e) {
          log("Error in getFile callback: $e");
          completer.completeError(e);
        }
      });

      await completer.future;
    } catch (e) {
      log("Failed to read image file: $e");
    }
  }

  static bool _isImageFile(String path) {
    final extension = path.toLowerCase().split('.').last;
    return ['jpg', 'jpeg', 'png', 'gif', 'webp', 'bmp', 'tiff', 'heic', 'heif', 'svg'].contains(extension);
  }

  static bool _isImageContentUri(String uriString) {
    // Check for common Android content URI patterns that indicate images
    return uriString.contains('image') ||
        uriString.contains('photo') ||
        uriString.contains('picture') ||
        uriString.contains('media/external/images') ||
        uriString.contains('com.google.android.keep/blob/image');
  }

  static bool isDataEqual(AppClipboardData oldData, dynamic newData, AppClipboardContentType newType) {
    if (oldData.contentType != newType) {
      log("Content types differ: ${oldData.contentType} vs $newType");
      return false;
    }

    // Handle null cases
    if (oldData.data == null && newData == null) return true;
    if (oldData.data == null || newData == null) return false;

    // Handle Uint8List (single image)
    if (newData is Uint8List && oldData.data is Uint8List) {
      final result = ListEquality().equals(oldData.data as Uint8List, newData);
      log("Comparing Uint8List: equal = $result");
      return result;
    }
    // Handle List<Uint8List> (multiple images)
    else if (newData is List<Uint8List> && oldData.data is List<Uint8List>) {
      final oldList = oldData.data as List<Uint8List>;
      final newList = newData;
      if (oldList.length != newList.length) {
        log("Image list lengths differ: ${oldList.length} vs ${newList.length}");
        return false;
      }
      for (int i = 0; i < oldList.length; i++) {
        if (!ListEquality().equals(oldList[i], newList[i])) {
          log("Image at index $i differs");
          return false;
        }
      }
      log("All images in list are equal");
      return true;
    }
    // Handle List<String> (file paths)
    else if (newData is List<String> && oldData.data is List<String>) {
      final result = ListEquality().equals(oldData.data as List<String>, newData);
      log("Comparing string lists: equal = $result");
      return result;
    }
    // Handle String (text/html/single file path)
    else if (newData is String && oldData.data is String) {
      final result = oldData.data == newData;
      log("Comparing strings: equal = $result");
      return result;
    }

    // Fallback for other types
    final result = oldData.data == newData;
    log("Comparing other types: equal = $result");
    return result;
  }

  static void onClickToAddContent(
    WidgetRef ref, {
    required CourseCollection collection,
    required CourseContentType type,
  }) async {
    final context = ref.context;
    ValueNotifier<String> valueNotifier = ValueNotifier("Loading...");
    final entry = OverlayEntry(
      builder:
          (context) => ValueListenableBuilder(
            valueListenable: valueNotifier,
            builder: (context, value, child) => LoadingOverlay(message: value),
          ),
    );
    if (context.mounted) {
      Overlay.of(context).insert(entry);
    }
    final List<AddContentResultModel> result = await AddContentsUc.addToCollection(
      ref,
      collection: collection,
      type: type,
      valueNotifier: valueNotifier,
    );

    entry.remove();
    valueNotifier.dispose();

    if (result.isNotEmpty) {
      await UiUtils.showFlushBar(
        rootNavigatorKey.currentContext!,
        msg: "Successfully added course contents!",
        vibe: FlushbarVibe.success,
      );
    } else if (result.isEmpty) {
      await UiUtils.showFlushBar(
        rootNavigatorKey.currentContext!,
        msg: "An error was encountered while adding contents!",
        flushbarPosition: FlushbarPosition.TOP,
        vibe: FlushbarVibe.warning,
      );
    } else {
      await UiUtils.showFlushBar(
        rootNavigatorKey.currentContext!,
        msg: "An error occured while adding contents",
        vibe: FlushbarVibe.error,
      );
    }
  }

  static Future<bool> onClickToAddLinkContent(String link, {required CourseCollection collection, String? title}) async{
    final contentHash = BasicUtils.calculateStringHash(link);
    final CourseContent? sameHashedContent = await CourseCollectionRepo.findFirstDuplicateByHash(collection, contentHash);
    if(sameHashedContent != null){
      log("Duplicate link exists");
      return false;
    }

    final CourseContent newContent = CourseContent.create(
      contentHash: contentHash,
      parentId: collection.collectionId,
      title: title ?? "Unknown link",
      path: FileDetails(),
      courseContentType: CourseContentType.link,
    );
    return await CourseCollectionRepo.addContent(newContent);
  }
}
