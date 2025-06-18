import 'dart:convert';

import 'package:isar/isar.dart';
import 'package:slides_sync/core/models/file_location.dart';
import 'package:slides_sync/data/models/course_model/sub/course_content_type.dart';
import 'package:uuid/uuid.dart';

export 'course_content_type.dart';


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
  // final String fileLocation;
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
    // this.fileLocation = '{}',
    this.courseContentType = CourseContentType.unknown,
    this.metadataJson = '{}',
  });


  factory CourseContent.create({
    required String title,
    required FileLocation path,
    required CourseContentType courseContentType,
    String description = "",
    String? metadataJson,
  }) {

    return CourseContent(
      id: const Uuid().v4(), // generate a unique id
      title: title,
      createdAt: DateTime.now(),
      path: path.toJson(),
      description: description,
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
    // FileLocation? fileLocation,
    CourseContentType? courseContentType,
    String? metadataJson,
  }) {
    return CourseContent(
      id: id ?? this.id,
      title: title ?? this.title,
      createdAt: createdAt ?? this.createdAt,
      path: path ?? this.path,
      description: description ?? this.description,
      // fileLocation: fileLocation?.toJson() ?? this.fileLocation,
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
          // fileLocation == other.fileLocation &&
          courseContentType == other.courseContentType &&
          metadataJson == other.metadataJson;

  @override
  int get hashCode =>
      id.hashCode ^
      title.hashCode ^
      createdAt.hashCode ^
      path.hashCode ^
      description.hashCode ^
      // fileLocation.hashCode ^
      courseContentType.hashCode ^
      metadataJson.hashCode;

  Map<String, dynamic> toMap() {
    return {
      'id': id,
      'title': title,
      'createdAt': createdAt?.toIso8601String(),
      'path': path,
      'description': description,
      // 'fileLocation': fileLocation,
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
      // fileLocation: map['fileLocation'] as String? ?? '{}',
      courseContentType: CourseContentType.values[map['courseContentType'] as int],
      metadataJson: map['metadataJson'] as String,
    );
  }

  factory CourseContent.fromJson(String json) => CourseContent.fromMap(jsonDecode(json) as Map<String, dynamic>);
  String toJson() => jsonEncode(toMap());
}
