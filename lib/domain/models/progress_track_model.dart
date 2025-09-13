// ignore_for_file: public_member_api_docs, sort_constructors_first
import 'dart:convert';

import 'package:isar/isar.dart';

part 'progress_track_model.g.dart';

@collection
class ProgressTrackModel {
  Id id = Isar.autoIncrement;

  @Index()
  late String contentId;

  String? title;
  String? description;

  @Index()
  late String contentHash;
  double? progress;
  int count = 0;
  String? additionalDetail;

  DateTime? firstRead;
  DateTime? lastRead;

  String metadataJson = '{}';

  ProgressTrackModel();

  factory ProgressTrackModel.create({
    required String contentId,
    String? title,
    String? description,
    required String contentHash,
    double? progress,
    int? count,
    String? additionalDetail,
    String? metadataJson,
    DateTime? firstRead,
    DateTime? lastRead,
  }) {
    return ProgressTrackModel()
      ..contentId = contentId
      ..title = title
      ..description = description
      ..contentHash = contentHash
      ..progress = progress
      ..count = count ?? 0
      ..additionalDetail = additionalDetail
      ..firstRead = firstRead ?? DateTime.now()
      ..lastRead = lastRead ?? DateTime.now()
      ..metadataJson = metadataJson ?? '{}';
  }

  ProgressTrackModel copyWith({
    Id? id,
    String? contentId,
    String? title,
    String? description,
    String? contentHash,
    double? progress,
    int? count,
    String? additionalDetail,
    DateTime? firstRead,
    DateTime? lastRead,
  }) {
    return ProgressTrackModel()
      ..id = id ?? this.id
      ..contentId = contentId ?? this.contentId
      ..title = title ?? this.title
      ..description = description ?? this.description
      ..contentHash = contentHash ?? this.contentHash
      ..progress = progress ?? this.progress
      ..count = count ?? this.count
      ..additionalDetail = additionalDetail ?? this.additionalDetail
      ..firstRead = firstRead ?? this.firstRead
      ..lastRead = lastRead ?? this.lastRead;
  }

  Map<String, dynamic> toMap() {
    return <String, dynamic>{
      'id': id,
      'contentId': contentId,
      'title': title,
      'description': description,
      'contentHash': contentHash,
      'progress': progress,
      'count': count,
      'additionalDetail': additionalDetail,
      'firstRead': firstRead?.toIso8601String(),
      'lastRead': lastRead?.toIso8601String(),
    };
  }

  factory ProgressTrackModel.fromMap(Map<String, dynamic> map) {
    return ProgressTrackModel()
      ..id = map['id'] as int
      ..contentId = map['contentId'] as String
      ..title = map['title'] as String?
      ..description = map['description'] as String?
      ..contentHash = map['contentHash'] as String? ?? ''
      ..progress = map['progress'] as double? ?? 0.0
      ..count = map['count'] as int? ?? 0
      ..additionalDetail = map['additionalDetail'] as String? ?? ''
      ..firstRead = DateTime.tryParse(map['firstRead'] as String? ?? '') ?? DateTime.now()
      ..lastRead = DateTime.tryParse(map['lastRead'] as String? ?? '') ?? DateTime.now();
  }

  String toJson() => json.encode(toMap());

  factory ProgressTrackModel.fromJson(String source) =>
      ProgressTrackModel.fromMap(json.decode(source) as Map<String, dynamic>);

  @override
  String toString() {
    return 'ProgressTrackModel(id: $id, contentId: $contentId, title: $title, description: $description, contentHash: $contentHash, progress: $progress, count: $count, additionalDetail: $additionalDetail, firstRead: $firstRead, lastRead: $lastRead)';
  }

  @override
  bool operator ==(covariant ProgressTrackModel other) {
    if (identical(this, other)) return true;

    return other.id == id &&
        other.contentId == contentId &&
        other.title == title &&
        other.description == description &&
        other.contentHash == contentHash &&
        other.progress == progress &&
        other.count == count &&
        other.additionalDetail == additionalDetail &&
        other.firstRead == firstRead &&
        other.lastRead == lastRead;
  }

  @override
  int get hashCode {
    return id.hashCode ^
        contentId.hashCode ^
        title.hashCode ^
        description.hashCode ^
        contentHash.hashCode ^
        progress.hashCode ^
        count.hashCode ^
        additionalDetail.hashCode ^
        firstRead.hashCode ^
        lastRead.hashCode;
  }
}
