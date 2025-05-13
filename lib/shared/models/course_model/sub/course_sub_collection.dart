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