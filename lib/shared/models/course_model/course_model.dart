import 'package:collection/collection.dart';

export 'sub/course_content_type.dart' show CourseContentType;

class CourseModel{
  final String courseId;
  final String courseTitle;
  final String? courseCode;
  final String description;
  /// appended with type before path/link e.g. "file:anonymous.jpg" or "link:https://image.jpg"
  final String? imagePath;
  final List<String>? collectionIds;
  final List<String>? rootContentIds;
  final Map<String, dynamic>? courseMetadata;
  CourseModel({required this.courseId, required this.courseTitle, this.courseCode, this.description = "", this.imagePath, this.rootContentIds, this.collectionIds, this.courseMetadata});

  CourseModel copyWith({
    String? courseId,
    String? courseTitle,
    String? courseCode,
    String? description,
    String? imagePath,
    List<String>? collectionIds,
    List<String>? rootContentIds,
    Map<String, dynamic>? courseMetadata,
  }) {
    return CourseModel(
      courseId: courseId ?? this.courseId,
      courseTitle: courseTitle ?? this.courseTitle,
      courseCode: courseCode ?? this.courseCode,
      description: description ?? this.description,
      imagePath: imagePath ?? this.imagePath,
      collectionIds: collectionIds ?? this.collectionIds,
      rootContentIds: rootContentIds ?? this.rootContentIds,
      courseMetadata: courseMetadata ?? this.courseMetadata,
    );
  }

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
          other is CourseModel && runtimeType == other.runtimeType && courseId == other.courseId && courseTitle == other.courseTitle &&
              courseCode == other.courseCode && description == other.description && imagePath == other.imagePath &&
              const ListEquality().equals(collectionIds, other.collectionIds) && const ListEquality().equals(rootContentIds, other.rootContentIds) &&
              const DeepCollectionEquality().equals(courseMetadata, other.courseMetadata);

  @override
  int get hashCode =>
      Object.hash(
          courseId,
          courseTitle,
          courseCode,
          description,
          imagePath,
          const ListEquality().hash(collectionIds),
          const ListEquality().hash(rootContentIds),
          const DeepCollectionEquality().hash(courseMetadata));


}





