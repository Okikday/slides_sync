import 'dart:convert';
import 'package:isar/isar.dart';
import 'package:collection/collection.dart';
import 'package:slides_sync/features/course_mgmt/data/models/course_model/sub/course_content.dart';
import 'package:slides_sync/features/course_mgmt/data/models/course_model/sub/course_sub_collection.dart';
import 'package:uuid/uuid.dart';

export 'package:slides_sync/features/course_mgmt/data/models/course_model/sub/course_sub_collection.dart';
export 'package:slides_sync/features/course_mgmt/data/models/course_model/sub/course_content.dart';

part 'course_model.g.dart';



@collection
class CourseModel {
  Id id = Isar.autoIncrement;

  final String courseId;
  final String courseTitle;
  final String description;
  final String? imagePath;
  final DateTime? createdAt;

  final List<CourseSubCollection> subCollections;
  final List<CourseContent> rootContents;
  final String courseMetadataJson;

  CourseModel({
    this.courseId = '',
    this.courseTitle = '',
    this.createdAt,
    this.description = '',
    this.imagePath,
    this.subCollections = const <CourseSubCollection>[],
    this.rootContents = const <CourseContent>[],
    this.courseMetadataJson = '{}',
  });

  factory CourseModel.create({
    required String courseTitle,
    String description = '',
    DateTime? createdAt,
    String? imagePath,
    List<CourseSubCollection> subCollections = const [],
    List<CourseContent> rootContents = const [],
    String courseMetadataJson = '{}',
  }) {
    return CourseModel(
      courseId: const Uuid().v4(),
      courseTitle: courseTitle,
      description: description,
      createdAt: createdAt ?? DateTime.now(),
      imagePath: imagePath,
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
    String? imagePath,
    List<CourseSubCollection>? subCollections,
    List<CourseContent>? rootContents,
    String? courseMetadataJson,
  }) {
    return CourseModel(
      courseId: courseId ?? this.courseId,
      courseTitle: courseTitle ?? this.courseTitle,
      createdAt: createdAt ?? this.createdAt,
      description: description ?? this.description,
      imagePath: imagePath ?? this.imagePath,
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
      'courseTitle': courseTitle,
      'description': description,
      'imagePath': imagePath,
      'subCollections': subCollections,
      'rootContents': rootContents,
      'courseMetadataJson': courseMetadataJson,
    };
  }

  factory CourseModel.fromMap(Map<String, dynamic> map) {
    return CourseModel(
      courseId: map['courseId'],
      courseTitle: map['courseTitle'],
      createdAt: map['createdAt']  == null ? DateTime.now() : DateTime.tryParse(map['createdAt'] as String) ?? DateTime.now(),
      description: map['description'],
      imagePath: map['imagePath'],
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
          description == other.description &&
          imagePath == other.imagePath &&
          const DeepCollectionEquality().equals(subCollections, other.subCollections) &&
          const DeepCollectionEquality().equals(rootContents, other.rootContents) &&
          courseMetadataJson == other.courseMetadataJson;

  @override
  int get hashCode => Object.hash(
    id,
    courseId,
    createdAt,
    courseTitle,
    description,
    imagePath,
    const DeepCollectionEquality().hash(subCollections),
    const DeepCollectionEquality().hash(rootContents),
    courseMetadataJson,
  );
}
