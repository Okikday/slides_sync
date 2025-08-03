import 'dart:ui';

import 'package:custom_widgets_toolkit/custom_widgets_toolkit.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:slides_sync/shared/helpers/extension_helper.dart';
import 'package:slides_sync/shared/styles/colors.dart';

class AppCustomizableDialog extends ConsumerWidget {
  final Widget? leading;
  final Alignment alignment;

  /// Representing vertically aligned actions
  final Widget child;
  final Color? backgroundColor;
  final Offset? blurSigma;
  final void Function()? onPop;
  const AppCustomizableDialog({
    super.key,
    this.blurSigma = const Offset(4, 4),
    this.leading,
    this.alignment = Alignment.center,
    required this.child,
    this.backgroundColor,
    this.onPop,
  });

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    return Stack(
      alignment: alignment,
      clipBehavior: Clip.hardEdge,
      children: [
        Positioned.fill(
          child: GestureDetector(
            onTap: () {
              if (onPop != null) {
                onPop!();
              } else {
                CustomDialog.hide(context);
              }
            },
          ),
        ),
        Positioned(
          left: 24,
          right: 24,
          bottom: alignment == Alignment.bottomCenter ? context.padding.bottom + 16.0 : null,
          top: alignment == Alignment.topCenter ? context.padding.top + 16.0 : null,
          child: Container(
            clipBehavior: Clip.hardEdge,
            constraints: BoxConstraints(maxHeight: context.deviceHeight * 0.7, maxWidth: context.deviceWidth),
            decoration: BoxDecoration(
              color: backgroundColor ?? AppColors.bgBlendColor(context, 0.84, 0.16).withValues(alpha: 0.4),
              borderRadius: BorderRadius.circular(16.0),
              boxShadow: [
                BoxShadow(color: Colors.white12, offset: Offset(1, 1), blurRadius: 3, blurStyle: BlurStyle.outer),
              ],
            ),
            padding: EdgeInsets.only(top: 16.0, bottom: 8.0),
            child:
                blurSigma != null
                    ? BackdropFilter(
                      filter: ImageFilter.blur(sigmaX: blurSigma!.dx, sigmaY: blurSigma!.dy),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        mainAxisSize: MainAxisSize.min,
                        children: [if (leading != null) leading!, Flexible(child: child)],
                      ),
                    )
                    : Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      mainAxisSize: MainAxisSize.min,
                      children: [if (leading != null) leading!, Flexible(child: child)],
                    ),
          ),
        ),
      ],
    );
  }
}
