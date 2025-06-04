import 'dart:convert';
import 'package:collection/collection.dart';
import 'package:isar/isar.dart';
import 'package:slides_sync/core/models/file_location.dart';
import 'package:uuid/uuid.dart';

import 'course_content.dart';

part 'course_sub_collection.g.dart';
@embedded
class CourseSubCollection {
  final String collectionId;
  final String collectionTitle;
  final List<CourseContent> courseContents;
  final String description;
  final String imageLocationJson;
  final String collectionMetadataJson;


  CourseSubCollection({
    this.collectionId = '',
    this.collectionTitle = '',
    this.courseContents = const <CourseContent>[],
    this.description = "",
    this.imageLocationJson = '{}',
    this.collectionMetadataJson = '{}',
  });

  // FileLocation get getFileLocation => FileLocation.fromJson(fileLocation);

  factory CourseSubCollection.create({
    required String collectionTitle,
    String description = '',
    List<CourseContent>? courseContents,
    FileLocation? imageLocation,
    String? collectionMetadataJson,
  }) {
    return CourseSubCollection(
      collectionId: const Uuid().v4(),
      collectionTitle: collectionTitle,
      courseContents: courseContents ?? const <CourseContent>[],
      description: description,
      imageLocationJson: imageLocation?.toJson() ?? '{}',
      collectionMetadataJson: collectionMetadataJson ?? '{}',
    );
  }

  CourseSubCollection copyWith({
    String? collectionId,
    String? collectionTitle,
    List<CourseContent>? courseContents,
    String? description,
    FileLocation? imageLocation,
    String? collectionMetadataJson,
  }) {
    return CourseSubCollection(
      collectionId: collectionId ?? this.collectionId,
      collectionTitle: collectionTitle ?? this.collectionTitle,
      courseContents: courseContents ?? this.courseContents,
      description: description ?? this.description,
      imageLocationJson: imageLocation?.toJson() ?? imageLocationJson,
      collectionMetadataJson: collectionMetadataJson ?? this.collectionMetadataJson,
    );
  }

  Map<String, dynamic> toMap() {
    return {
      'collectionId': collectionId,
      'collectionTitle': collectionTitle,
      'courseContents': courseContents.map((e) => e.toJson()).toList(),
      'description': description,
      'imageLocationJson': imageLocationJson,
      'collectionMetadataJson': collectionMetadataJson,
    };
  }

  factory CourseSubCollection.fromMap(Map<String, dynamic> map) {
    return CourseSubCollection(
      collectionId: map['collectionId'] as String,
      collectionTitle: map['collectionTitle'] as String,
      courseContents: List<CourseContent>.from((map['courseContents'] as List<String>).map((e) => CourseContent.fromJson(e)).toList()),
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
          collectionTitle == other.collectionTitle &&
          const ListEquality().equals(courseContents, other.courseContents) &&
          description == other.description &&
          imageLocationJson == other.imageLocationJson;

  @override
  int get hashCode => Object.hash(collectionId, collectionTitle, const ListEquality().hash(courseContents), description, imageLocationJson);
}
