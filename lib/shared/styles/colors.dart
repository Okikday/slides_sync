import 'package:flutter/material.dart';
import 'package:slides_sync/shared/helpers/extension_helper.dart';

class AppColors {
  /// AppColors
  static Color primary(BuildContext context) => context.theme.colorScheme.primary;
  static Color onPrimary(BuildContext context) => context.theme.colorScheme.onPrimary;
  static Color primaryText(BuildContext context) => context.theme.colorScheme.tertiary;
  static Color secondaryText(BuildContext context) => context.theme.colorScheme.onTertiary;
  static Color cardColor(BuildContext context) => bgBlendColor(context);
  static Color backgroundColor(BuildContext context) => context.theme.scaffoldBackgroundColor;

  static Color bgBlendColor(BuildContext context, [double? value, double? darkValue]) {
    final bgColor = context.theme.scaffoldBackgroundColor;
    final isDarkMode = context.isDarkMode;
    return HSLColor.fromColor(bgColor).withLightness(isDarkMode ? (darkValue ?? 0.1) : (value ?? 0.9)).toColor();
  }

  static Color lightenColor(Color color, double value) => HSLColor.fromColor(color).withLightness(value).toColor();
}
