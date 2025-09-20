// ignore_for_file: public_member_api_docs, sort_constructors_first
import 'dart:convert';
import 'dart:io';

import 'package:isar/isar.dart';
import 'package:uuid/uuid.dart';

import 'package:slides_sync/domain/models/file_details.dart';
import 'package:slides_sync/domain/models/course_model/sub/course_content_type.dart';

export 'course_content_type.dart';

part 'course_content.g.dart';

@collection
class CourseContent {
  Id id = Isar.autoIncrement;

  /// Holds the hash of the content basically
  @Index()
  late String contentHash;

  @Index()
  late String contentId;

  @Index()
  late String parentId;
  
  @Index(caseSensitive: false)
  late String title;

  /// appended with type before path/link e.g. "file:anonymous.jpg" or "link:https://image.jpg"
  late String path;

  DateTime? createdAt;
  DateTime? lastModified;
  late String description;

  @Enumerated(EnumType.ordinal)
  late CourseContentType courseContentType;

  late String metadataJson;

  CourseContent();

  factory CourseContent.create({
    required String contentHash,
    String? contentId,
    required String parentId,
    required String title,
    required FileDetails path,
    DateTime? createdAt,
    DateTime? lastModified,
    required CourseContentType courseContentType,
    String description = '',
    String metadataJson = '{}',
  }) {
    final content =
        CourseContent()
          ..contentHash = contentHash
          ..contentId = contentId ?? const Uuid().v4()
          ..parentId = parentId
          ..title = title
          ..path = path.toJson()
          ..createdAt = createdAt ?? DateTime.now()
          ..lastModified = lastModified ?? DateTime.now()
          ..courseContentType = courseContentType
          ..description = description
          ..metadataJson = metadataJson;
    return content;
  }

  Map<String, dynamic> toMap() {
    return {
      'id': id,
      'contentHash': contentHash,
      'contentId': contentId,
      'parentId': parentId,
      'title': title,
      'path': path,
      'createdAt': createdAt?.toIso8601String(),
      'lastModified': lastModified?.toIso8601String(),
      'description': description,
      'courseContentType': courseContentType.index,
      'metadataJson': metadataJson,
    };
  }

  factory CourseContent.fromMap(Map<String, dynamic> map) {
    return CourseContent()
      ..id = map['id'] ?? Isar.autoIncrement
      ..contentHash = map['contentHash'] ?? ''
      ..contentId = map['contentId'] ?? ''
      ..parentId = map['parentId'] ?? ''
      ..title = map['title'] ?? ''
      ..path = map['path'] ?? ''
      ..createdAt = map['createdAt'] != null ? DateTime.tryParse(map['createdAt']) : null
      ..lastModified = map['lastModified'] != null ? DateTime.tryParse(map['lastModified']) : null
      ..description = map['description'] ?? ''
      ..courseContentType = CourseContentType.values[map['courseContentType'] ?? 0]
      ..metadataJson = map['metadataJson'] ?? '{}';
  }

  String toJson() => jsonEncode(toMap());

  factory CourseContent.fromJson(String source) => CourseContent.fromMap(jsonDecode(source));

  @override
  bool operator ==(covariant CourseContent other) {
    if (identical(this, other)) return true;

    return other.id == id &&
        other.contentHash == contentHash &&
        other.contentId == contentId &&
        other.parentId == parentId &&
        other.title == title &&
        other.path == path &&
        other.createdAt == createdAt &&
        other.lastModified == lastModified &&
        other.description == description &&
        other.courseContentType == courseContentType &&
        other.metadataJson == metadataJson;
  }

  @override
  int get hashCode {
    return id.hashCode ^
        contentHash.hashCode ^
        contentId.hashCode ^
        parentId.hashCode ^
        title.hashCode ^
        path.hashCode ^
        createdAt.hashCode ^
        lastModified.hashCode ^
        description.hashCode ^
        courseContentType.hashCode ^
        metadataJson.hashCode;
  }

  @override
  String toString() {
    return 'CourseContent(id: $id, contentHash: $contentHash, contentId: $contentId, parentId: $parentId, title: $title, path: $path, createdAt: $createdAt, lastModified: $lastModified, description: $description, courseContentType: $courseContentType, metadataJson: $metadataJson)';
  }
}

extension CourseContentExtension on CourseContent {
  String get relativePath => "$parentId${Platform.pathSeparator}$contentId";
  String get absolutePath => "courses${Platform.pathSeparator}$relativePath";
  String get collectionId => parentId;

  CourseContent copyWith({
    required String contentHash,
    String? parentId,
    String? title,
    FileDetails? path,
    DateTime? createdAt,
    DateTime? lastModified,
    String? description,
    CourseContentType? courseContentType,
    String? metadataJson,
  }) {
    return this
      ..contentHash = contentHash
      ..parentId = parentId ?? this.parentId
      ..title = title ?? this.title
      ..path = path?.toJson() ?? this.path
      ..createdAt = createdAt ?? this.createdAt
      ..lastModified = lastModified ?? this.lastModified
      ..description = description ?? this.description
      ..courseContentType = courseContentType ?? this.courseContentType
      ..metadataJson = metadataJson ?? this.metadataJson;
  }
}
