import 'dart:ui';

import 'package:custom_widgets_toolkit/custom_widgets_toolkit.dart';
import 'package:flutter/material.dart';
import 'package:flutter_animate/flutter_animate.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:heroine/heroine.dart';
import 'package:slides_sync/features/auth/presentation/onboarding_views/onboarding_1.dart';
import 'package:slides_sync/shared/assets/assets.dart';
import 'package:slides_sync/shared/common_widgets/scale_click_wrapper.dart';
import 'package:slides_sync/shared/helpers/extension_helper.dart';

class WelcomeView extends ConsumerWidget {
  const WelcomeView({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final theme = ref.theme;
    return Scaffold(
      body: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 8),
        child: Stack(
          fit: StackFit.expand,
          alignment: Alignment.center,
          children: [
            Positioned(
              top: 0,
              left: 0,
              right: 0,
              child: Image.asset(
                Assets.images.clouds,
                color: theme.primaryColor.withAlpha(10),
                colorBlendMode: BlendMode.srcIn,
              ),
            ),

            Positioned(top: 0, bottom: 0, child: CircleAvatar(radius: 140, backgroundColor: Color(0xFFEAEAEA))),
            Positioned(
              top: 0,
              bottom: 0,
              child: SizedBox.square(dimension: 270, child: Image.asset(Assets.images.welcomeImageBottom))
                  .animate(onComplete: (controller) => controller.repeat(reverse: true, count: 2))
                  .scaleXY(duration: Durations.extralong4, begin: 0.8, end: 0.9, curve: CustomCurves.decelerate),
            ),

            Positioned(
              top: 0,
              bottom: 0,
              child: SizedBox.square(
                dimension: 300,
                child: Image.asset(Assets.images.welcomeImageTop),
              ).animate().rotate(duration: Durations.extralong4, curve: CustomCurves.decelerate),
            ),

            Positioned(
              top: context.topPadding + kToolbarHeight,
              child: ClipRRect(
                child: BackdropFilter(
                  filter: ImageFilter.blur(sigmaX: 4, sigmaY: 4),
                  child: Column(
                    mainAxisSize: MainAxisSize.min,
                    spacing: 8,
                    children: [
                      ClipOval(child: Image.asset("assets/logo/logo.png", width: 60, height: 60)),
                      CustomRichText(
                        children: [
                          CustomTextSpanData(
                            "Welcome to Slide",
                            fontSize: 24,
                            fontWeight: FontWeight.bold,
                            color: theme.onBackground,
                          ),
                          CustomTextSpanData(
                            "Sync",
                            fontSize: 24,
                            fontWeight: FontWeight.bold,
                            color: Color(0xFF7D19FF),
                          ),
                        ],
                      ),

                      CustomText(
                        "Where learning meets flow. Organized, always",
                        fontSize: 14,
                        color: theme.supportingText,
                      ),
                    ],
                  ),
                ),
              ),
            ),

            Positioned(
              bottom: context.bottomPadding + 8,
              left: 16,
              right: 16,
              child: Column(
                children: [
                  CustomText("Begin your journey", fontWeight: FontWeight.bold, color: Color(0xFF008080)),
                  ConstantSizing.columnSpacing(48),
                  ScaleClickWrapper(
                    borderRadius: 24,
                    onTapUp: (det) async {
                      await Future.delayed(Durations.short2);
                      if (context.mounted) {
                        Navigator.push(
                          context,
                          PageAnimation.pageRouteBuilder(
                            const Onboarding1(),
                            type: TransitionType.rightToLeft,
                            duration: Durations.extralong1,
                            curve: CustomCurves.defaultIosSpring,
                          ),
                        );
                      }
                    },
                    child: CustomElevatedButton(
                      label: "Get started",
                      textColor: Colors.white,
                      textSize: 14,
                      borderRadius: 48,
                      backgroundColor: Color(0xFF7D19FF),
                      pixelHeight: 56,
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}
