import 'package:flutter/material.dart';
import 'package:slides_sync/shared/helpers/extension_helper.dart';
import 'package:slides_sync/shared/styles/colors.dart';

class UiStyles {
  static BoxDecoration getBlueThemedBoxDecoration(BuildContext context) {
    return BoxDecoration(
      color: context.theme.colorScheme.onSurface,
      borderRadius: BorderRadius.circular(12),
      border: Border.all(width: 2, color: context.theme.colorScheme.secondary),
      // boxShadow: [
      //   BoxShadow(
      //     color: isDarkMode ? Colors.black.withAlpha(50) : Colors.lightBlueAccent.withAlpha(25),
      //     blurRadius: 8,
      //     offset: Offset(0, 0),
      //     blurStyle: BlurStyle.inner,
      //     spreadRadius: 2,
      //   ),
      // ],
    );
  }
}
