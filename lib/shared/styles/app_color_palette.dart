// ignore_for_file: public_member_api_docs, sort_constructors_first
import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import 'package:slides_sync/core/utils/theme_utils.dart';
import 'package:slides_sync/shared/helpers/extension_helper.dart';
import 'package:slides_sync/shared/styles/default_themes_def.dart';

class AppColorPaletteProvider extends Notifier<AppColorPalette> {
  @override
  AppColorPalette build() => defaultAppColorPalette;

  void update(AppColorPalette newPalette) {
    if (newPalette == state) return;
    state = newPalette;
  }
}

class ColorThemeRecord {
  final Color light;
  final Color dark;

  ColorThemeRecord({required this.light, required this.dark});
  factory ColorThemeRecord.fromMap(Map<String, dynamic> value) {
    return ColorThemeRecord(
      light: ThemeUtils.hexToColor(value['light'] as String? ?? "#FFFFFFFF"),
      dark: ThemeUtils.hexToColor(value['dark'] as String? ?? "#FF000000"),
    );
  }

  Map<String, dynamic> toMap() => {'light': ThemeUtils.colorToHex(light), 'dark': ThemeUtils.colorToHex(dark)};

  ColorThemeRecord copyWith({Color? light, Color? dark}) {
    return ColorThemeRecord(light: light ?? this.light, dark: dark ?? this.dark);
  }

  @override
  bool operator ==(covariant ColorThemeRecord other) {
    if (identical(this, other)) return true;

    return other.light == light && other.dark == dark;
  }

  @override
  int get hashCode => light.hashCode ^ dark.hashCode;
}

class AppColorPalette {
  /// Main theme color (Material primary)
  final ColorThemeRecord primary;

  final ColorThemeRecord secondary;

  /// Scaffold background
  final ColorThemeRecord scaffoldBackground;

  /// Card styling
  final ColorThemeRecord cardBackground;
  final ColorThemeRecord cardBorder;

  /// Dashboard/home page accent
  final ColorThemeRecord dashboardBackground;
  final ColorThemeRecord dashboardAccent;

  /// Dialog styling
  final ColorThemeRecord dialogBackground;
  // final ColorThemeRecord dialogTitle;
  // final ColorThemeRecord dialogContent;

  /// Icons
  final ColorThemeRecord iconPrimary;
  final ColorThemeRecord iconSecondary;

  /// Buttons
  final ColorThemeRecord buttonPrimary;
  final ColorThemeRecord buttonSecondary;

  /// AppBar
  final ColorThemeRecord appBarBackground;
  final ColorThemeRecord appBarAccent;

  /// Text
  final ColorThemeRecord textPrimary;
  final ColorThemeRecord textSecondary;

  /// Additional UI components (add as needed)
  // final Color appBarBackground;
  // final Color textFieldFill;
  // final Color tooltipBackground;

  const AppColorPalette({
    required this.primary,
    required this.secondary,
    required this.scaffoldBackground,
    required this.cardBackground,
    required this.cardBorder,
    required this.dashboardBackground,
    required this.dashboardAccent,
    required this.dialogBackground,
    required this.iconPrimary,
    required this.iconSecondary,
    required this.buttonPrimary,
    required this.buttonSecondary,
    required this.appBarBackground,
    required this.appBarAccent,
    required this.textPrimary,
    required this.textSecondary,
  });

  AppColorPalette copyWith({
    ColorThemeRecord? primary,
    ColorThemeRecord? secondary,
    ColorThemeRecord? scaffoldBackground,
    ColorThemeRecord? cardBackground,
    ColorThemeRecord? cardBorder,
    ColorThemeRecord? dashboardBackground,
    ColorThemeRecord? dashboardAccent,
    ColorThemeRecord? dialogBackground,
    ColorThemeRecord? iconPrimary,
    ColorThemeRecord? iconSecondary,
    ColorThemeRecord? buttonPrimary,
    ColorThemeRecord? buttonSecondary,
    ColorThemeRecord? appBarBackground,
    ColorThemeRecord? appBarAccent,
    ColorThemeRecord? textPrimary,
    ColorThemeRecord? textSecondary,
  }) {
    return AppColorPalette(
      primary: primary ?? this.primary,
      secondary: secondary ?? this.secondary,
      scaffoldBackground: scaffoldBackground ?? this.scaffoldBackground,
      cardBackground: cardBackground ?? this.cardBackground,
      cardBorder: cardBorder ?? this.cardBorder,
      dashboardBackground: dashboardBackground ?? this.dashboardBackground,
      dashboardAccent: dashboardAccent ?? this.dashboardAccent,
      dialogBackground: dialogBackground ?? this.dialogBackground,
      iconPrimary: iconPrimary ?? this.iconPrimary,
      iconSecondary: iconSecondary ?? this.iconSecondary,
      buttonPrimary: buttonPrimary ?? this.buttonPrimary,
      buttonSecondary: buttonSecondary ?? this.buttonSecondary,
      appBarBackground: appBarBackground ?? this.appBarBackground,
      appBarAccent: appBarAccent ?? this.appBarAccent,
      textPrimary: textPrimary ?? this.textPrimary,
      textSecondary: textSecondary ?? this.textSecondary,
    );
  }

