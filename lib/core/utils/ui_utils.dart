import 'package:another_flushbar/flushbar.dart';
import 'package:custom_widgets_toolkit/custom_widgets_toolkit.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:slides_sync/shared/helpers/extension_helper.dart';
import 'package:slides_sync/shared/styles/colors.dart';
import 'package:slides_sync/shared/styles/external/ui_styles.dart';

enum FlushbarVibe { none, error, success, warning }

class UiUtils {
  /// For getting repititive SystemOverlayStyle
  static SystemUiOverlayStyle getSystemUiOverlayStyle(Color scaffoldBackgroundColor, bool isDarkMode) {
    return SystemUiOverlayStyle(
      systemNavigationBarColor: scaffoldBackgroundColor,
      statusBarColor: scaffoldBackgroundColor,
      statusBarIconBrightness: isDarkMode ? Brightness.light : Brightness.dark,
      systemNavigationBarIconBrightness: isDarkMode ? Brightness.light : Brightness.dark,
    );
  }

  static Future<dynamic> showFlushBar(
    BuildContext context, {
    required String msg,
    Color? messageColor,
    Color? backgroundColor,
    Duration duration = const Duration(milliseconds: 1500),
    FlushbarPosition flushbarPosition = FlushbarPosition.BOTTOM,
    FlushbarVibe vibe = FlushbarVibe.none,
    EdgeInsets? margin,
    double barBlur = 4.0,
  }) async {
    final List<Color> colors = _resolveFlushbarVibe(context, vibe);

    await Flushbar(
      message: msg,
      messageColor: messageColor ?? colors[0],
      duration: duration,
      dismissDirection: FlushbarDismissDirection.VERTICAL,
      flushbarPosition: flushbarPosition,
      backgroundColor: backgroundColor ?? colors[1],
      borderRadius: BorderRadius.circular(ConstantSizing.borderRadiusCircle),
      borderColor: Colors.grey.withValues(alpha: 0.2),
      boxShadows: UiStyles.getBlueThemedBoxDecoration(context.isDarkMode).boxShadow,
      margin:
          margin ??
          (flushbarPosition == FlushbarPosition.BOTTOM
              ? EdgeInsets.only(left: 24, right: 24, bottom: context.bottomPadding + 12)
              : EdgeInsets.only(left: 24, right: 24, top: context.topPadding + 8.0)),
      barBlur: barBlur,
    ).show(context);
  }

  ///
}

/// returns a list of Colors starting with the messageColor, backgroundColor
List<Color> _resolveFlushbarVibe(BuildContext context, FlushbarVibe vibe) {
  const errorColor = Color(0xfff30d0d);
  const successColor = Color(0xff00ff00);
  const warningColor = Color(0xFFF46B22);
  final normalColor = context.isDarkMode ? Colors.white : Colors.black;
  final normalBgColor =
      (context.isDarkMode ? SlidesRepoColors.deepBlue.withValues(alpha: 0.8) : SlidesRepoColors.lightGray.withValues(alpha: 0.8));

  switch (vibe) {
    case FlushbarVibe.none:
      return [normalColor, normalBgColor];
    case FlushbarVibe.error:
      return [errorColor, errorColor.withValues(alpha: 0.1)];
    case FlushbarVibe.success:
      return [successColor, successColor.withValues(alpha: 0.15)];
    case FlushbarVibe.warning:
      return [warningColor, warningColor.withValues(alpha: 0.15)];
  }
}
