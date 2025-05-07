class CourseModel{
  final String courseId;
  final String courseTitle;
  final String? courseCode;
  final String description;
  /// appended with type before path/link e.g. "file:anonymous.jpg" or "link:https://image.jpg"
  final String? imagePath;
  final List<String>? collectionIds;
  final Map<String, dynamic>? courseMetadata;
  CourseModel({required this.courseId, required this.courseTitle, this.courseCode, this.description = "", this.imagePath, this.collectionIds, this.courseMetadata});

  CourseModel copyWith({
    String? courseId,
    String? courseTitle,
    String? courseCode,
    String? description,
    String? imagePath,
    List<String>? collectionIds,
    Map<String, dynamic>? courseMetadata,
  }) {
    return CourseModel(
      courseId: courseId ?? this.courseId,
      courseTitle: courseTitle ?? this.courseTitle,
      courseCode: courseCode ?? this.courseCode,
      description: description ?? this.description,
      imagePath: imagePath ?? this.imagePath,
      collectionIds: collectionIds ?? this.collectionIds,
      courseMetadata: courseMetadata ?? this.courseMetadata,
    );
  }

}

class CourseSubCollection{
  final String collectionId;
  final String collectionTitle;
  final List<String>? innerCollectionIds;
  final List<String> courseContentIds;
  final String description;

  /// appended with type before path/link e.g. "file:anonymous.jpg" or "link:https://image.jpg"
  final String imagePath;
  final Map<String, dynamic>? subCollectionMetadata;

  CourseSubCollection({required this.collectionId, required this.collectionTitle, this.innerCollectionIds, required this.courseContentIds, this.description = "", required this.imagePath, this.subCollectionMetadata});

  CourseSubCollection copyWith({
    String? collectionId,
    String? collectionTitle,
    List<String>? innerCollectionIds,
    List<String>? courseContentIds,
    String? description,
    String? imagePath,
    Map<String, dynamic>? subCollectionMetadata,
  }) {
    return CourseSubCollection(
      collectionId: collectionId ?? this.collectionId,
      collectionTitle: collectionTitle ?? this.collectionTitle,
      innerCollectionIds: innerCollectionIds ?? this.innerCollectionIds,
      courseContentIds: courseContentIds ?? this.courseContentIds,
      description: description ?? this.description,
      imagePath: imagePath ?? this.imagePath,
      subCollectionMetadata: subCollectionMetadata ?? this.subCollectionMetadata,
    );
  }

}

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

enum CourseContentType{
  unknown,
  docFile,
  link,
  image,
  video
}