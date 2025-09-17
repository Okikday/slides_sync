
import 'package:another_flushbar/flushbar.dart';
import 'package:custom_widgets_toolkit/custom_widgets_toolkit.dart'
    show TransitionType, CustomCurves, ConstantSizing, CustomText, CustomDialog;
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:iconsax_flutter/iconsax_flutter.dart';
import 'package:slides_sync/shared/helpers/extension_helper.dart';

enum FlushbarVibe { none, error, success, warning }

class UiUtils {
  /// For getting repititive SystemOverlayStyle
  static SystemUiOverlayStyle getSystemUiOverlayStyle(
    Color scaffoldBackgroundColor,
    bool isDarkMode, {
    Color? statusBarColor,
    Brightness? statusBarIconBrightness,
    Color? systemNavigatorBarColor,
    Brightness? systemNavigatorBarIconBrightness,
  }) {
    return SystemUiOverlayStyle(
      systemNavigationBarColor: systemNavigatorBarColor ?? scaffoldBackgroundColor,
      statusBarColor: statusBarColor ?? scaffoldBackgroundColor,
      statusBarIconBrightness: statusBarIconBrightness ?? (isDarkMode ? Brightness.light : Brightness.dark),
      systemNavigationBarIconBrightness: systemNavigatorBarIconBrightness ?? (isDarkMode ? Brightness.light : Brightness.dark),
    );
  }

  /// For showing Custom Loading Dialog in tuned format
  static void showLoadingDialog(
    BuildContext context, {
    String message = "Just a moment...",
    bool canPop = true,
    Color? backgroundColor,
    Color? barrierColor,
    Offset? blurSigma,
  }) async {
    final normalColor = context.theme.primaryColor;
    final bgColor = context.theme.scaffoldBackgroundColor;
    await CustomDialog.showLoadingDialog(
      context,
      canPop: canPop,
      msg: message,
      msgTextColor: normalColor,
      backgroundColor: backgroundColor ?? bgColor,
      barrierColor: barrierColor ?? Colors.black.withAlpha(140),
      transitionDuration: Durations.medium2,
      blurSigma: blurSigma,
    );
  }

  static void hideDialog(BuildContext context) => CustomDialog.hide(context);

  /// For showing CustomDialog in tuned format
  static void showCustomDialog(
    BuildContext context, {
    required Widget child,
    bool canPop = true,
    Duration transitionDuration = Durations.medium2,
    Duration reverseTransitionDuration = Durations.short2,
    TransitionType transitionType = TransitionType.cupertinoDialog,
    Curve? curve,
    Color? barrierColor,
    Offset? blurSigma,
  }) async {
    await CustomDialog.show(
      context,
      canPop: canPop,
      transitionDuration: transitionDuration,
      reverseTransitionDuration: reverseTransitionDuration,
      transitionType: transitionType,
      curve: curve ?? CustomCurves.defaultIosSpring,
      barrierColor: barrierColor ?? Colors.black.withAlpha(140),
      blurSigma: blurSigma,
      child: child,
    );
  }

  /// For showing flushbar in tuned format
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
      icon: Icon(_resolveIconData(vibe), color: colors[0]),
      messageColor: messageColor ?? colors[0],
      duration: duration,
      dismissDirection: FlushbarDismissDirection.VERTICAL,
      flushbarPosition: flushbarPosition,
      backgroundColor: backgroundColor ?? colors[1],
      borderRadius: BorderRadius.circular(ConstantSizing.borderRadiusCircle),
      borderColor: colors[0].withValues(alpha: 0.2),
      padding: EdgeInsets.symmetric(horizontal: 16, vertical: 12),
      margin:
          margin ??
          (flushbarPosition == FlushbarPosition.TOP
              ? EdgeInsets.only(left: 24, right: 24, bottom: context.bottomPadding + 12)
              : EdgeInsets.only(left: 24, right: 24, top: context.topPadding + 8.0)),
      barBlur: barBlur,
    ).show(context);
  }

  ///
}

