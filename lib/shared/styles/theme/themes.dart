import 'dart:developer';

import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:slides_sync/shared/styles/theme/app_theme_model.dart';
import 'package:slides_sync/shared/styles/theme/built_in_themes.dart';



class AppThemeProvider extends Notifier<AppThemeModel> {
  @override
  AppThemeModel build() {
    return defaultAppThemeModels[0];
  }

  void update([AppThemeModel? theme]) {
    log("Updating ThemeData");
    if (theme == null) return;
    if (theme == state) return;
    state = theme;
  }
}


ThemeData resolveThemeData(AppThemeModel theme) {
  // Try Google Fonts theme
  TextTheme? googleTextTheme;
  if (theme.fontFamily?.isNotEmpty == true) {
    try {
      googleTextTheme = GoogleFonts.getTextTheme(theme.fontFamily!);
    } catch (e) {
      log('resolveThemeData: Unable to load Google Font "${theme.fontFamily}": $e');
    }
  }

  // Build ColorScheme from seed, override with explicit fields
  final baseScheme = ColorScheme.fromSeed(
    seedColor: theme.primaryColor,
    brightness: theme.brightness,
  );

  final cs = baseScheme.copyWith(
    primary: theme.primaryColor,
    onPrimary: theme.onPrimaryText,
    secondary: theme.secondaryColor,
    onSecondary: theme.onSecondaryText,

    surface: theme.background,
    onSurface: theme.bgText, // <-- text on background

    // Tertiary: supporting colors
    tertiary: theme.altBackgroundPrimary,
    onTertiary: theme.bgSupportText,

    // Surface containers / emphasis colors
    onSurfaceVariant: theme.bgSupportText,

    // Error, outline, scrim keep defaults unless needed
  );

  // Choose text theme
  final defaultTextTheme =
      (theme.brightness == Brightness.light)
          ? ThemeData.light().textTheme
          : ThemeData.dark().textTheme;
  final effectiveTextTheme =
      (googleTextTheme ?? defaultTextTheme).apply(
        bodyColor: cs.onSurface,
        displayColor: cs.onSurface,
      );

  return ThemeData(
    useMaterial3: true,
    colorScheme: cs,
    brightness: theme.brightness,

    scaffoldBackgroundColor: theme.background,
    canvasColor: theme.stepUpBackground,
    cardColor: theme.stepUpBackground,

    textTheme: effectiveTextTheme,
    primaryTextTheme: effectiveTextTheme,

    iconTheme: IconThemeData(color: cs.onSurface),
    primaryIconTheme: IconThemeData(color: cs.onPrimary),

    appBarTheme: AppBarTheme(
      backgroundColor: theme.stepUpBackground,
      foregroundColor: cs.onSurface,
      elevation: 0,
      centerTitle: true,
      iconTheme: IconThemeData(color: cs.onSurface),
      titleTextStyle: effectiveTextTheme.titleLarge?.copyWith(
        color: cs.onSurface,
      ),
      toolbarTextStyle: effectiveTextTheme.bodyMedium?.copyWith(
        color: cs.onSurface,
      ),
    ),

    elevatedButtonTheme: ElevatedButtonThemeData(
      style: ElevatedButton.styleFrom(
        backgroundColor: cs.primary,
        foregroundColor: cs.onPrimary,
        textStyle: effectiveTextTheme.labelLarge,
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
      ),
    ),
    textButtonTheme: TextButtonThemeData(
      style: TextButton.styleFrom(
        foregroundColor: cs.primary,
        textStyle: effectiveTextTheme.labelLarge,
      ),
    ),
    outlinedButtonTheme: OutlinedButtonThemeData(
      style: OutlinedButton.styleFrom(
        foregroundColor: cs.primary,
        side: BorderSide(color: cs.primary.withValues(alpha: 0.12)),
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
      ),
    ),

    floatingActionButtonTheme: FloatingActionButtonThemeData(
      backgroundColor: cs.primary,
      foregroundColor: cs.onPrimary,
    ),

    inputDecorationTheme: InputDecorationTheme(
      filled: true,
      fillColor: theme.stepUpBackground,
      contentPadding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
      border: OutlineInputBorder(
        borderRadius: BorderRadius.circular(12),
        borderSide: BorderSide.none,
      ),
      hintStyle: effectiveTextTheme.bodySmall?.copyWith(
        color: cs.onSurface.withValues(alpha: 0.6),
      ),
    ),

    cardTheme: CardThemeData(
      color: theme.stepUpBackground,
      elevation: 0,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
      margin: const EdgeInsets.all(8),
    ),

    bottomNavigationBarTheme: BottomNavigationBarThemeData(
      backgroundColor: theme.stepUpBackground,
      selectedItemColor: cs.primary,
      unselectedItemColor: cs.onSurface.withValues(alpha: 0.6),
      showUnselectedLabels: true,
      elevation: 8,
    ),

    splashColor: cs.primary.withValues(alpha: 0.08),
    highlightColor: cs.primary.withValues(alpha: 0.04),
    hoverColor: cs.primary.withValues(alpha: 0.02),

    dividerColor: cs.onSurface.withValues(alpha: 0.08),
    snackBarTheme: SnackBarThemeData(
      backgroundColor: cs.surface,
      contentTextStyle: effectiveTextTheme.bodyMedium?.copyWith(
        color: cs.onSurface,
      ),
    ),
    tooltipTheme: TooltipThemeData(
      decoration: BoxDecoration(
        color: cs.onSurface.withValues(alpha: 0.92),
        borderRadius: BorderRadius.circular(8),
      ),
      textStyle: effectiveTextTheme.bodySmall?.copyWith(color: cs.surface),
    ),

    applyElevationOverlayColor: theme.brightness == Brightness.dark,
  );
}
