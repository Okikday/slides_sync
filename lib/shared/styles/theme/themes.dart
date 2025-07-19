import 'dart:developer';

import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:slides_sync/shared/styles/theme/app_theme_model.dart';
import 'package:slides_sync/shared/styles/theme/built_in_themes.dart';

class AppThemeDataProvider extends Notifier<ThemeData> {
  @override
  ThemeData build() {
    return resolveThemeData(defaultAppThemeModels[0]);
  }

  void update([ThemeData? newThemeData]) {
    log("Updating ThemeData");
    if (newThemeData == null) return;
    if (newThemeData == state) return;
    state = newThemeData;
  }
}


ThemeData resolveThemeData(AppThemeModel theme) {
  return ThemeData(
    brightness: theme.brightness,
    primaryColor: theme.primaryColor,
    scaffoldBackgroundColor: theme.backgroundColor,
    canvasColor: theme.cardColor,
    colorScheme: ColorScheme(
      brightness: theme.brightness,
      primary: theme.primaryColor,
      onPrimary: theme.textPrimaryColor,
      secondary: theme.accentColor.withValues(alpha: 0.1),
      onSecondary: theme.accentColor,
      error: Colors.red.withValues(alpha: 0.2),
      onError: Colors.red,
      surface: theme.backgroundColor,
      onSurface: theme.onBackgroundColor,
      tertiary: theme.textPrimaryColor,
      onTertiary: theme.textSecondaryColor,
    ),
    splashColor: theme.accentColor.withAlpha(10),
    appBarTheme: AppBarTheme(
      backgroundColor: theme.backgroundColor,
      elevation: 0,
      iconTheme: IconThemeData(color: theme.textSecondaryColor),
    ),
    floatingActionButtonTheme: FloatingActionButtonThemeData(backgroundColor: theme.primaryColor),
    iconTheme: IconThemeData(color: theme.textPrimaryColor),
    cardColor: theme.cardColor,
    fontFamily: "Nunito",
  );
}
