enum ProgressLevel { neutral, warning, danger, success }

class RecentListTileModel {
  final String title;
  final String subtitle;
  final String extraContent;
  final double? progress;
  final ProgressLevel progressLevel;
  final bool isStarred;
  final void Function()? onTapTile;
  final void Function()? onLongTapTile;
  final void Function()? onTapPlay;

  RecentListTileModel({
    required this.title,
    required this.subtitle,
    this.extraContent = "",
    this.progress,
    required this.progressLevel,
    required this.isStarred,
    this.onTapTile,
    this.onLongTapTile,
    this.onTapPlay,
  });

  RecentListTileModel copyWith({
    String? title,
    String? subtitle,
    String? extraContent,
    double? progress,
    ProgressLevel? progressLevel,
    bool? isStarred,
    void Function()? onTapTile,
    void Function()? onLongTapTile,
    void Function()? onTapPlay,
  }) {
    return RecentListTileModel(
      title: title ?? this.title,
      subtitle: subtitle ?? this.subtitle,
      extraContent: extraContent ?? this.extraContent,
      progress: progress ?? this.progress,
      progressLevel: progressLevel ?? this.progressLevel,
      isStarred: isStarred ?? this.isStarred,
      onTapTile: onTapTile ?? this.onTapTile,
      onLongTapTile: onLongTapTile ?? this.onLongTapTile,
      onTapPlay: onTapPlay ?? this.onTapPlay,
    );
  }

  @override
  bool operator ==(covariant RecentListTileModel other) {
    if (identical(this, other)) return true;
  
    return 
      other.title == title &&
      other.subtitle == subtitle &&
      other.extraContent == extraContent &&
      other.progress == progress &&
      other.progressLevel == progressLevel &&
      other.isStarred == isStarred &&
      other.onTapTile == onTapTile &&
      other.onLongTapTile == onLongTapTile &&
      other.onTapPlay == onTapPlay;
  }

  @override
  int get hashCode {
    return title.hashCode ^
      subtitle.hashCode ^
      extraContent.hashCode ^
      progress.hashCode ^
      progressLevel.hashCode ^
      isStarred.hashCode ^
      onTapTile.hashCode ^
      onLongTapTile.hashCode ^
      onTapPlay.hashCode;
  }
}