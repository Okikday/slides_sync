// ignore_for_file: public_member_api_docs, sort_constructors_first
import 'dart:convert';

class ImageLocation {
  final String urlPath;
  final String filePath;

  bool get containsImagePath => urlPath.isNotEmpty || filePath.isNotEmpty;

  ImageLocation({this.urlPath = '', this.filePath = ''});

  factory ImageLocation.fromJson(String json) {
    try {
      final Map<String, dynamic> decodedJson = Map<String, dynamic>.from(jsonDecode(json));
      return ImageLocation(urlPath: decodedJson['url'] as String? ?? '', filePath: decodedJson['file'] as String? ?? '');
    } catch (e) {
      return ImageLocation();
    }
  }

  Map<String, dynamic> toMap() => {'url': urlPath, 'file': filePath};

  String toJson() => jsonEncode(toMap());

  @override
  bool operator ==(covariant ImageLocation other) {
    if (identical(this, other)) return true;

    return other.urlPath == urlPath && other.filePath == filePath;
  }

  @override
  int get hashCode => urlPath.hashCode ^ filePath.hashCode;
}

extension ImageLocationExtension on String {
  ImageLocation get imageLocation => ImageLocation.fromJson(this);
  bool get containsAnyImagePath => imageLocation.containsImagePath;
  String get filePath => imageLocation.filePath;
  String get urlPath => imageLocation.urlPath;
}
