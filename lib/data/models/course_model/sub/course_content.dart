// ignore_for_file: public_member_api_docs, sort_constructors_first
import 'dart:convert';
import 'dart:developer';
import 'dart:io';

import 'package:isar/isar.dart';

import 'package:slides_sync/core/models/file_details.dart';
import 'package:slides_sync/data/models/course_model/sub/course_content_type.dart';

export 'course_content_type.dart';

part 'course_content.g.dart';

@collection
class CourseContent {
  Id id = Isar.autoIncrement;

  /// Holds the hash of the content basically
  @Index()
  late String contentHash;

  late String parentId;
  late String title;

  /// appended with type before path/link e.g. "file:anonymous.jpg" or "link:https://image.jpg"
  late String path;

  DateTime? createdAt;
  late String description;

  @Enumerated(EnumType.ordinal)
  late CourseContentType courseContentType;

  late String metadataJson;

  CourseContent();

  factory CourseContent.create({
    required String contentHash,
    required String parentId,
    required String title,
    required FileDetails path,
    DateTime? createdAt,
    required CourseContentType courseContentType,
    String description = '',
    String metadataJson = '{}',
  }) {
    final content =
        CourseContent()
          ..contentHash = contentHash
          ..parentId = parentId
          ..title = title
          ..path = path.toJson()
          ..createdAt = createdAt ?? DateTime.now()
          ..courseContentType = courseContentType
          ..description = description
          ..metadataJson = metadataJson;
    return content;
  }

  CourseContent copyWith({
    required String contentHash,
    String? parentId,
    String? title,
    FileDetails? path,
    DateTime? createdAt,
    String? description,
    CourseContentType? courseContentType,
    String? metadataJson,
  }) {
    return CourseContent()
      ..id = id
      ..contentHash = contentHash
      ..parentId = parentId ?? this.parentId
      ..title = title ?? this.title
      ..path = path?.toJson() ?? this.path
      ..createdAt = createdAt ?? this.createdAt
      ..description = description ?? this.description
      ..courseContentType = courseContentType ?? this.courseContentType
      ..metadataJson = metadataJson ?? this.metadataJson;
  }

  Map<String, dynamic> toMap() {
    return {
      'id': id,
      'contentHash': contentHash,
      'parentId': parentId,
      'title': title,
      'path': path,
      'createdAt': createdAt?.toIso8601String(),
      'description': description,
      'courseContentType': courseContentType.index,
      'metadataJson': metadataJson,
    };
  }

  factory CourseContent.fromMap(Map<String, dynamic> map) {
    final content = CourseContent();
    content.id = map['id'] ?? Isar.autoIncrement;
    content.contentHash = map['contentHash'] ?? '';
    content.parentId = map['parentId'] ?? '';
    content.title = map['title'] ?? '';
    content.path = map['path'] ?? '';
    content.createdAt = map['createdAt'] != null ? DateTime.tryParse(map['createdAt']) : null;
    content.description = map['description'] ?? '';
    content.courseContentType = CourseContentType.values[map['courseContentType'] ?? 0];
    content.metadataJson = map['metadataJson'] ?? '{}';
    return content;
  }

  String toJson() => jsonEncode(toMap());

  factory CourseContent.fromJson(String source) => CourseContent.fromMap(jsonDecode(source));

  @override
  bool operator ==(covariant CourseContent other) {
    if (identical(this, other)) return true;

    return other.id == id &&
        other.contentHash == contentHash &&
        other.parentId == parentId &&
        other.title == title &&
        other.path == path &&
        other.createdAt == createdAt &&
        other.description == description &&
        other.courseContentType == courseContentType &&
        other.metadataJson == metadataJson;
  }

  @override
  int get hashCode {
    return id.hashCode ^
        contentHash.hashCode ^
        parentId.hashCode ^
        title.hashCode ^
        path.hashCode ^
        createdAt.hashCode ^
        description.hashCode ^
        courseContentType.hashCode ^
        metadataJson.hashCode;
  }
}

extension CourseContentExtension on CourseContent {
  String get relativePath => "$parentId${Platform.pathSeparator}$id";
  String get absolutePath => "courses${Platform.pathSeparator}$relativePath";
  String get collectionId => parentId;
}
