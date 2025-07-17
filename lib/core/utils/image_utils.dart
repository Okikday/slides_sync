// ignore_for_file: unintended_html_in_doc_comment

import 'dart:io';
import 'dart:typed_data';

import 'package:flutter_image_compress/flutter_image_compress.dart';
import 'package:path/path.dart' as p;
import 'package:path_provider/path_provider.dart';

import 'result.dart';

class ImageUtils {
  /// Compress [inputFile], possibly resizing to [maxWidth]/[maxHeight],
  /// output to either [outputFormat] (jpg/png/webp) or keep the same
  /// format as the input.
  ///
  /// If [targetMB] is provided, we will do a second‐pass quality adjustment
  /// so the result is at or below that size (never dropping below quality=10).
  ///
  /// Returns a new file under the app’s documents directory named
  /// “IMG-YYYYMMDD-WA####.<ext>”.
  static Future<Result<File>> compressImage({
    required File inputFile,
    String? outputFormat,
    int quality = 90,
    double? targetMB,
    int maxWidth = 400,
    int maxHeight = 400,
  }) async {
    try {
      if (!(await inputFile.exists())) {
        return Result.error('Source file does not exist.');
      }

      // Generate a new, unique filename for the output
      final Directory docDir = await getApplicationDocumentsDirectory();
      // Figure out which extension to write
      final String srcExt = p.extension(inputFile.path).replaceFirst('.', '').toLowerCase();
      final String ext = (outputFormat ?? srcExt).toLowerCase();
      final CompressFormat format = _formatFromExt(ext);
      String outPath = await _generateNextFilePath(docDir, ext);
      final lastSeparatorIndex = outPath.lastIndexOf(Platform.pathSeparator);
      final dirPath = "${outPath.substring(0, lastSeparatorIndex + 1)}cache";
      outPath = "$dirPath${outPath.substring(lastSeparatorIndex)}";

      // First‐pass compress
      Uint8List? compressedBytes = await FlutterImageCompress.compressWithFile(
        inputFile.path,
        minWidth: maxWidth,
        minHeight: maxHeight,
        quality: quality,
        format: format,
      );
      if (compressedBytes == null) {
        return Result.error('Failed to compress image (first pass).');
      }

      // If we have a size target, check and do one more pass of quality‐adjustment
      if (targetMB != null) {
        double currentMB = compressedBytes.length / (1024 * 1024);
        if (currentMB > targetMB) {
          // Calculate a proportional new quality
          int adjustedQuality = ((quality * (targetMB / currentMB)).floor()).clamp(10, quality);

          final Uint8List? reCompressed = await FlutterImageCompress.compressWithFile(
            inputFile.path,
            minWidth: maxWidth,
            minHeight: maxHeight,
            quality: adjustedQuality,
            format: format,
          );
          if (reCompressed != null) {
            compressedBytes = reCompressed;
          }
          // (If reCompressed is null, we’ll just stick with first-pass)
        }
      }

      await Directory(dirPath).create();
      // Write out to disk once
      final File outFile = File(outPath);
      await outFile.writeAsBytes(compressedBytes, flush: true);
      return Result.success(outFile);
    } catch (e, st) {
      return Result.error('Compression error: $e\n$st');
    }
  }

  /// Turn “jpg”, “jpeg”, “png” or “webp” into the right CompressFormat.
  /// Defaults to JPEG if unknown.
  static CompressFormat _formatFromExt(String ext) {
    switch (ext) {
      case 'png':
        return CompressFormat.png;
      case 'webp':
        return CompressFormat.webp;
      case 'jpeg':
      case 'jpg':
      default:
        return CompressFormat.jpeg;
    }
  }

  /// Scans [dir] for files matching IMG-YYYYMMDD-WA####.<ext> and returns
  /// the next available path. (e.g. IMG-20230606-WA0001.jpg, WA0002.jpg…)
  static Future<String> _generateNextFilePath(Directory dir, String ext) async {
    final String date = _todayString;
    final RegExp re = RegExp(r'^IMG-' + date + r'-WA(\d{4})\.' + ext + r'$');
    final List<FileSystemEntity> all = await dir.list().toList();

    int maxSeq = 0;
    for (final f in all) {
      final String name = p.basename(f.path);
      final Match? m = re.firstMatch(name);
      if (m != null) {
        final int seq = int.tryParse(m.group(1)!) ?? 0;
        if (seq > maxSeq) maxSeq = seq;
      }
    }

    final String nextSeq = (maxSeq + 1).toString().padLeft(4, '0');
    final String filename = 'IMG-$date-WA$nextSeq.$ext';
    return p.join(dir.path, filename);
  }

  static String get _todayString {
    final now = DateTime.now();
    final y = now.year.toString().padLeft(4, '0');
    final m = now.month.toString().padLeft(2, '0');
    final d = now.day.toString().padLeft(2, '0');
    return '$y$m$d';
  }
}
