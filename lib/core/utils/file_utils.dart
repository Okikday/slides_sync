import 'dart:io';

import 'package:path_provider/path_provider.dart';
import 'package:path/path.dart' as p;

// enum FileType{
//   image,
//   document,
//   video,
// }

class FileUtils {
  static Future<String> _storeToApplicationsDocumentsDirectory(File file, String folderPath) async {
    final Directory baseDir = await getApplicationDocumentsDirectory();
    final String fileName = p.basename(file.path);
    final String targetDirPath = p.join(baseDir.path, folderPath);

    final Directory targetDir = Directory(targetDirPath);
    if (!(await targetDir.exists())) {
      await targetDir.create(recursive: true);
    }

    final String newPath = p.join(targetDirPath, fileName);
    await file.copy(newPath);
    return newPath;
  }

  /// This stores File to App's Document Directory.
  /// Returns the path it's stored to.
  static Future<String> storeFile({required File file, required String folderPath}) async {
    return _storeToApplicationsDocumentsDirectory(file, folderPath);
  }
}
