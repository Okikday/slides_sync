import 'dart:convert';
import 'dart:io';
import 'package:collection/collection.dart';
import 'package:isar/isar.dart';
import 'package:slides_sync/core/models/file_details.dart';
import 'package:uuid/uuid.dart';

import 'course_content.dart';

part 'course_sub_collection.g.dart';

@embedded
class CourseSubCollection {
  final String collectionId;
  final String parentId;
  final String collectionTitle;
  final List<CourseContent> courseContents;
  final String description;
  final DateTime? createdAt;
  final String imageLocationJson;
  final String collectionMetadataJson;

  CourseSubCollection({
    this.collectionId = '',
    this.parentId = '',
    this.collectionTitle = '',
    this.courseContents = const <CourseContent>[],
    this.description = "",
    this.createdAt,
    this.imageLocationJson = '{}',
    this.collectionMetadataJson = '{}',
  });

  // FileDetails get getFileDetails => FileDetails.fromJson(fileDetails);

  factory CourseSubCollection.create({
    required String collectionTitle,
    required String parentId,
    String description = '',
    List<CourseContent>? courseContents,
    DateTime? createdAt,
    FileDetails? imageLocation,
    String? collectionMetadataJson,
  }) {
    return CourseSubCollection(
      collectionId: const Uuid().v4(),
      parentId: parentId,
      collectionTitle: collectionTitle,

      createdAt: createdAt ?? DateTime.now(),
      courseContents: courseContents ?? const <CourseContent>[],
      description: description,
      imageLocationJson: imageLocation?.toJson() ?? '{}',
      collectionMetadataJson: collectionMetadataJson ?? '{}',
    );
  }

  CourseSubCollection copyWith({
    String? collectionId,
    String? parentId,
    String? collectionTitle,
    List<CourseContent>? courseContents,
    String? description,
    DateTime? createdAt,
    FileDetails? imageLocation,
    String? collectionMetadataJson,
  }) {
    return CourseSubCollection(
      collectionId: collectionId ?? this.collectionId,
      parentId: parentId ?? this.parentId,
      collectionTitle: collectionTitle ?? this.collectionTitle,
      courseContents: courseContents ?? this.courseContents,
      description: description ?? this.description,
      createdAt: createdAt ?? this.createdAt,
      imageLocationJson: imageLocation?.toJson() ?? imageLocationJson,
      collectionMetadataJson: collectionMetadataJson ?? this.collectionMetadataJson,
    );
  }

  Map<String, dynamic> toMap() {
    return {
      'collectionId': collectionId,
      'parentId': parentId,
      'collectionTitle': collectionTitle,
      'courseContents': courseContents.map((e) => e.toJson()).toList(),
      'description': description,
      'createdAt': createdAt?.toIso8601String(),
      'imageLocationJson': imageLocationJson,
      'collectionMetadataJson': collectionMetadataJson,
    };
  }

  factory CourseSubCollection.fromMap(Map<String, dynamic> map) {
    return CourseSubCollection(
      collectionId: map['collectionId'] as String,
      parentId: map['parentId'] as String,
      collectionTitle: map['collectionTitle'] as String,
      courseContents: List<CourseContent>.from((map['courseContents'] as List<String>).map((e) => CourseContent.fromJson(e)).toList()),
      createdAt: map['createdAt'] == null ? DateTime.now() : DateTime.tryParse(map['createdAt'] as String) ?? DateTime.now(),
      description: map['description'] as String? ?? '',
      imageLocationJson: map['imageLocationJson'] as String? ?? '{}',
    );
  }

  String toJson() => jsonEncode(toMap());

  factory CourseSubCollection.fromJson(String source) => CourseSubCollection.fromMap(jsonDecode(source) as Map<String, dynamic>);

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is CourseSubCollection &&
          runtimeType == other.runtimeType &&
          collectionId == other.collectionId &&
          parentId == other.parentId &&
          collectionTitle == other.collectionTitle &&
          const ListEquality().equals(courseContents, other.courseContents) &&
          createdAt == other.createdAt &&
          description == other.description &&
          imageLocationJson == other.imageLocationJson;

  @override
  int get hashCode => Object.hash(
    collectionId,
    parentId,
    collectionTitle,
    const ListEquality().hash(courseContents),
    createdAt,
    description,
    imageLocationJson,
  );
}

extension CourseSubCollectionExtension on CourseSubCollection {
  String get relativePath => "$parentId${Platform.pathSeparator}$collectionId";
  String get absolutePath => "courses${Platform.pathSeparator}$relativePath";
  String get courseId => parentId.substring(0, parentId.indexOf(Platform.pathSeparator).clamp(0, parentId.length));
}
