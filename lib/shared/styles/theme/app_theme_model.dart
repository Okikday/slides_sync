// ignore_for_file: public_member_api_docs, sort_constructors_first
import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:slides_sync/core/utils/theme_utils.dart';

class AppThemeModel {
  final String title;
  final Color primaryColor;
  final Color accentColor;
  final Color textPrimaryColor;
  final Color textSecondaryColor;
  final Color backgroundColor;
  final Color onBackgroundColor;
  final Color cardColor;
  final String? fontFamily;
  final Brightness brightness;

  const AppThemeModel({
    required this.title,
    required this.primaryColor,
    required this.accentColor,
    required this.textPrimaryColor,
    required this.textSecondaryColor,
    required this.backgroundColor,
    required this.onBackgroundColor,
    required this.cardColor,
    required this.fontFamily,
    required this.brightness,
  });

  AppThemeModel copyWith({
    String? title,
    Color? primaryColor,
    Color? accentColor,
    Color? textPrimaryColor,
    Color? textSecondaryColor,
    Color? backgroundColor,
    Color? onBackgroundColor,
    Color? cardColor,
    String? fontFamily,
    Brightness? brightness,
  }) {
    return AppThemeModel(
      title: title ?? this.title,
      primaryColor: primaryColor ?? this.primaryColor,
      accentColor: accentColor ?? this.accentColor,
      textPrimaryColor: textPrimaryColor ?? this.textPrimaryColor,
      textSecondaryColor: textSecondaryColor ?? this.textSecondaryColor,
      backgroundColor: backgroundColor ?? this.backgroundColor,
      onBackgroundColor: onBackgroundColor ?? this.onBackgroundColor,
      cardColor: cardColor ?? this.cardColor,
      fontFamily: fontFamily ?? this.fontFamily,
      brightness: brightness ?? this.brightness,
    );
  }

  Map<String, dynamic> toMap() {
    return <String, dynamic>{
      'title': title,
      'primaryColor': ThemeUtils.colorToHex(primaryColor),
      'accentColor': ThemeUtils.colorToHex(accentColor),
      'textPrimaryColor': ThemeUtils.colorToHex(textPrimaryColor),
      'textSecondaryColor': ThemeUtils.colorToHex(textSecondaryColor),
      'backgroundColor': ThemeUtils.colorToHex(backgroundColor),
      'onBackgroundColor': ThemeUtils.colorToHex(onBackgroundColor),
      'cardColor': ThemeUtils.colorToHex(cardColor),
      'fontFamily': fontFamily,
      'brightness': brightness.name,
    };
  }

  factory AppThemeModel.fromMap(Map<String, dynamic> map) {
    return AppThemeModel(
      title: map['title'] as String? ?? '',
      primaryColor: ThemeUtils.hexToColor(map['primaryColor']),
      accentColor: ThemeUtils.hexToColor(map['accentColor']),
      textPrimaryColor: ThemeUtils.hexToColor(map['textPrimaryColor']),
      textSecondaryColor: ThemeUtils.hexToColor(map['textSecondaryColor']),
      backgroundColor: ThemeUtils.hexToColor(map['backgroundColor']),
      onBackgroundColor: ThemeUtils.hexToColor(map['onBackgroundColor']),
      cardColor: ThemeUtils.hexToColor(map['cardColor']),
      fontFamily: map['fontFamily'] != null ? map['fontFamily'] as String : null,
      brightness: Brightness.values.byName(map['brightness'] as String? ?? "dark"),
    );
  }

  String toJson() => json.encode(toMap());

  factory AppThemeModel.fromJson(String source) => AppThemeModel.fromMap(json.decode(source) as Map<String, dynamic>);

  @override
  bool operator ==(covariant AppThemeModel other) {
    if (identical(this, other)) return true;

    return other.title == title &&
        other.primaryColor == primaryColor &&
        other.accentColor == accentColor &&
        other.textPrimaryColor == textPrimaryColor &&
        other.textSecondaryColor == textSecondaryColor &&
        other.backgroundColor == backgroundColor &&
        other.onBackgroundColor == onBackgroundColor &&
        other.cardColor == cardColor &&
        other.fontFamily == fontFamily &&
        other.brightness == brightness;
  }

  @override
  int get hashCode {
    return title.hashCode ^
        primaryColor.hashCode ^
        accentColor.hashCode ^
        textPrimaryColor.hashCode ^
        textSecondaryColor.hashCode ^
        backgroundColor.hashCode ^
        onBackgroundColor.hashCode ^
        cardColor.hashCode ^
        fontFamily.hashCode ^
        brightness.hashCode;
  }
}