IconData _resolveIconData(FlushbarVibe vibe) {
  switch (vibe) {
    case FlushbarVibe.none:
      return Iconsax.info_circle;
    case FlushbarVibe.success:
      return Iconsax.tick_circle;
    case FlushbarVibe.error:
      return Icons.error_rounded;
    case FlushbarVibe.warning:
      return Iconsax.info_circle;
  }
}

List<Color> _resolveFlushbarVibe(BuildContext context, FlushbarVibe vibe) {
  // Premium colors with good contrast and subtle backgrounds
  const errorColor = Color(0xFFB00020); // Deep red
  final errorBgColor = errorColor.withValues(alpha: 0.15);

  const successColor = Color(0xFF2E7D32); // Rich green
  final successBgColor = successColor.withValues(alpha: 0.15);

  const warningColor = Color(0xFFF9A825); // Warm gold
  final warningBgColor = warningColor.withValues(alpha: 0.15);

  // final normalColor = context.isDarkMode ? Colors.white : Colors.black87;
  // final normalBgColor =
  //     context.isDarkMode
  //         ? const Color(0xFF1E1E2C).withValues(alpha: 0.85) // Darker, muted blue-gray
  //         : const Color(0xFFF5F5F7).withValues(alpha: 0.85); // Soft off-white

  final normalColor = context.theme.colorScheme.onSurface;
  final normalBgColor = context.theme.colorScheme.surface.withValues(alpha: 0.4);

  switch (vibe) {
    case FlushbarVibe.none:
      return [normalColor, normalBgColor];
    case FlushbarVibe.error:
      return [errorColor, errorBgColor];
    case FlushbarVibe.success:
      return [successColor, successBgColor];
    case FlushbarVibe.warning:
      return [warningColor, warningBgColor];
  }
}



/// LoadingContainerView
class LoadingContainerView extends StatelessWidget {
  const LoadingContainerView({
    super.key,
    this.msg = "Just a moment...",
    this.msgTextStyle,
    this.backgroundColor,
    this.adaptToScreenSize = false,
    this.progressIndicatorColor,
  });
  final String? msg;
  final TextStyle? msgTextStyle;
  final Color? backgroundColor;
  final bool adaptToScreenSize;
  final Color? progressIndicatorColor;

  @override
  Widget build(BuildContext context) {
    final double screenWidth = MediaQuery.sizeOf(context).width;
    final ThemeData themeData = Theme.of(context);
    final primaryColor = themeData.primaryColor;
    final isDarkMode = themeData.brightness == Brightness.dark;

    return Align(
      alignment: Alignment.center,
      child: DecoratedBox(
        decoration: BoxDecoration(
          color: backgroundColor ?? (isDarkMode ? Colors.black : Colors.white),
          borderRadius: BorderRadius.circular(36),
          border: Border.fromBorderSide(BorderSide(color: Colors.blueGrey.withValues(alpha: 0.05))),
          boxShadow: [
            BoxShadow(
              offset: Offset.zero,
              blurRadius: 4.0,
              spreadRadius: 2.0,
              color: Colors.blueGrey.withValues(alpha: 0.2),
              blurStyle: BlurStyle.outer,
            ),
          ],
        ),
        child: SizedBox(
          width: adaptToScreenSize ? screenWidth * 0.6 : 240,
          height: adaptToScreenSize ? screenWidth * 0.4 : 160,
          child: ClipRRect(
            clipBehavior: Clip.hardEdge,
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                CircleAvatar(
                  backgroundColor: Colors.transparent,
                  child: CircularProgressIndicator(
                    strokeCap: StrokeCap.round,
                    color: progressIndicatorColor ?? primaryColor,
                  ),
                ),
                const SizedBox(height: 16),
                Padding(
                  padding: const EdgeInsets.fromLTRB(12, 8, 12, 8),
                  child: CustomText(
                    msg!,
                    color: msgTextStyle == null ? Colors.blueGrey : msgTextStyle?.color,
                    fontSize: msgTextStyle == null ? 14 : msgTextStyle!.fontSize!,
                    style: msgTextStyle,
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
