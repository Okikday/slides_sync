import 'dart:io';

import 'package:file_picker/file_picker.dart';
import 'package:image_picker/image_picker.dart';
import 'package:path_provider/path_provider.dart';
import 'package:slides_sync/data/models/course_model/course.dart';



/// Use this class to pick various content types and copy them into the app's cache directory.
class SelectContentsUc {
  const SelectContentsUc([CourseCollection? collection]);

  /// Picks files based on the [type] and returns a list of cached [File]s.
  Future<List<File>?> referToAddContents(CourseContentType type) async {
    switch (type) {
      case CourseContentType.unknown:
        return await _selectFiles();

      case CourseContentType.document:
        return await _selectDocuments();

      case CourseContentType.image:
        return await _selectImages();

      case CourseContentType.video:
        return await _selectVideos();

      case CourseContentType.audio:
        return await _selectAudios();


      default:
        return null;
    }
  }

  /// Helper to copy picked files into cache and return them.
  Future<List<File>?> _selectFiles() async {
    final result = await FilePicker.platform.pickFiles(allowMultiple: true);
    if (result == null) return null;
    return _copyToCache(result.paths.whereType<String>());
  }

  Future<List<File>?> _selectDocuments() async {
    final result = await FilePicker.platform.pickFiles(
      type: FileType.custom,
      allowMultiple: true,
      allowedExtensions: ['pdf', 'docx', 'xlsx'],
    );
    if (result == null) return null;
    return _copyToCache(result.paths.whereType<String>());
  }

  Future<List<File>?> _selectImages() async {
    final picker = ImagePicker();
    final images = await picker.pickMultiImage();
    if (images.isEmpty) return null;
    return _copyToCache(images.map((x) => x.path));
  }

  Future<List<File>?> _selectVideos() async {
    final picker = ImagePicker();
    final mediaList = await picker.pickMultipleMedia();
    if (mediaList.isEmpty) return null;
    // Filter videos if needed, here assuming all mediaList
    return _copyToCache(mediaList.map((x) => x.path));
  }

  Future<List<File>?> _selectAudios() async {
    final result = await FilePicker.platform.pickFiles(type: FileType.audio);
    if (result == null) return null;
    return _copyToCache(result.paths.whereType<String>());
  }

  /// Copies each source file at [paths] into the app cache directory, returns new File list.
  Future<List<File>> _copyToCache(Iterable<String> paths) async {
    final cacheDir = await getTemporaryDirectory();
    final List<File> saved = [];
    for (var sourcePath in paths) {
      final filename = sourcePath.split(Platform.pathSeparator).last;
      final dest = File('${cacheDir.path}${Platform.pathSeparator}$filename');
      final copied = await File(sourcePath).copy(dest.path);
      saved.add(copied);
    }
    return saved;
  }
}
