import 'package:flutter/material.dart';
import 'package:slides_sync/shared/styles/colors.dart';



class Themes {
  static final ThemeData lightTheme = ThemeData(
    brightness: Brightness.light,
    primaryColor: SlidesRepoColors.primary,
    scaffoldBackgroundColor: SlidesRepoColors.background,
    fontFamily: "Nunito",
    splashColor: Colors.lightBlueAccent.withAlpha(10),
    appBarTheme: const AppBarTheme(
      backgroundColor: SlidesRepoColors.background,
      foregroundColor: SlidesRepoColors.textPrimary,
      elevation: 0,
    ),
    floatingActionButtonTheme: const FloatingActionButtonThemeData(backgroundColor: SlidesRepoColors.primary),
  );

  static final ThemeData darkTheme = ThemeData(
    brightness: Brightness.dark,
    primaryColor: SlidesRepoColors.primaryDark,
    scaffoldBackgroundColor: SlidesRepoColors.darkBackground,
    fontFamily: "Nunito",
    splashColor: Colors.lightBlueAccent.withAlpha(10),
    appBarTheme: const AppBarTheme(
      backgroundColor: SlidesRepoColors.darkBackground,
      foregroundColor: SlidesRepoColors.darkTextPrimary,
      elevation: 0,
    ),
    floatingActionButtonTheme: const FloatingActionButtonThemeData(backgroundColor: SlidesRepoColors.primaryDark),
  );
}
