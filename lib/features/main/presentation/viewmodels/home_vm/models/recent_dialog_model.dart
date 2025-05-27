import 'package:flutter/widgets.dart';

class RecentDialogModel {
  final Widget? imagePreview;
  final bool isStarred;
  final String title;
  final String description;
  final void Function()? onStar;
  final void Function()? onShare;
  final void Function()? onDelete;

  RecentDialogModel({
    this.imagePreview,
    required this.isStarred,
    required this.title,
    this.description = '',
    this.onShare,
    this.onDelete,
    this.onStar,
  });

  RecentDialogModel copyWith({
    Widget? imagePreview,
    bool? isStarred,
    String? title,
    String? description,
    void Function()? onShare,
    void Function()? onDelete,
  }) {
    return RecentDialogModel(
      imagePreview: imagePreview ?? this.imagePreview,
      isStarred: isStarred ?? this.isStarred,
      title: title ?? this.title,
      description: description ?? this.description,
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
      other.title == title &&
          other.description == description &&
      other.onShare == onShare &&
      other.onDelete == onDelete;
  }

  @override
  int get hashCode {
    return imagePreview.hashCode ^
      isStarred.hashCode ^
      title.hashCode ^
    description.hashCode ^
      onShare.hashCode ^
      onDelete.hashCode;
  }
}
