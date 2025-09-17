import 'dart:io';
import 'dart:typed_data';

import 'package:archive/archive.dart';
import 'package:path/path.dart' as p;
import 'package:path_provider/path_provider.dart';

class HandleArchiveUc {
  /// Extracts an archive into the application's temporary/cache directory.
/// Returns a List<String> of absolute paths created (files and directories).
Future<List<String>> extractArchiveToCache(File archiveFile, {String? destSubDirName}) async {
  if (!await archiveFile.exists()) {
    throw ArgumentError('archiveFile does not exist: ${archiveFile.path}');
  }

  final bytes = await archiveFile.readAsBytes();
  final archive = _decodeArchiveSafe(bytes);

  if (archive == null || archive.isEmpty) {
    throw FormatException('Not a supported/extractable archive.');
  }

  final cacheDir = await getTemporaryDirectory();
  final baseName = destSubDirName ??
      '${p.basenameWithoutExtension(archiveFile.path)}_${DateTime.now().millisecondsSinceEpoch}';
  final outDir = Directory(p.join(cacheDir.path, baseName));
  await outDir.create(recursive: true);

  final List<String> createdPaths = [];

  for (final file in archive.files) {
    final rawName = file.name;
    if (rawName.isEmpty) continue;

    final safeRelPath = _sanitizeMemberPath(rawName);
    if (safeRelPath.isEmpty) continue;

    final outPath = p.join(outDir.path, safeRelPath);

    if (file.isFile) {
      final outFile = File(outPath);
      await outFile.parent.create(recursive: true);
      final data = file.content as List<int>;
      await outFile.writeAsBytes(data, flush: true);
      createdPaths.add(outFile.path);
    } else {
      final dir = Directory(outPath);
      await dir.create(recursive: true);
      createdPaths.add(dir.path);
    }
  }

  return createdPaths;
}

/// Clears the app temporary/cache directory. If [subDirName] is provided,
/// only that sub-directory inside the cache will be deleted; otherwise all
/// entries inside the cache directory will be removed (but the cache dir itself remains).
Future<void> clearCacheDir({String? subDirName}) async {
  final cacheDir = await getTemporaryDirectory();

  if (subDirName != null && subDirName.isNotEmpty) {
    final target = Directory(p.join(cacheDir.path, subDirName));
    if (await target.exists()) {
      await target.delete(recursive: true);
    }
    return;
  }

  // remove all children of cacheDir
  await for (final entity in cacheDir.list(followLinks: false)) {
    try {
      if (entity is File) {
        await entity.delete();
      } else if (entity is Directory) {
        await entity.delete(recursive: true);
      } else {
        await entity.delete();
      }
    } catch (_) {
      // ignore individual failures
    }
  }
}

/// Returns true if the file appears to be a supported archive (we try to decode
/// it using common decoders). This physically attempts decode attempts but does
/// not write anything.
Future<bool> isSupportedByArchive(File archiveFile) async {
  if (!await archiveFile.exists()) return false;
  final bytes = await archiveFile.readAsBytes();
  final archive = _decodeArchiveSafe(bytes);
  return archive != null && archive.isNotEmpty;
}

/// ----------------- Internal helpers -----------------

/// Try multiple decoders safely and return the first successful Archive, or null.
Archive? _decodeArchiveSafe(Uint8List bytes) {
  // 1) try zip
  try {
    final arch = ZipDecoder().decodeBytes(bytes, verify: true);
    if (arch.isNotEmpty) return arch;
  } catch (_) {}

  // 2) try tar (raw)
  try {
    final arch = TarDecoder().decodeBytes(bytes);
    if (arch.isNotEmpty) return arch;
  } catch (_) {}

  // 3) try gzip -> tar (tar.gz, .tgz)
  try {
    final decompressed = GZipDecoder().decodeBytes(bytes);
    try {
      final arch = TarDecoder().decodeBytes(decompressed);
      if (arch.isNotEmpty) return arch;
    } catch (_) {
      // if gz contained a single file (not tar), convert to Archive manually
      final file = ArchiveFile('file', decompressed.length, decompressed);
      return Archive()..addFile(file);
    }
  } catch (_) {}

  // 4) try bzip2 -> tar (tar.bz2)
  try {
    final decompressed = BZip2Decoder().decodeBytes(bytes);
    try {
      final arch = TarDecoder().decodeBytes(decompressed);
      if (arch.isNotEmpty) return arch;
    } catch (_) {
      final file = ArchiveFile('file', decompressed.length, decompressed);
      return Archive()..addFile(file);
    }
  } catch (_) {}

  // If nothing matched, return null
  return null;
}

/// Sanitize member paths to avoid traversal (zip-slip).
/// Removes drive letters, converts backslashes to forward slashes,
/// removes '..' and leading separators.
String _sanitizeMemberPath(String raw) {
  var normalized = raw.replaceAll(r'\', '/'); // unify windows paths
  normalized = normalized.replaceAll(RegExp(r'^[A-Za-z]:/'), ''); // remove windows drive if present
  final parts = p.split(normalized).where((s) => s.isNotEmpty && s != '..').toList();
  return p.joinAll(parts);
}

}