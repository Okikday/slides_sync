import 'dart:convert';
import 'package:collection/collection.dart';
import 'package:isar/isar.dart';
import 'package:uuid/uuid.dart';

import 'course_content.dart';

part 'course_sub_collection.g.dart';
@embedded
class CourseSubCollection {
  final String collectionId;
  final String collectionTitle;
  final List<CourseContent> courseContents;
  final String description;
  final String? imagePath;
  final String collectionMetadataJson;


  CourseSubCollection({
    this.collectionId = '',
    this.collectionTitle = '',
    this.courseContents = const <CourseContent>[],
    this.description = "",
    this.imagePath,
    this.collectionMetadataJson = '{}',
  });

  factory CourseSubCollection.create({
    required String collectionTitle,
    String description = '',
    List<CourseContent>? courseContents,
    String? imagePath,
    String? collectionMetadataJson,
  }) {
    return CourseSubCollection(
      collectionId: const Uuid().v4(),
      collectionTitle: collectionTitle,
      courseContents: courseContents ?? const <CourseContent>[],
      description: description,
      imagePath: imagePath,
      collectionMetadataJson: collectionMetadataJson ?? '{}',
    );
  }

  CourseSubCollection copyWith({
    String? collectionId,
    String? collectionTitle,
    List<CourseContent>? courseContents,
    String? description,
    String? imagePath,
    String? collectionMetadataJson,
  }) {
    return CourseSubCollection(
      collectionId: collectionId ?? this.collectionId,
      collectionTitle: collectionTitle ?? this.collectionTitle,
      courseContents: courseContents ?? this.courseContents,
      description: description ?? this.description,
      imagePath: imagePath ?? this.imagePath,
      collectionMetadataJson: collectionMetadataJson ?? this.collectionMetadataJson,
    );
  }

  Map<String, dynamic> toMap() {
    return {
      'collectionId': collectionId,
      'collectionTitle': collectionTitle,
      'courseContents': courseContents.map((e) => e.toJson()).toList(),
      'description': description,
      'imagePath': imagePath,
      'collectionMetadataJson': collectionMetadataJson,
    };
  }

  factory CourseSubCollection.fromMap(Map<String, dynamic> map) {
    return CourseSubCollection(
      collectionId: map['collectionId'] as String,
      collectionTitle: map['collectionTitle'] as String,
      courseContents: List<CourseContent>.from((map['courseContents'] as List<String>).map((e) => CourseContent.fromJson(e)).toList()),
      description: map['description'] as String? ?? '',
      imagePath: map['imagePath'] as String,
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
          collectionTitle == other.collectionTitle &&
          const ListEquality().equals(courseContents, other.courseContents) &&
          description == other.description &&
          imagePath == other.imagePath;

  @override
  int get hashCode => Object.hash(collectionId, collectionTitle, const ListEquality().hash(courseContents), description, imagePath);
}
