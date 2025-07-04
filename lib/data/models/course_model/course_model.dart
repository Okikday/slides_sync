import 'dart:convert';
import 'package:isar/isar.dart';
import 'package:collection/collection.dart';
import 'package:slides_sync/core/models/file_details.dart';
import 'package:slides_sync/data/models/course_model/sub/course_content.dart';
import 'package:slides_sync/data/models/course_model/sub/course_sub_collection.dart';
import 'package:slides_sync/shared/helpers/course_formatter.dart';
import 'package:uuid/uuid.dart';

export 'package:slides_sync/data/models/course_model/sub/course_sub_collection.dart';
export 'package:slides_sync/data/models/course_model/sub/course_content.dart';

part 'course_model.g.dart';

@collection
class CourseModel {
  Id id = Isar.autoIncrement;

  final String courseId;
  final String courseTitle;
  final String description;
  final String imageLocationJson;
  final DateTime? createdAt;
  final DateTime? lastUpdated;
  final List<CourseSubCollection> subCollections;
  final List<CourseContent> rootContents;
  final String courseMetadataJson;

  CourseModel({
    this.courseId = '',
    this.courseTitle = '',
    this.createdAt,
    this.lastUpdated,
    this.description = '',
    this.imageLocationJson = '{}',
    this.subCollections = const <CourseSubCollection>[],
    this.rootContents = const <CourseContent>[],
    this.courseMetadataJson = '{}',
  });

  factory CourseModel.create({
    required String courseTitle,
    String description = '',
    DateTime? createdAt,
    FileDetails? imageLocation,
    List<CourseSubCollection> subCollections = const [],
    List<CourseContent> rootContents = const [],
    String courseMetadataJson = '{}',
  }) {
    return CourseModel(
      courseId: const Uuid().v4(),
      courseTitle: courseTitle,
      description: description,
      createdAt: createdAt ?? DateTime.now(),
      lastUpdated: DateTime.now(),
      imageLocationJson: imageLocation?.toJson() ?? '{}',
      subCollections: subCollections,
      rootContents: rootContents,
      courseMetadataJson: courseMetadataJson,
    );
  }

  CourseModel copyWith({
    String? courseId,
    String? courseTitle,
    DateTime? createdAt,
    String? description,
    FileDetails? imageLocation,
    List<CourseSubCollection>? subCollections,
    List<CourseContent>? rootContents,
    String? courseMetadataJson,
  }) {
    return CourseModel(
      courseId: courseId ?? this.courseId,
      courseTitle: courseTitle ?? this.courseTitle,
      createdAt: createdAt ?? this.createdAt,
      lastUpdated: DateTime.now(),
      description: description ?? this.description,
      imageLocationJson: imageLocation?.toJson() ?? imageLocationJson,
      subCollections: subCollections ?? List<CourseSubCollection>.from(this.subCollections),
      rootContents: rootContents ?? List<CourseContent>.from(this.rootContents),
      courseMetadataJson: courseMetadataJson ?? this.courseMetadataJson,
    )..id = id;
  }

  Map<String, dynamic> toMap() {
    return {
      'id': id,
      'courseId': courseId,
      'createdAt': createdAt?.toIso8601String(),
      'lastUpdated': lastUpdated?.toIso8601String(),
      'courseTitle': courseTitle,
      'description': description,
      'imageLocationJson': imageLocationJson,
      'subCollections': subCollections,
      'rootContents': rootContents,
      'courseMetadataJson': courseMetadataJson,
    };
  }

  factory CourseModel.fromMap(Map<String, dynamic> map) {
    return CourseModel(
      courseId: map['courseId'],
      courseTitle: map['courseTitle'],
      createdAt: map['createdAt'] == null ? DateTime.now() : DateTime.tryParse(map['createdAt'] as String) ?? DateTime.now(),
      lastUpdated: map['lastUpdated'] == null ? DateTime.now() : DateTime.tryParse(map['lastUpdated'] as String) ?? DateTime.now(),
      description: map['description'],
      imageLocationJson: map['imageLocationJson'] as String? ?? '{}',
      subCollections: List<CourseSubCollection>.from(
        (map['subCollections'] as List<String>).map((e) => CourseSubCollection.fromJson(e)).toList(),
      ),
      rootContents: List<CourseContent>.from((map['rootContents'] as List<String>).map((e) => CourseContent.fromJson(e)).toList()),
      courseMetadataJson: map['courseMetadata'] ?? '{}',
    )..id = map['id'] ?? Isar.autoIncrement;
  }

  String toJson() => jsonEncode(toMap());

  factory CourseModel.fromJson(String source) => CourseModel.fromMap(jsonDecode(source));

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is CourseModel &&
          runtimeType == other.runtimeType &&
          id == other.id &&
          courseId == other.courseId &&
          courseTitle == other.courseTitle &&
          createdAt == other.createdAt &&
          lastUpdated == other.lastUpdated &&
          description == other.description &&
          imageLocationJson == other.imageLocationJson &&
          const DeepCollectionEquality().equals(subCollections, other.subCollections) &&
          const DeepCollectionEquality().equals(rootContents, other.rootContents) &&
          courseMetadataJson == other.courseMetadataJson;

  @override
  int get hashCode => Object.hash(
    id,
    courseId,
    createdAt,
    lastUpdated,
    courseTitle,
    description,
    imageLocationJson,
    const DeepCollectionEquality().hash(subCollections),
    const DeepCollectionEquality().hash(rootContents),
    courseMetadataJson,
  );
}

extension CourseModelExtension on CourseModel {
  String get courseName => CourseFormatter.separateCodeFromTitle(courseTitle).courseName;
  String get courseCode => CourseFormatter.separateCodeFromTitle(courseTitle).courseCode;
}
