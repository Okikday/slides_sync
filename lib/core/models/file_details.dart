// ignore_for_file: public_member_api_docs, sort_constructors_first
import 'dart:convert';

class FileDetails {
  final String urlPath;
  final String filePath;
  final String hash;
  FileDetails({this.urlPath = '', this.filePath = '', this.hash = ''});

  bool get containsFilePath => urlPath.isNotEmpty || filePath.isNotEmpty;
  bool get containsHash => hash.isNotEmpty;

  FileDetails copyWith({String? urlPath, String? filePath, String? hash}) {
    return FileDetails(urlPath: urlPath ?? this.urlPath, filePath: filePath ?? this.filePath, hash: hash ?? this.hash);
  }

  Map<String, dynamic> toMap() {
    return <String, dynamic>{'urlPath': urlPath, 'filePath': filePath, 'hash': hash};
  }

  factory FileDetails.fromMap(Map<String, dynamic> map) {
    return FileDetails(urlPath: map['urlPath'] as String, filePath: map['filePath'] as String, hash: map['hash'] as String);
  }

  String toJson() => json.encode(toMap());

  factory FileDetails.fromJson(String source) => FileDetails.fromMap(json.decode(source) as Map<String, dynamic>);

  @override
  String toString() => 'FileDetails(urlPath: $urlPath, filePath: $filePath, hash: $hash)';

  @override
  bool operator ==(covariant FileDetails other) {
    if (identical(this, other)) return true;

    return other.urlPath == urlPath && other.filePath == filePath && other.hash == hash;
  }

  @override
  int get hashCode => urlPath.hashCode ^ filePath.hashCode ^ hash.hashCode;
}

extension FileDetailsStringExtension on String {
  FileDetails get fileDetails => FileDetails.fromJson(this);
  bool get containsFilePath => urlPath.isNotEmpty || filePath.isNotEmpty;
  bool get containsAnyFilePath => containsFilePath;
  String get filePath => fileDetails.filePath;
  String get urlPath => fileDetails.urlPath;
}
