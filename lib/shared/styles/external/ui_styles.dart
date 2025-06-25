import 'package:flutter/material.dart';
import 'package:slides_sync/shared/styles/colors.dart';

class UiStyles {
  static BoxDecoration getBlueThemedBoxDecoration(bool isDarkMode) {
    return BoxDecoration(
      color: (isDarkMode ? AppColors.deepBlue : AppColors.lightGray),
      borderRadius: BorderRadius.circular(12),
      border: Border.all(width: 2, color: Colors.lightBlueAccent.withAlpha(15)),
      boxShadow: [
        BoxShadow(
          color: isDarkMode ? Colors.black.withAlpha(50) : Colors.lightBlueAccent.withAlpha(25),
          blurRadius: 8,
          offset: Offset(0, 0),
          blurStyle: BlurStyle.inner,
          spreadRadius: 2,
        ),
      ],
    );
  }
}
