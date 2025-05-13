import 'package:flutter/foundation.dart';
import 'package:flutter/widgets.dart';

class RecentDialogModel {
  final Widget? imagePreview;
  final bool isStarred;
  final bool hasNote;
  final String title;
  final String fileType;
  final List<String> tags;
  final bool canShare;
  final bool canDelete;
  final void Function()? onLike;
  final void Function()? onNote;
  final void Function()? onShare;
  final void Function()? onDelete;

  RecentDialogModel({
    this.imagePreview,
    required this.isStarred,
    required this.hasNote,
    required this.title,
    required this.fileType,
    required this.tags,
    required this.canShare,
    required this.canDelete,
    this.onShare,
    this.onDelete,
    this.onLike,
    this.onNote,
  });

  RecentDialogModel copyWith({
    Widget? imagePreview,
    bool? isStarred,
    bool? hasNote,
    String? title,
    String? fileType,
    List<String>? tags,
    bool? canShare,
    bool? canDelete,
    void Function()? onLike,
    void Function()? onNote,
    void Function()? onShare,
    void Function()? onDelete,
  }) {
    return RecentDialogModel(
      imagePreview: imagePreview ?? this.imagePreview,
      isStarred: isStarred ?? this.isStarred,
      hasNote: hasNote ?? this.hasNote,
      title: title ?? this.title,
      fileType: fileType ?? this.fileType,
      tags: tags ?? List.from(this.tags),
      canShare: canShare ?? this.canShare,
      canDelete: canDelete ?? this.canDelete,
      onLike: onLike ?? this.onLike,
      onNote: onNote ?? this.onNote,
      onShare: onShare ?? this.onShare,
      onDelete: onDelete ?? this.onDelete,
    );
  }

  @override
  bool operator ==(covariant RecentDialogModel other) {
    if (identical(this, other)) return true;
  
    return 
      other.imagePreview == imagePreview &&
      other.isStarred == isStarred &&
      other.hasNote == hasNote &&
      other.title == title &&
      other.fileType == fileType &&
      listEquals(other.tags, tags) &&
      other.canShare == canShare &&
      other.canDelete == canDelete &&
      other.onLike == onLike &&
      other.onNote == onNote &&
      other.onShare == onShare &&
      other.onDelete == onDelete;
  }

  @override
  int get hashCode {
    return imagePreview.hashCode ^
      isStarred.hashCode ^
      hasNote.hashCode ^
      title.hashCode ^
      fileType.hashCode ^
      tags.hashCode ^
      canShare.hashCode ^
      canDelete.hashCode ^
      onLike.hashCode ^
      onNote.hashCode ^
      onShare.hashCode ^
      onDelete.hashCode;
  }
}
