import 'package:flutter/material.dart';

class UiStyles {
  static BoxDecoration getBlueThemedBoxDecoration(bool isDarkMode) {
    return BoxDecoration(
      color: Colors.lightBlueAccent.withAlpha(25),
      borderRadius: BorderRadius.circular(12),
      border: Border.all(width: 2, color: Colors.lightBlueAccent.withAlpha(25)),
      boxShadow:
          isDarkMode
              ? [
                BoxShadow(
                  color: Colors.black.withAlpha(50),
                  blurRadius: 8,
                  offset: Offset(0, 0),
                  blurStyle: BlurStyle.inner,
                  spreadRadius: 2,
                ),
              ]
              : [
                BoxShadow(
                  color: Colors.lightBlueAccent.withAlpha(25),
                  blurRadius: 8,
                  offset: Offset(0, 0),
                  blurStyle: BlurStyle.inner,
                  spreadRadius: 2,
                ),
              ],
    );
  }
}
