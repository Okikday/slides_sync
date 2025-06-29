// ignore_for_file: public_member_api_docs, sort_constructors_first
import 'dart:convert';

class FileDetails {
  final String urlPath;
  final String filePath;
  final String fileHash;
  FileDetails({this.urlPath = '', this.filePath = '', this.fileHash = ''});

  bool get containsFilePath => urlPath.isNotEmpty || filePath.isNotEmpty;
  bool get containsfileHash => fileHash.isNotEmpty;

  FileDetails copyWith({String? urlPath, String? filePath, String? fileHash}) {
    return FileDetails(urlPath: urlPath ?? this.urlPath, filePath: filePath ?? this.filePath, fileHash: fileHash ?? this.fileHash);
  }

  Map<String, dynamic> toMap() {
    return <String, dynamic>{'urlPath': urlPath, 'filePath': filePath, 'fileHash': fileHash};
  }

  factory FileDetails.fromMap(Map<String, dynamic> map) {
    return FileDetails(urlPath: map['urlPath'] as String? ?? '', filePath: map['filePath'] as String? ?? '', fileHash: map['fileHash'] as String? ?? '');
  }

  String toJson() => json.encode(toMap());

  factory FileDetails.fromJson(String source) => FileDetails.fromMap(json.decode(source) as Map<String, dynamic>);

  @override
  String toString() => 'FileDetails(urlPath: $urlPath, filePath: $filePath, fileHash: $fileHash)';

  @override
  bool operator ==(covariant FileDetails other) {
    if (identical(this, other)) return true;

    return other.urlPath == urlPath && other.filePath == filePath && other.fileHash == fileHash;
  }


  @override
  int get hashCode => urlPath.hashCode ^ filePath.hashCode ^ fileHash.hashCode;
}

extension FileDetailsStringExtension on String {
  FileDetails get fileDetails => FileDetails.fromJson(this);
  bool get containsFilePath => urlPath.isNotEmpty || filePath.isNotEmpty;
  bool get containsAnyFilePath => containsFilePath;
  String get filePath => fileDetails.filePath;
  String get urlPath => fileDetails.urlPath;

  bool sameFile(FileDetails fileDet) => fileDet.fileHash == fileDetails.fileHash;
  
}
