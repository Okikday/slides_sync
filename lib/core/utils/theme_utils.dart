import 'package:flutter/widgets.dart';

class ThemeUtils {
  /// Converts a [Color] to a hexadecimal string, e.g. Color(0xFF123456) -> "#FF123456".
  static String colorToHex(Color color) {
    return '#${color.toARGB32().toRadixString(16).padLeft(8, '0').toUpperCase()}';
  }

  /// Converts a hexadecimal string to [Color], supports formats "#RRGGBB" and "#AARRGGBB".
  static Color hexToColor(String hex) {
    final buffer = StringBuffer();
    if (hex.startsWith('#')) hex = hex.substring(1);
    if (hex.length == 6) buffer.write('FF'); // default alpha
    buffer.write(hex);
    return Color(int.parse(buffer.toString(), radix: 16));
  }
}

extension ThemeUtilsExtension1 on Color {
  String get toHexColor => ThemeUtils.colorToHex(this);
}

extension ThemeUtilsExtension2 on String {
  Color get toColor => ThemeUtils.hexToColor(this);
}
