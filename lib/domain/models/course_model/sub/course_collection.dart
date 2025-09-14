// ignore_for_file: public_member_api_docs, sort_constructors_first
import 'dart:convert';
import 'dart:io';

import 'package:isar/isar.dart';
import 'package:uuid/uuid.dart';

import 'course_content.dart';

part 'course_collection.g.dart';

@collection
class CourseCollection {
  Id id = Isar.autoIncrement;

  @Index()
  late String collectionId;
  
  late String parentId;
  late String collectionTitle;

  late String description;
  DateTime? createdAt;
  late String imageLocationJson;
  late String collectionMetadataJson;

  final IsarLinks<CourseContent> contents = IsarLinks<CourseContent>();

  CourseCollection();

  factory CourseCollection.create({
    required String parentId,
    required String collectionTitle,
    String description = '',
    DateTime? createdAt,
    String imageLocationJson = '{}',
    String collectionMetadataJson = '{}',
  }) {
    final collection =
        CourseCollection()
          ..collectionId = const Uuid().v4()
          ..parentId = parentId
          ..collectionTitle = collectionTitle
          ..description = description
          ..createdAt = createdAt ?? DateTime.now()
          ..imageLocationJson = imageLocationJson
          ..collectionMetadataJson = collectionMetadataJson;
    return collection;
  }



  Map<String, dynamic> toMap() {
    return {
      'id': id,
      'collectionId': collectionId,
      'parentId': parentId,
      'collectionTitle': collectionTitle,
      'description': description,
      'createdAt': createdAt?.toIso8601String(),
      'imageLocationJson': imageLocationJson,
      'collectionMetadataJson': collectionMetadataJson,
      // courseContents is IsarLinks, not serialized here
    };
  }

  factory CourseCollection.fromMap(Map<String, dynamic> map) {
    final collection = CourseCollection();
    collection.id = map['id'] ?? Isar.autoIncrement;
    collection.collectionId = map['collectionId'] ?? '';
    collection.parentId = map['parentId'] ?? '';
    collection.collectionTitle = map['collectionTitle'] ?? '';
    collection.description = map['description'] ?? '';
    collection.createdAt = map['createdAt'] != null ? DateTime.tryParse(map['createdAt']) : null;
    collection.imageLocationJson = map['imageLocationJson'] ?? '{}';
    collection.collectionMetadataJson = map['collectionMetadataJson'] ?? '{}';
    
    return collection;
  }

  String toJson() => jsonEncode(toMap());

  factory CourseCollection.fromJson(String source) => CourseCollection.fromMap(jsonDecode(source));

  @override
  bool operator ==(covariant CourseCollection other) {
    if (identical(this, other)) return true;

    return other.id == id &&
        other.collectionId == collectionId &&
        other.parentId == parentId &&
        other.collectionTitle == collectionTitle &&
        other.description == description &&
        other.createdAt == createdAt &&
        other.imageLocationJson == imageLocationJson &&
        other.collectionMetadataJson == collectionMetadataJson;
  }

  @override
  int get hashCode {
    return id.hashCode ^
        collectionId.hashCode ^
        parentId.hashCode ^
        collectionTitle.hashCode ^
        description.hashCode ^
        createdAt.hashCode ^
        imageLocationJson.hashCode ^
        collectionMetadataJson.hashCode;
  }

  @override
  String toString() {
    return 'CourseCollection(id: $id, collectionId: $collectionId, parentId: $parentId, collectionTitle: $collectionTitle, description: $description, createdAt: $createdAt, imageLocationJson: $imageLocationJson, collectionMetadataJson: $collectionMetadataJson)';
  }
}

extension CourseCollectionExtension on CourseCollection {
  String get relativePath => "$parentId${Platform.pathSeparator}$collectionId";
  String get absolutePath => "courses${Platform.pathSeparator}$relativePath";
  String get courseId => parentId;

  CourseCollection copyWith({
    String? collectionId,
    String? parentId,
    String? collectionTitle,
    String? description,
    DateTime? createdAt,
    String? imageLocationJson,
    String? collectionMetadataJson,
  }) {
    return CourseCollection()
      ..collectionId = collectionId ?? this.collectionId
      ..parentId = parentId ?? this.parentId
      ..collectionTitle = collectionTitle ?? this.collectionTitle
      ..description = description ?? this.description
      ..createdAt = createdAt ?? this.createdAt
      ..imageLocationJson = imageLocationJson ?? this.imageLocationJson
      ..collectionMetadataJson = collectionMetadataJson ?? this.collectionMetadataJson;
  }
}
