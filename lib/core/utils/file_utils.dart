import 'dart:io';

import 'package:path_provider/path_provider.dart';
import 'package:path/path.dart' as p;

export 'dart:io';

// enum FileType{
//   image,
//   document,
//   video,
// }

enum AppDirType { documents, appSupport, temporary, cache }

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
  static Future<String> storeFile({required File file, String folderPath = ''}) async {
    return await _storeToApplicationsDocumentsDirectory(file, folderPath);
  }

  /// Deletes [relativePath] under the selected [base] directory.
  /// e.g. if base==documents and relativePath=="foo/bar",
  /// this will delete <appDocDir>/foo/bar recursively.
  static Future<bool> deleteAppDirectory({required String relativePath, AppDirType base = AppDirType.documents}) async {
    try {
      Directory baseDir;
      switch (base) {
        case AppDirType.appSupport:
          baseDir = await getApplicationSupportDirectory();
          break;
        case AppDirType.temporary:
          baseDir = await getTemporaryDirectory();
          break;
        case AppDirType.cache:
          baseDir = await getTemporaryDirectory(); // or getCacheDirectory() on some platforms
          break;
        case AppDirType.documents:
          baseDir = await getApplicationDocumentsDirectory();
          break;
      }

      final targetDir = Directory(p.join(baseDir.path, relativePath));
      if (await targetDir.exists()) {
        await targetDir.delete(recursive: true);
      }
      return true;
    } catch (e) {
      print('deleteAppDirectory error: $e');
      return false;
    }
  }

  /// Returns true if a file at [path] exists and is accessible.
  static Future<bool> fileExists(String path) async {
    try {
      return await File(path).exists();
    } catch (_) {
      // e.g. bad path or permission error
      return false;
    }
  }

  /// Returns the file size in bytes, or 0 if the file doesn't exist (or on error).
  static Future<int> fileSize(String path) async {
    try {
      final file = File(path);
      if (!await file.exists()) return 0;
      return await file.length();
    } catch (_) {
      return 0;
    }
  }
}
