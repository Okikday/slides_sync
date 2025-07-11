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

// // Default Twilight Academia
// class AppThemes {
//   static final ThemeData lightTheme = ThemeData(
//     brightness: Brightness.light,
//     primaryColor: AppColors.primary,
//     scaffoldBackgroundColor: AppColors.background,
//     fontFamily: "Nunito",
//     splashColor: Colors.lightBlueAccent.withAlpha(10),
//     appBarTheme: const AppBarTheme(
//       backgroundColor: AppColors.background,
//       elevation: 0,
//       iconTheme: IconThemeData(color: AppColors.lightGray),
//     ),
//     floatingActionButtonTheme: const FloatingActionButtonThemeData(backgroundColor: AppColors.primary),
//     iconTheme: IconThemeData(color: Colors.white),
//     cardColor: AppColors.secondary,
//   );

//   static final ThemeData darkTheme = ThemeData(
//     brightness: Brightness.dark,
//     primaryColor: AppColors.primaryDark,

//     scaffoldBackgroundColor: AppColors.darkBackground,
//     fontFamily: "Nunito",
//     splashColor: Colors.lightBlueAccent.withAlpha(10),
//     appBarTheme: const AppBarTheme(
//       backgroundColor: AppColors.darkBackground,
//       elevation: 0,
//       iconTheme: IconThemeData(color: AppColors.lightGray),
//     ),
//     floatingActionButtonTheme: const FloatingActionButtonThemeData(backgroundColor: AppColors.primaryDark),
//     iconTheme: IconThemeData(color: Colors.white),
//     cardColor: AppColors.secondaryDark,
//   );
// }

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
      secondary: theme.secondaryColor.withValues(alpha: 0.1),
      onSecondary: theme.secondaryColor,
      error: Colors.red.withValues(alpha: 0.2),
      onError: Colors.red,
      outline: theme.accentColor,
      outlineVariant: theme.accentColor.withValues(alpha: 0.2),
      surface: theme.backgroundColor,
      onSurface: theme.onBackgroundColor,
      tertiary: theme.textPrimaryColor,
      onTertiary: theme.textSecondaryColor,
    ),
    splashColor: theme.secondaryColor.withAlpha(10),
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
