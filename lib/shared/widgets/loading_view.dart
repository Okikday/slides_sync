import 'package:custom_widgets_toolkit/custom_widgets_toolkit.dart';
import 'package:flutter/material.dart';
import 'package:flutter_animate/flutter_animate.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:lottie/lottie.dart';
import 'package:slides_sync/shared/helpers/extension_helper.dart';
import 'package:slides_sync/shared/assets/strings/icon_strings.dart';
import 'package:slides_sync/shared/styles/colors.dart';

class LoadingView extends ConsumerWidget {
  final String msg;
  const LoadingView({super.key, this.msg = "Loading..."});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    return SingleChildScrollView(
      child: ConstrainedBox(
        constraints: BoxConstraints(maxHeight: 124),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            ConstantSizing.columnSpacingMedium,
            CircleAvatar(
              radius: 35,
              backgroundColor: ref.theme.altBackgroundPrimary.withAlpha(40),
              child: Lottie.asset(
                IconStrings.instance.loadingSpinner,
                delegates: LottieDelegates(
                  values: [
                    ValueDelegate.colorFilter(
                      ["**"],
                      value: ColorFilter.mode(
                        ref.theme.primary,
                        BlendMode.srcIn,
                      ),
                    ),
                  ],
                ),
              ),
            ).animate().scale(begin: Offset(0.6, 0.6), end: Offset(1, 1), duration: Durations.extralong1, curve: CustomCurves.bouncySpring),
            if (msg.isNotEmpty) ConstantSizing.columnSpacingMedium,
            if (msg.isNotEmpty) CustomText(msg, color: ref.theme.onBackground),
          ],
        ),
      ),
    );
  }
}
