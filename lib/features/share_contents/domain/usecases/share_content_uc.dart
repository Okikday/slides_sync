import 'dart:io';

import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:path_provider/path_provider.dart';
import 'package:share_plus/share_plus.dart';
import 'package:printing/printing.dart';
import 'package:slides_sync/core/utils/file_utils.dart';

class ShareContentUc {
  Future<void> shareText(BuildContext context, String text) async {
    final box = context.findRenderObject() as RenderBox?;
    await SharePlus.instance.share(
      ShareParams(text: text, subject: "SlideSync", sharePositionOrigin: box!.localToGlobal(Offset.zero) & box.size),
    );
  }

  Future<void> shareFile(BuildContext context, File file, {String? filename}) async {
    final box = context.findRenderObject() as RenderBox?;
    final String path;

    if (filename != null) {
      final res = await FileUtils.storeFile(file: file, base: AppDirType.temporary, newFileName: filename);
      path = res;
    } else {
      path = file.path;
    }

    // Use XFile for files
    final xf = XFile(path);

    await SharePlus.instance.share(
      ShareParams(files: [xf], text: "SlideSync", sharePositionOrigin: box!.localToGlobal(Offset.zero) & box.size),
    );
  }

  Future<void> shareFileFromBytes(BuildContext context, Uint8List bytes, String filename) async {
    final box = context.findRenderObject() as RenderBox?;

    // Create a temporary file in cache
    final tempDir = await getTemporaryDirectory();
    final path = '${tempDir.path}/$filename';
    final tempFile = File(path);
    await tempFile.writeAsBytes(bytes, flush: true);

    final xf = XFile(tempFile.path);

    await SharePlus.instance.share(
      ShareParams(
        files: [xf],
        text: "Here is a dynamic file",
        sharePositionOrigin: box!.localToGlobal(Offset.zero) & box.size,
      ),
    );
  }

  Future<void> printPdfFile(String path) async {
  final bytes = await File(path).readAsBytes();
  await Printing.layoutPdf(onLayout: (format) => bytes);
}
}
