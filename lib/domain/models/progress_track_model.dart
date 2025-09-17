// ignore_for_file: public_member_api_docs, sort_constructors_first
import 'dart:convert';

import 'package:collection/collection.dart';
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
  int lastPosition = 0;
  String? additionalDetail;
  List<String> pages = <String>[];

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
    int? lastPosition,
    String? additionalDetail,
    List<String>? pages,
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
      ..lastPosition = lastPosition ?? 0
      ..additionalDetail = additionalDetail
      ..pages = pages ?? <String>[]
      ..firstRead = firstRead ?? DateTime.now()
      ..lastRead = lastRead ?? DateTime.now()
      ..metadataJson = metadataJson ?? '{}';
  }

  Map<String, dynamic> toMap() {
    return <String, dynamic>{
      'id': id,
      'contentId': contentId,
      'title': title,
      'description': description,
      'contentHash': contentHash,
      'progress': progress,
      'lastPosition': lastPosition,
      'additionalDetail': additionalDetail,
      'pages': pages,
      'firstRead': firstRead?.toIso8601String(),
      'lastRead': lastRead?.toIso8601String(),
      'metadataJson': metadataJson,
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
      ..lastPosition = map['lastPosition'] as int? ?? 0
      ..additionalDetail = map['additionalDetail'] as String? ?? ''
      ..pages = map['pages'] as List<String>? ?? <String>[]
      ..firstRead = DateTime.tryParse(map['firstRead'] as String? ?? '') ?? DateTime.now()
      ..lastRead = DateTime.tryParse(map['lastRead'] as String? ?? '') ?? DateTime.now()
      ..metadataJson = map['metadataJson'] ?? '{}';
  }

  String toJson() => json.encode(toMap());

  factory ProgressTrackModel.fromJson(String source) =>
      ProgressTrackModel.fromMap(json.decode(source) as Map<String, dynamic>);

  @override
  String toString() {
    return 'ProgressTrackModel(id: $id, contentId: $contentId, title: $title, description: $description, contentHash: $contentHash, progress: $progress, lastPosition: $lastPosition, additionalDetail: $additionalDetail, pages: $pages, firstRead: $firstRead, lastRead: $lastRead, metadataJson: $metadataJson)';
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
        other.lastPosition == lastPosition &&
        other.additionalDetail == additionalDetail &&
        const ListEquality().equals(other.pages, pages) &&
        other.firstRead == firstRead &&
        other.lastRead == lastRead &&
        other.metadataJson == metadataJson;
  }

  @override
  int get hashCode {
    return id.hashCode ^
        contentId.hashCode ^
        title.hashCode ^
        description.hashCode ^
        contentHash.hashCode ^
        progress.hashCode ^
        lastPosition.hashCode ^
        additionalDetail.hashCode ^
        pages.hashCode ^
        firstRead.hashCode ^
        lastRead.hashCode ^
        metadataJson.hashCode;
  }
}

extension ProgressTrackModelExtension on ProgressTrackModel {
  ProgressTrackModel copyWith({
    Id? id,
    String? contentId,
    String? title,
    String? description,
    String? contentHash,
    double? progress,
    int? lastPosition,
    String? additionalDetail,
    List<String>? pages,
    DateTime? firstRead,
    DateTime? lastRead,
    String? metadataJson,
  }) {
    return this
      ..contentId = contentId ?? this.contentId
      ..title = title ?? this.title
      ..description = description ?? this.description
      ..contentHash = contentHash ?? this.contentHash
      ..progress = progress ?? this.progress
      ..lastPosition = lastPosition ?? this.lastPosition
      ..additionalDetail = additionalDetail ?? this.additionalDetail
      ..pages = pages ?? this.pages
      ..firstRead = firstRead ?? this.firstRead
      ..lastRead = lastRead ?? this.lastRead
      ..metadataJson = metadataJson ?? this.metadataJson;
  }
}
