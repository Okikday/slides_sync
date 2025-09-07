import 'dart:ui';

import 'package:custom_widgets_toolkit/custom_widgets_toolkit.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:heroine/heroine.dart';
import 'package:iconsax_flutter/iconsax_flutter.dart';
import 'package:slides_sync/core/utils/ui_utils.dart';
import 'package:slides_sync/features/auth/presentation/auth_views/sign_in_view.dart';
import 'package:slides_sync/shared/assets/assets.dart';
import 'package:slides_sync/shared/helpers/extension_helper.dart';

class Onboarding1 extends ConsumerWidget {
  const Onboarding1({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final shapeRadius = context.deviceWidth < context.deviceHeight ? context.deviceWidth : context.deviceHeight;
    const Color primaryPurple = Color(0xFF7D19FF);
    final theme = ref.theme;
    return Heroine(
      tag: "Welcome-to-Onboarding1",
      child: Scaffold(
        backgroundColor: Color(0xFFE1E1E0),
        body: Stack(
          fit: StackFit.expand,
          alignment: Alignment.center,
          children: [
            Positioned(top: 0, bottom: shapeRadius - kToolbarHeight, child: Image.asset(Assets.images.onboarding1)),
            Positioned(
              top: kToolbarHeight,
              child: Container(
                padding: EdgeInsets.symmetric(horizontal: 16, vertical: 8),
                clipBehavior: Clip.antiAlias,
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(24),
                  color: primaryPurple.withAlpha(20),
                  border: Border.fromBorderSide(
                    BorderSide(color: primaryPurple, strokeAlign: BorderSide.strokeAlignOutside),
                  ),
                ),
                child: BackdropFilter(
                  filter: ImageFilter.blur(sigmaX: 4, sigmaY: 4),
                  child: CustomText("Step 1", color: primaryPurple, fontWeight: FontWeight.bold),
                ),
              ),
            ),
            Positioned(
              bottom: -shapeRadius,
              child: Container(
                padding: EdgeInsets.all(0.5),
                decoration: BoxDecoration(
                  color: Colors.transparent,
                  shape: BoxShape.circle,
                  border: Border.fromBorderSide(BorderSide(color: theme.primaryColor.withAlpha(10), width: 1)),
                ),
                child: ClipOval(
                  child: ColoredBox(
                    color: Colors.white,
                    child: SizedBox.square(
                      dimension: shapeRadius * 2,
                      child: ClipRRect(
                        child: Column(
                          mainAxisSize: MainAxisSize.min,
                          children: [
                            ConstantSizing.columnSpacing(60),
                            SizedBox(
                              width: 180,
                              child: LinearProgressIndicator(
                                color: primaryPurple,
                                backgroundColor: Color(0xFFE8DDD9),
                                minHeight: 8,
                                borderRadius: BorderRadius.circular(24),
                                value: 0.6,
                              ),
                            ),
                            ConstantSizing.columnSpacing(40),
                            SizedBox(
                              width: shapeRadius - 40,
                              child: CustomRichText(
                                textAlign: TextAlign.center,
                                children: [
                                  CustomTextSpanData(
                                    "Your smarter way to ",
                                    fontSize: 24,
                                    fontWeight: FontWeight.bold,
                                    color: primaryPurple,
                                  ),
                                  CustomTextSpanData(
                                    "Sync",
                                    fontSize: 25,
                                    fontWeight: FontWeight.bold,
                                    color: Color(0xFF736B66),
                                  ),
                                  CustomTextSpanData(
                                    " Study, and Share knowledge",
                                    fontSize: 24,
                                    fontWeight: FontWeight.bold,
                                    color: primaryPurple,
                                  ),
                                ],
                              ),
                            ),
                          ],
                        ),
                      ),
                    ),
                  ),
                ),
              ),
              // .animate().slideY(begin: 0.5, end: 0)
            ),

            Positioned(
              bottom: 48,
              right: 24,
              child: CustomElevatedButton(
                shape: CircleBorder(),
                contentPadding: EdgeInsets.zero,
                backgroundColor: primaryPurple,
                pixelWidth: 60,
                pixelHeight: 60,
                child: Icon(Iconsax.arrow_right_1_copy, size: 32, color: theme.onPrimary),
                onClick: () {
                 
                  Navigator.push(context, PageAnimation.pageRouteBuilder(SignInView(), type: TransitionType.fade));
                   UiUtils.showFlushBar(context, msg: "Skipped Onboardings", vibe: FlushbarVibe.warning);
                },
              ),
            ),
          ],
        ),
      ),
    );
  }
}
