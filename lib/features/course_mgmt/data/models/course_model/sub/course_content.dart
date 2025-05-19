import 'dart:convert';

import 'package:isar/isar.dart';
import 'package:uuid/uuid.dart';

import 'course_content_type.dart';

part 'course_content.g.dart';

@embedded
class CourseContent {
  final String id;
  final String title;

  /// appended with type before path/link e.g. "file:anonymous.jpg" or "link:https://image.jpg"
  final String path;
  final DateTime? createdAt;
  final String description;

  /// appended with type before path/link e.g. "file:anonymous.jpg" or "link:https://image.jpg"
  final String? imagePath;
  @enumerated
  final CourseContentType courseContentType;
  //udilv
  final String metadataJson;

  CourseContent({
    this.id = '',
    this.title = '',
    this.createdAt,
    this.path = '',
    this.description = '',
    this.imagePath,
    this.courseContentType = CourseContentType.unknown,
    this.metadataJson = '{}',
  });


  factory CourseContent.create({
    required String title,
    required String path,
    required CourseContentType courseContentType,
    String description = "",
    String? imagePath,
    String? metadataJson,
  }) {

    return CourseContent(
      id: const Uuid().v4(), // generate a unique id
      title: title,
      createdAt: DateTime.now(),
      path: path,
      description: description,
      imagePath: imagePath,
      courseContentType: courseContentType,
      metadataJson: metadataJson ?? '{}',
    );
  }

  CourseContent copyWith({
    String? id,
    String? title,
    DateTime? createdAt,
    String? path,
    String? description,
    String? imagePath,
    CourseContentType? courseContentType,
    String? metadataJson,
  }) {
    return CourseContent(
      id: id ?? this.id,
      title: title ?? this.title,
      createdAt: createdAt ?? this.createdAt,
      path: path ?? this.path,
      description: description ?? this.description,
      imagePath: imagePath ?? this.imagePath,
      courseContentType: courseContentType ?? this.courseContentType,
      metadataJson: metadataJson ?? this.metadataJson,
    );
  }

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is CourseContent &&
          runtimeType == other.runtimeType &&
          id == other.id &&
          title == other.title &&
          createdAt == other.createdAt &&
          path == other.path &&
          description == other.description &&
          imagePath == other.imagePath &&
          courseContentType == other.courseContentType &&
          metadataJson == other.metadataJson;

  @override
  int get hashCode =>
      id.hashCode ^
      title.hashCode ^
      createdAt.hashCode ^
      path.hashCode ^
      description.hashCode ^
      imagePath.hashCode ^
      courseContentType.hashCode ^
      metadataJson.hashCode;

  Map<String, dynamic> toMap() {
    return {
      'id': id,
      'title': title,
      'createdAt': createdAt?.toIso8601String(),
      'path': path,
      'description': description,
      'imagePath': imagePath,
      'courseContentType': courseContentType.index,
      'metadataJson': metadataJson,
    };
  }

  factory CourseContent.fromMap(Map<String, dynamic> map) {
    return CourseContent(
      id: map['id'] as String,
      title: map['title'] as String,
      createdAt: map['createdAt']  == null ? DateTime.now() : DateTime.tryParse(map['createdAt'] as String) ?? DateTime.now(),
      path: map['path'] as String,
      description: map['description'] as String,
      imagePath: map['imagePath'] as String?,
      courseContentType: CourseContentType.values[map['courseContentType'] as int],
      metadataJson: map['metadataJson'] as String,
    );
  }

  factory CourseContent.fromJson(String json) => CourseContent.fromMap(jsonDecode(json) as Map<String, dynamic>);
  String toJson() => jsonEncode(toMap());
}
