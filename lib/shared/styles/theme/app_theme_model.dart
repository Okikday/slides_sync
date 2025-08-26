// ignore_for_file: public_member_api_docs, sort_constructors_first
import 'dart:convert';

import 'package:flutter/material.dart';

import 'package:slides_sync/core/utils/theme_utils.dart';
import 'package:slides_sync/shared/styles/theme/themes.dart';

/// Minimal theme model containing only title, fontFamily, brightness
/// and the color properties from your palette.
class AppThemeModel {
  final String title;
  final String? fontFamily;
  final Brightness brightness;

  // Palette colors
  final Color primaryColor;
  final Color secondaryColor;

  final Color background;
  final Color stepUpBackground;

  final Color bgText;
  final Color bgSupportText;

  final Color altBackgroundPrimary;
  final Color altBackgroundSecondary;

  final Color surfaceDark;
  final Color surfaceLight;

  final Color onPrimaryText;
  final Color onSecondaryText;

  final Color emphasisStrong;
  final Color emphasisSoft;

  final Color frostedPrimaryBase;
  final Color frostedSecondaryBase;

  const AppThemeModel({
    required this.title,
    this.fontFamily,
    required this.brightness,
    required this.primaryColor,
    required this.secondaryColor,
    required this.background,
    required this.stepUpBackground,
    required this.bgText,
    required this.bgSupportText,
    required this.altBackgroundPrimary,
    required this.altBackgroundSecondary,
    required this.surfaceDark,
    required this.surfaceLight,
    required this.onPrimaryText,
    required this.onSecondaryText,
    required this.emphasisStrong,
    required this.emphasisSoft,
    required this.frostedPrimaryBase,
    required this.frostedSecondaryBase,
  });

  Color get primaryText => bgText;
  Color get secondaryText => bgSupportText;


  AppThemeModel copyWith({
    String? title,
    String? fontFamily,
    Brightness? brightness,
    Color? primaryColor,
    Color? secondaryColor,
    Color? background,
    Color? stepUpBackground,
    Color? bgText,
    Color? bgSupportText,
    Color? altBackgroundPrimary,
    Color? altBackgroundSecondary,
    Color? surfaceDark,
    Color? surfaceLight,
    Color? onPrimaryText,
    Color? onSecondaryText,
    Color? emphasisStrong,
    Color? emphasisSoft,
    Color? frostedPrimaryBase,
    Color? frostedSecondaryBase,
  }) {
    return AppThemeModel(
      title: title ?? this.title,
      fontFamily: fontFamily ?? this.fontFamily,
      brightness: brightness ?? this.brightness,
      primaryColor: primaryColor ?? this.primaryColor,
      secondaryColor: secondaryColor ?? this.secondaryColor,
      background: background ?? this.background,
      stepUpBackground: stepUpBackground ?? this.stepUpBackground,
      bgText: bgText ?? this.bgText,
      bgSupportText: bgSupportText ?? this.bgSupportText,
      altBackgroundPrimary: altBackgroundPrimary ?? this.altBackgroundPrimary,
      altBackgroundSecondary:
          altBackgroundSecondary ?? this.altBackgroundSecondary,
      surfaceDark: surfaceDark ?? this.surfaceDark,
      surfaceLight: surfaceLight ?? this.surfaceLight,
      onPrimaryText: onPrimaryText ?? this.onPrimaryText,
      onSecondaryText: onSecondaryText ?? this.onSecondaryText,
      emphasisStrong: emphasisStrong ?? this.emphasisStrong,
      emphasisSoft: emphasisSoft ?? this.emphasisSoft,
      frostedPrimaryBase: frostedPrimaryBase ?? this.frostedPrimaryBase,
      frostedSecondaryBase: frostedSecondaryBase ?? this.frostedSecondaryBase,
    );
  }

  /// Minimal serialization: colors saved as integer values (Color.value).
  Map<String, dynamic> toMap() {
    return {
      'title': title,
      'fontFamily': fontFamily,
      'brightness': brightness.name,
      'primaryColor': primaryColor.toHexColor,
      'secondaryColor': secondaryColor.toHexColor,
      'background': background.toHexColor,
      'stepUpBackground': stepUpBackground.toHexColor,
      'bgText': bgText.toHexColor,
      'bgSupportText': bgSupportText.toHexColor,
      'altBackgroundPrimary': altBackgroundPrimary.toHexColor,
      'altBackgroundSecondary': altBackgroundSecondary.toHexColor,
      'surfaceDark': surfaceDark.toHexColor,
      'surfaceLight': surfaceLight.toHexColor,
      'onPrimaryText': onPrimaryText.toHexColor,
      'onSecondaryText': onSecondaryText.toHexColor,
      'emphasisStrong': emphasisStrong.toHexColor,
      'emphasisSoft': emphasisSoft.toHexColor,
      'frostedPrimaryBase': frostedPrimaryBase.toHexColor,
      'frostedSecondaryBase': frostedSecondaryBase.toHexColor,
    };
  }

  factory AppThemeModel.fromMap(Map<String, dynamic> m) {
    Color c(dynamic v) => (v.toString()).toColor;
    return AppThemeModel(
      title: m['title'] as String? ?? '',
      fontFamily: m['fontFamily'] as String?,
      brightness: Brightness.values.byName(
        m['brightness'] as String? ?? 'light',
      ),
      primaryColor: c(m['primaryColor']),
      secondaryColor: c(m['secondaryColor']),
      background: c(m['background']),
      stepUpBackground: c(m['stepUpBackground']),
      bgText: c(m['bgText']),
      bgSupportText: c(m['bgSupportText']),
      altBackgroundPrimary: c(m['altBackgroundPrimary']),
      altBackgroundSecondary: c(m['altBackgroundSecondary']),
      surfaceDark: c(m['surfaceDark']),
      surfaceLight: c(m['surfaceLight']),
      onPrimaryText: c(m['onPrimaryText']),
      onSecondaryText: c(m['onSecondaryText']),
      emphasisStrong: c(m['emphasisStrong']),
      emphasisSoft: c(m['emphasisSoft']),
      frostedPrimaryBase: c(m['frostedPrimaryBase']),
      frostedSecondaryBase: c(m['frostedSecondaryBase']),
    );
  }

  String toJson() => json.encode(toMap());

  factory AppThemeModel.fromJson(String source) =>
      AppThemeModel.fromMap(json.decode(source) as Map<String, dynamic>);

  @override
  String toString() {
    return 'AppThemeModel(title: $title, fontFamily: $fontFamily, brightness: $brightness, primaryColor: $primaryColor, secondaryColor: $secondaryColor, background: $background, stepUpBackground: $stepUpBackground, bgText: $bgText, bgSupportText: $bgSupportText, altBackgroundPrimary: $altBackgroundPrimary, altBackgroundSecondary: $altBackgroundSecondary, surfaceDark: $surfaceDark, surfaceLight: $surfaceLight, onPrimaryText: $onPrimaryText, onSecondaryText: $onSecondaryText, emphasisStrong: $emphasisStrong, emphasisSoft: $emphasisSoft, frostedPrimaryBase: $frostedPrimaryBase, frostedSecondaryBase: $frostedSecondaryBase)';
  }
}


extension AppThemeModelExtension on AppThemeModel {
  ThemeData get themeData => resolveThemeData(this);
}
