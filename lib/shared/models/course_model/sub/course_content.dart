import 'course_content_type.dart';

class CourseContent{
  final String id;
  final String title;

  /// appended with type before path/link e.g. "file:anonymous.jpg" or "link:https://image.jpg"
  final String path;
  final String description;

  /// appended with type before path/link e.g. "file:anonymous.jpg" or "link:https://image.jpg"
  final String imagePath;
  final CourseContentType courseContentType;
  final Map<String, dynamic>? metadata;

  CourseContent({required this.id, required this.title, required this.path, this.description = "", required this.imagePath, required this.courseContentType, this.metadata});

  CourseContent copyWith({
    String? id,
    String? title,
    String? path,
    String? description,
    String? imagePath,
    CourseContentType? courseContentType,
    Map<String, dynamic>? metadata,
  }) {
    return CourseContent(
      id: id ?? this.id,
      title: title ?? this.title,
      path: path ?? this.path,
      description: description ?? this.description,
      imagePath: imagePath ?? this.imagePath,
      courseContentType: courseContentType ?? this.courseContentType,
      metadata: metadata ?? this.metadata,
    );
  }

}