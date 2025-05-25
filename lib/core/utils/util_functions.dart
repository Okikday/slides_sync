import 'package:flutter/rendering.dart';

class UtilFunctions {
  static Size getTextSize(String text, TextStyle style, {int? maxLines, double maxWidth = double.infinity}) => (TextPainter(
    text: TextSpan(text: text, style: style),
    textDirection: TextDirection.ltr,
    maxLines: maxLines
  )..layout(maxWidth: maxWidth)).size;
}