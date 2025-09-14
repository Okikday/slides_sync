// ignore_for_file: public_member_api_docs, sort_constructors_first
import 'dart:convert';

import 'package:isar/isar.dart';
import 'package:uuid/uuid.dart';

import 'package:slides_sync/domain/models/file_details.dart';
import 'package:slides_sync/domain/models/course_model/sub/course_collection.dart';
import 'package:slides_sync/shared/helpers/course_formatter.dart';

export 'package:slides_sync/domain/models/course_model/sub/course_collection.dart';
export 'package:slides_sync/domain/models/course_model/sub/course_content.dart';

part 'course.g.dart';

@collection
class Course {
  Id id = Isar.autoIncrement;

  @Index()
  late String courseId;
  late String courseTitle;
  String description = '';
  String imageLocationJson = '{}';
  DateTime? createdAt;
  DateTime? lastUpdated;

  final IsarLinks<CourseCollection> collections = IsarLinks<CourseCollection>();

  String courseMetadataJson = '{}';

  Course();

  factory Course.create({
    required String courseTitle,
    String description = '',
    DateTime? createdAt,
    FileDetails? imageLocation,
    String courseMetadataJson = '{}',
  }) {
    return Course()
      ..courseId = const Uuid().v4()
      ..courseTitle = courseTitle
      ..description = description
      ..createdAt = createdAt ?? DateTime.now()
      ..lastUpdated = DateTime.now()
      ..imageLocationJson = imageLocation?.toJson() ?? '{}'
      ..courseMetadataJson = courseMetadataJson;
  }

  Map<String, dynamic> toMap() {
    return {
      'id': id,
      'courseId': courseId,
      'courseTitle': courseTitle,
      'description': description,
      'imageLocationJson': imageLocationJson,
      'createdAt': createdAt?.toIso8601String(),
      'lastUpdated': lastUpdated?.toIso8601String(),
      'courseMetadataJson': courseMetadataJson,
      // Note: subCollections and rootContents are IsarLinks, not serialized here
    };
  }

  factory Course.fromMap(Map<String, dynamic> map) {
    final course = Course();
    course.id = map['id'] ?? Isar.autoIncrement;
    course.courseId = map['courseId'] ?? '';
    course.courseTitle = map['courseTitle'] ?? '';
    course.description = map['description'] ?? '';
    course.imageLocationJson = map['imageLocationJson'] ?? '{}';
    course.createdAt = map['createdAt'] != null ? DateTime.tryParse(map['createdAt']) : null;
    course.lastUpdated = map['lastUpdated'] != null ? DateTime.tryParse(map['lastUpdated']) : null;
    course.courseMetadataJson = map['courseMetadataJson'] ?? '{}';
    return course;
  }

  String toJson() => jsonEncode(toMap());

  factory Course.fromJson(String source) => Course.fromMap(jsonDecode(source));

  @override
  bool operator ==(covariant Course other) {
    if (identical(this, other)) return true;

    return other.id == id &&
        other.courseId == courseId &&
        other.courseTitle == courseTitle &&
        other.description == description &&
        other.createdAt == createdAt &&
        other.lastUpdated == lastUpdated;
  }

  @override
  int get hashCode {
    return id.hashCode ^
        courseId.hashCode ^
        courseTitle.hashCode ^
        description.hashCode ^
        createdAt.hashCode ^
        lastUpdated.hashCode ^
        collections.hashCode;
  }

  @override
  String toString() {
    return 'Course(id: $id, courseId: $courseId, courseTitle: $courseTitle, description: $description, createdAt: $createdAt, lastUpdated: $lastUpdated)';
  }
}

extension CourseExtension on Course {
  String get courseName => CourseFormatter.separateCodeFromTitle(courseTitle).courseName;
  String get courseCode => CourseFormatter.separateCodeFromTitle(courseTitle).courseCode;
  Course copyWith({
    String? courseId,
    String? courseTitle,
    String? description,
    String? imageLocationJson,
    DateTime? createdAt,
    DateTime? lastUpdated,
    String? courseMetadataJson,
  }) {
    return this
      ..courseId = courseId ?? this.courseId
      ..courseTitle = courseTitle ?? this.courseTitle
      ..description = description ?? this.description
      ..imageLocationJson = imageLocationJson ?? this.imageLocationJson
      ..createdAt = createdAt ?? this.createdAt
      ..lastUpdated = lastUpdated ?? this.lastUpdated
      ..courseMetadataJson = courseMetadataJson ?? this.courseMetadataJson;
  }
}

extension StringExtension on String {
  String get courseName => CourseFormatter.separateCodeFromTitle(this).courseName;
  String get courseCode => CourseFormatter.separateCodeFromTitle(this).courseCode;
}
