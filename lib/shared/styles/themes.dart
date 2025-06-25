import 'dart:developer';

import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:slides_sync/shared/styles/colors.dart';

class AppThemeDataProvider extends Notifier<ThemeData> with WidgetsBindingObserver {
  @override
  ThemeData build() {
    WidgetsBinding.instance.addObserver(this);
    final bool isDarkMode = WidgetsBinding.instance.platformDispatcher.platformBrightness == Brightness.dark;
    return isDarkMode ? AppThemes.darkTheme : AppThemes.lightTheme;
  }

  @override
  void didChangePlatformBrightness() {
    update();
    super.didChangePlatformBrightness();
  }

  void update([ThemeData? newThemeData]) {
    final bool isDarkMode = WidgetsBinding.instance.platformDispatcher.platformBrightness == Brightness.dark;
    log("Updating ThemeData");
    if (newThemeData == null) {
      state = isDarkMode ? AppThemes.darkTheme : AppThemes.lightTheme;
      return;
    }
    if (newThemeData == state) return;
    state = newThemeData;
  }
}

class AppThemes {
  static final ThemeData lightTheme = ThemeData(
    brightness: Brightness.light,
    primaryColor: AppColors.primary,
    scaffoldBackgroundColor: AppColors.background,
    fontFamily: "Nunito",
    splashColor: Colors.lightBlueAccent.withAlpha(10),
    appBarTheme: const AppBarTheme(
      backgroundColor: AppColors.background,
      elevation: 0,
      iconTheme: IconThemeData(color: AppColors.lightGray),
    ),
    floatingActionButtonTheme: const FloatingActionButtonThemeData(backgroundColor: AppColors.primary),
    iconTheme: IconThemeData(color: Colors.white),
    cardColor: AppColors.secondary
  );

  static final ThemeData darkTheme = ThemeData(
    brightness: Brightness.dark,
    primaryColor: AppColors.primaryDark,
    scaffoldBackgroundColor: AppColors.darkBackground,
    fontFamily: "Nunito",
    splashColor: Colors.lightBlueAccent.withAlpha(10),
    appBarTheme: const AppBarTheme(
      backgroundColor: AppColors.darkBackground,
      elevation: 0,
      iconTheme: IconThemeData(color: AppColors.lightGray),
    ),
    floatingActionButtonTheme: const FloatingActionButtonThemeData(backgroundColor: AppColors.primaryDark),
    iconTheme: IconThemeData(color: Colors.white),
    cardColor: AppColors.secondaryDark,
  );
}
