import 'dart:developer';
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

    final String newPath = getUniqueFilePath(targetDirPath, fileName);
    await file.copy(newPath);
    return newPath;
  }

  /// This stores File to App's Document Directory.
  /// Returns the path it's stored to.
  static Future<String> storeFile({required File file, String folderPath = ''}) async {
    return await _storeToApplicationsDocumentsDirectory(file, folderPath);
  }

  static String getUniqueFilePath(String dirPath, String fileName) {
    String baseName = p.basenameWithoutExtension(fileName);
    String extension = p.extension(fileName);
    String newPath = p.join(dirPath, fileName);
    int counter = 1;

    while (File(newPath).existsSync()) {
      newPath = p.join(dirPath, '$baseName($counter)$extension');
      counter++;
    }

    return newPath;
  }

  /// Attempts to delete the file at [path].
  ///
  /// Returns `true` if the file existed and was deleted successfully,
  /// `false` if the file did not exist or if any error occurred.
  static Future<bool> deleteFileAtPath(String path) async {
    try {
      final file = File(path);
      if (await file.exists()) {
        await file.delete();
        return true;
      } else {
        // File wasn’t there
        return false;
      }
    } catch (e) {
      // If something went wrong (e.g. permissions), treat as “couldn’t delete”
      return false;
    }
  }

  /// Deletes [relativePath] under the selected [base] directory.
  /// e.g. if base==documents and relativePath=="foo/bar",
  /// this will delete <appDocDir>/foo/bar recursively.
  static Future<bool> deleteFromAppDirectory({required String relativePath, AppDirType base = AppDirType.documents}) async {
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

  /// Clears the cache and temporary directories.
  Future<void> clearCacheOrTemp() async {
    try {
      final tempDir = await getTemporaryDirectory();
      if (tempDir.existsSync()) {
        tempDir.deleteSync(recursive: true);
      }

      final cacheDir = await getApplicationCacheDirectory();
      if (cacheDir.existsSync()) {
        cacheDir.deleteSync(recursive: true);
      }

      log('Cache and temporary directories cleared.');
    } catch (e) {
      log('Error clearing cache/temp: $e');
    }
  }

  /// Searches for a file by name in the given [searchPath] or
  /// defaults to the app’s application directory.
  Future<File?> searchFile(String fileName, {Directory? searchPath}) async {
    try {
      final Directory dir = searchPath ?? await getApplicationDocumentsDirectory();

      File? result;

      await for (var entity in dir.list(recursive: true, followLinks: false)) {
        if (entity is File && entity.path.endsWith(fileName)) {
          result = entity;
          break; // Stop at first match
        }
      }

      if (result != null) {
        log('File found: ${result.path}');
      } else {
        log('File not found.');
      }

      return result;
    } catch (e) {
      log('Error searching for file: $e');
      return null;
    }
  }
}
