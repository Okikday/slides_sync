import 'package:flutter/material.dart';
import 'package:slides_sync/shared/helpers/extension_helper.dart';

class AppColors {
  static Color bgBlendColor(BuildContext context, [double? value, double? darkValue]) {
    final bgColor = context.theme.scaffoldBackgroundColor;
    final isDarkMode = context.isDarkMode;
    return HSLColor.fromColor(bgColor).withLightness(isDarkMode ? (darkValue ?? 0.1) : (value ?? 0.9)).toColor();
  }

  static Color lightenColor(Color color, double value) => HSLColor.fromColor(color).withLightness(value).toColor();
}
