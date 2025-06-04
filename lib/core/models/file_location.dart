// ignore_for_file: public_member_api_docs, sort_constructors_first
import 'dart:convert';

class FileLocation {
  final String urlPath;
  final String filePath;

  bool get containsImagePath => urlPath.isNotEmpty || filePath.isNotEmpty;

  FileLocation({this.urlPath = '', this.filePath = ''});

  factory FileLocation.fromJson(String json) {
    try {
      final Map<String, dynamic> decodedJson = Map<String, dynamic>.from(jsonDecode(json));
      return FileLocation(urlPath: decodedJson['url'] as String? ?? '', filePath: decodedJson['file'] as String? ?? '');
    } catch (e) {
      return FileLocation();
    }
  }

  Map<String, dynamic> toMap() => {'url': urlPath, 'file': filePath};

  String toJson() => jsonEncode(toMap());

  @override
  bool operator ==(covariant FileLocation other) {
    if (identical(this, other)) return true;

    return other.urlPath == urlPath && other.filePath == filePath;
  }

  @override
  int get hashCode => urlPath.hashCode ^ filePath.hashCode;
}

extension FileLocationExtension on String {
  FileLocation get fileLocation => FileLocation.fromJson(this);
  bool get containsAnyImagePath => fileLocation.containsImagePath;
  String get filePath => fileLocation.filePath;
  String get urlPath => fileLocation.urlPath;
}