  Map<String, dynamic> toMap() {
    return <String, dynamic>{
      'primary': primary.toMap(),
      'secondary': secondary.toMap(),
      'scaffoldBackground': scaffoldBackground.toMap(),
      'cardBackground': cardBackground.toMap(),
      'cardBorder': cardBorder.toMap(),
      'dashboardBackground': dashboardBackground.toMap(),
      'dashboardAccent': dashboardAccent.toMap(),
      'dialogBackground': dialogBackground.toMap(),
      'iconPrimary': iconPrimary.toMap(),
      'iconSecondary': iconSecondary.toMap(),
      'buttonPrimary': buttonPrimary.toMap(),
      'buttonSecondary': buttonSecondary.toMap(),
      'appBarBackground': appBarBackground.toMap(),
      'appBarAccent': appBarAccent.toMap(),
      'textPrimary': textPrimary.toMap(),
      'textSecondary': textSecondary.toMap(),
    };
  }

  factory AppColorPalette.fromMap(Map<String, dynamic> map) {
    return AppColorPalette(
      primary: ColorThemeRecord.fromMap(map['primary'] as Map<String, dynamic>),
      secondary: ColorThemeRecord.fromMap(map['secondary'] as Map<String, dynamic>),
      scaffoldBackground: ColorThemeRecord.fromMap(map['scaffoldBackground'] as Map<String, dynamic>),
      cardBackground: ColorThemeRecord.fromMap(map['cardBackground'] as Map<String, dynamic>),
      cardBorder: ColorThemeRecord.fromMap(map['cardBorder'] as Map<String, dynamic>),
      dashboardBackground: ColorThemeRecord.fromMap(map['dashboardBackground'] as Map<String, dynamic>),
      dashboardAccent: ColorThemeRecord.fromMap(map['dashboardAccent'] as Map<String, dynamic>),
      dialogBackground: ColorThemeRecord.fromMap(map['dialogBackground'] as Map<String, dynamic>),
      iconPrimary: ColorThemeRecord.fromMap(map['iconPrimary'] as Map<String, dynamic>),
      iconSecondary: ColorThemeRecord.fromMap(map['iconSecondary'] as Map<String, dynamic>),
      buttonPrimary: ColorThemeRecord.fromMap(map['buttonPrimary'] as Map<String, dynamic>),
      buttonSecondary: ColorThemeRecord.fromMap(map['buttonSecondary'] as Map<String, dynamic>),
      appBarBackground: ColorThemeRecord.fromMap(map['appBarBackground'] as Map<String, dynamic>),
      appBarAccent: ColorThemeRecord.fromMap(map['appBarAccent'] as Map<String, dynamic>),
      textPrimary: ColorThemeRecord.fromMap(map['textPrimary'] as Map<String, dynamic>),
      textSecondary: ColorThemeRecord.fromMap(map['textSecondary'] as Map<String, dynamic>),
    );
  }

  String toJson() => json.encode(toMap());

  factory AppColorPalette.fromJson(String source) => AppColorPalette.fromMap(json.decode(source) as Map<String, dynamic>);

  @override
  bool operator ==(covariant AppColorPalette other) {
    if (identical(this, other)) return true;

    return other.primary == primary &&
        other.secondary == secondary &&
        other.scaffoldBackground == scaffoldBackground &&
        other.cardBackground == cardBackground &&
        other.cardBorder == cardBorder &&
        other.dashboardBackground == dashboardBackground &&
        other.dashboardAccent == dashboardAccent &&
        other.dialogBackground == dialogBackground &&
        other.iconPrimary == iconPrimary &&
        other.iconSecondary == iconSecondary &&
        other.buttonPrimary == buttonPrimary &&
        other.buttonSecondary == buttonSecondary &&
        other.appBarBackground == appBarBackground &&
        other.appBarAccent == appBarAccent &&
        other.textPrimary == textPrimary &&
        other.textSecondary == textSecondary;
  }

  @override
  int get hashCode {
    return primary.hashCode ^
        secondary.hashCode ^
        scaffoldBackground.hashCode ^
        cardBackground.hashCode ^
        cardBorder.hashCode ^
        dashboardBackground.hashCode ^
        dashboardAccent.hashCode ^
        dialogBackground.hashCode ^
        iconPrimary.hashCode ^
        iconSecondary.hashCode ^
        buttonPrimary.hashCode ^
        buttonSecondary.hashCode ^
        appBarBackground.hashCode ^
        appBarAccent.hashCode ^
        textPrimary.hashCode ^
        textSecondary.hashCode;
  }
}

extension ColorThemeRecordExtension on ColorThemeRecord {
  Color current(BuildContext context) => context.isDarkMode ? dark : light;
  Color currentColor(bool isDarkMode) => isDarkMode ? dark : light;
}
