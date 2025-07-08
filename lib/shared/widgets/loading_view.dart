import 'package:custom_widgets_toolkit/custom_widgets_toolkit.dart';
import 'package:flutter/material.dart';
import 'package:flutter_animate/flutter_animate.dart';
import 'package:lottie/lottie.dart';
import 'package:slides_sync/shared/helpers/extension_helper.dart';
import 'package:slides_sync/shared/strings/icon_strings.dart';

class LoadingView extends StatelessWidget {
  final String msg;
  const LoadingView({super.key, this.msg = "Loading..."});

  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
      child: SizedBox(
        height: 124,
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            ConstantSizing.columnSpacingMedium,
            CircleAvatar(
              radius: 35,
              backgroundColor: Colors.lightBlueAccent.withAlpha(40),
              child: Lottie.asset(IconStrings.instance.loadingSpinner),
            ).animate().scale(begin: Offset(0.6, 0.6), end: Offset(1, 1), duration: Durations.extralong1, curve: CustomCurves.bouncySpring),
            ConstantSizing.columnSpacingMedium,
            CustomText(msg, color: context.theme.colorScheme.tertiary),
          ],
        ),
      ),
    );
  }
}
