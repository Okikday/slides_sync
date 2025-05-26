import 'package:another_flushbar/flushbar.dart';
import 'package:custom_widgets_toolkit/custom_widgets_toolkit.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:slides_sync/shared/styles/app_ui_context.dart';
import 'package:slides_sync/shared/styles/colors.dart';
import 'package:slides_sync/shared/styles/external/ui_styles.dart';

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

  static Future<dynamic> showFlushBar(BuildContext context, {required String msg, Duration duration = const Duration(milliseconds: 1500)}) async {
    await Flushbar(
      message: msg,
      messageColor: context.isDarkMode ? Colors.white : Colors.black,
      duration: duration,
      dismissDirection: FlushbarDismissDirection.VERTICAL,
      backgroundColor:
          (context.isDarkMode ? SlidesRepoColors.deepBlue.withValues(alpha: 0.8) : SlidesRepoColors.lightGray.withValues(alpha: 0.8)),
      borderRadius: BorderRadius.circular(ConstantSizing.borderRadiusCircle),
      borderColor: Colors.grey.withValues(alpha: 0.2),
      boxShadows: UiStyles.getBlueThemedBoxDecoration(context.isDarkMode).boxShadow,
      margin: EdgeInsets.only(left: 24, right: 24, bottom: kBottomNavigationBarHeight + 12),
      barBlur: 4.0,
    ).show(context);
  }

  ///
}
