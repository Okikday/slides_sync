import 'dart:developer';

import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:slides_sync/shared/styles/theme/app_theme_model.dart';
import 'package:slides_sync/shared/styles/theme/built_in_themes.dart';

class AppThemeProvider extends Notifier<AppThemeModel> {
  @override
  AppThemeModel build() {
    return AppThemeModel.of(defaultUnifiedThemeModels[0], Brightness.light);
  }

  void update(Brightness brightness, [UnifiedThemeModel? theme]) {
    log("Updating ThemeData");
    if (theme == null) return;
    final AppThemeModel newTheme = AppThemeModel.of(theme, brightness);
    if (state == newTheme) return;
    state = newTheme;
  }
}

ThemeData resolveThemeData(AppThemeModel theme) {
  TextTheme? googleTextTheme;
  if (theme.fontFamily?.isNotEmpty == true) {
    try {
      googleTextTheme = GoogleFonts.getTextTheme(theme.fontFamily!);
    } catch (e) {
      log('resolveThemeData: Unable to load Google Font "${theme.fontFamily}": $e');
    }
  }

  final baseScheme = ColorScheme.fromSeed(seedColor: theme.primary, brightness: theme.brightness);

  final cs = baseScheme.copyWith(
    // Core colors
    primary: theme.primary,
    onPrimary: theme.onPrimary,
    secondary: theme.secondary,
    onSecondary: theme.onSecondary,

    // Background and surface colors using new properties
    surface: theme.surface,
    onSurface: theme.onSurface,
    // background: theme.background,
    // onBackground: theme.onBackground,

    // Use alt backgrounds for additional surface variants
    tertiary: theme.altBackgroundPrimary,
    onTertiary: theme.onSurface,
    tertiaryContainer: theme.altBackgroundSecondary,
    onTertiaryContainer: theme.onSurface,

    // Supporting text colors
    onSurfaceVariant: theme.supportingText,
  );

  final defaultTextTheme =
      (theme.brightness == Brightness.light) ? ThemeData.light().textTheme : ThemeData.dark().textTheme;
  final effectiveTextTheme = (googleTextTheme ?? defaultTextTheme).apply(
    bodyColor: cs.onSurface,
    displayColor: cs.onSurface,
  );

  return ThemeData(
    useMaterial3: true,
    colorScheme: cs,
    brightness: theme.brightness,

    // Use background for scaffold, surface for cards
    scaffoldBackgroundColor: theme.background,
    canvasColor: theme.surface,
    cardColor: theme.surface,

    textTheme: effectiveTextTheme,
    primaryTextTheme: effectiveTextTheme,

    iconTheme: IconThemeData(color: cs.onSurface),
    primaryIconTheme: IconThemeData(color: cs.onPrimary),

    appBarTheme: AppBarTheme(
      backgroundColor: theme.surface,
      foregroundColor: cs.onSurface,
      elevation: 0,
      centerTitle: true,
      iconTheme: IconThemeData(color: cs.onSurface),
      titleTextStyle: effectiveTextTheme.titleLarge?.copyWith(color: cs.onSurface),
      toolbarTextStyle: effectiveTextTheme.bodyMedium?.copyWith(color: cs.onSurface),
      surfaceTintColor: Colors.transparent,
    ),

    elevatedButtonTheme: ElevatedButtonThemeData(
      style: ElevatedButton.styleFrom(
        backgroundColor: cs.primary,
        foregroundColor: cs.onPrimary,
        textStyle: effectiveTextTheme.labelLarge,
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
        elevation: 2,
      ),
    ),

    filledButtonTheme: FilledButtonThemeData(
      style: FilledButton.styleFrom(
        backgroundColor: cs.primary,
        foregroundColor: cs.onPrimary,
        textStyle: effectiveTextTheme.labelLarge,
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
      ),
    ),

    textButtonTheme: TextButtonThemeData(
      style: TextButton.styleFrom(foregroundColor: cs.primary, textStyle: effectiveTextTheme.labelLarge),
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
      fillColor: theme.altBackgroundPrimary,
      contentPadding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
      border: OutlineInputBorder(borderRadius: BorderRadius.circular(12), borderSide: BorderSide.none),
      enabledBorder: OutlineInputBorder(
        borderRadius: BorderRadius.circular(12),
        borderSide: BorderSide(color: cs.outline.withValues(alpha: 0.12)),
      ),
      focusedBorder: OutlineInputBorder(
        borderRadius: BorderRadius.circular(12),
        borderSide: BorderSide(color: cs.primary, width: 2),
      ),
      hintStyle: effectiveTextTheme.bodySmall?.copyWith(color: theme.supportingText),
      labelStyle: effectiveTextTheme.bodyMedium?.copyWith(color: theme.supportingText),
    ),

    cardTheme: CardThemeData(
      color: theme.surface,
      surfaceTintColor: Colors.transparent,
      elevation: 1,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
      margin: const EdgeInsets.all(8),
    ),

    listTileTheme: ListTileThemeData(
      tileColor: theme.surface,
      selectedTileColor: theme.altBackgroundPrimary,
      iconColor: cs.onSurface,
      textColor: cs.onSurface,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(8)),
    ),

    navigationBarTheme: NavigationBarThemeData(
      backgroundColor: theme.surface,
      surfaceTintColor: Colors.transparent,
      indicatorColor: theme.altBackgroundPrimary,
      labelTextStyle: WidgetStateProperty.resolveWith((states) {
        if (states.contains(WidgetState.selected)) {
          return effectiveTextTheme.labelSmall?.copyWith(color: cs.primary);
        }
        return effectiveTextTheme.labelSmall?.copyWith(color: theme.supportingText);
      }),
      iconTheme: WidgetStateProperty.resolveWith((states) {
        if (states.contains(WidgetState.selected)) {
          return IconThemeData(color: cs.primary);
        }
        return IconThemeData(color: theme.supportingText);
      }),
    ),

    bottomNavigationBarTheme: BottomNavigationBarThemeData(
      backgroundColor: theme.surface,
      selectedItemColor: cs.primary,
      unselectedItemColor: theme.supportingText,
      showUnselectedLabels: true,
      elevation: 8,
      type: BottomNavigationBarType.fixed,
    ),

    drawerTheme: DrawerThemeData(
      backgroundColor: theme.surface,
      surfaceTintColor: Colors.transparent,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.only(topRight: Radius.circular(16), bottomRight: Radius.circular(16)),
      ),
    ),

    bottomSheetTheme: BottomSheetThemeData(
      backgroundColor: theme.surface,
      surfaceTintColor: Colors.transparent,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.only(topLeft: Radius.circular(16), topRight: Radius.circular(16)),
      ),
    ),

    dialogTheme: DialogThemeData(
      backgroundColor: theme.surface,
      surfaceTintColor: Colors.transparent,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
      titleTextStyle: effectiveTextTheme.headlineSmall?.copyWith(color: cs.onSurface),
      contentTextStyle: effectiveTextTheme.bodyMedium?.copyWith(color: cs.onSurface),
    ),

    // Interaction colors
    splashColor: cs.primary.withValues(alpha: 0.08),
    highlightColor: cs.primary.withValues(alpha: 0.04),
    hoverColor: cs.primary.withValues(alpha: 0.02),
    focusColor: cs.primary.withValues(alpha: 0.12),

    // Dividers and borders
    dividerColor: cs.onSurface.withValues(alpha: 0.08),

    snackBarTheme: SnackBarThemeData(
      backgroundColor: theme.altBackgroundPrimary,
      contentTextStyle: effectiveTextTheme.bodyMedium?.copyWith(color: cs.onSurface),
      actionTextColor: cs.primary,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(8)),
    ),

    tooltipTheme: TooltipThemeData(
      decoration: BoxDecoration(color: cs.onSurface.withValues(alpha: 0.92), borderRadius: BorderRadius.circular(8)),
      textStyle: effectiveTextTheme.bodySmall?.copyWith(color: cs.surface),
    ),

    // Material 3 specific
    applyElevationOverlayColor: theme.brightness == Brightness.dark,
    visualDensity: VisualDensity.adaptivePlatformDensity,
  );
}
