import 'dart:developer';
import 'dart:ui';

import 'package:custom_widgets_toolkit/custom_widgets_toolkit.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:lottie/lottie.dart';
import 'package:slides_sync/core/routes/routes.dart';
import 'package:slides_sync/core/routes/routes_strings.dart';
import 'package:slides_sync/core/utils/ui_utils.dart';
import 'package:slides_sync/features/auth/data/firebase_auth_data.dart';
import 'package:slides_sync/features/auth/domain/services/user_auth/firebase_google_auth.dart';
import 'package:slides_sync/shared/assets/assets.dart';
import 'package:slides_sync/shared/assets/strings/icon_strings.dart';
import 'package:slides_sync/shared/helpers/extension_helper.dart';

class SignInView extends ConsumerWidget {
  const SignInView({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    const Color primaryPurple = Color(0xFF7D19FF);
    return AnnotatedRegion(
      value: UiUtils.getSystemUiOverlayStyle(ref.theme.background, context.isDarkMode),
      child: Scaffold(
        body: Stack(
          fit: StackFit.expand,
          children: [
            Positioned.fill(
              child: Image.asset(
                Assets.images.signInViewBg,
                fit: BoxFit.cover,
                color: primaryPurple.withValues(alpha: 0.5),
                colorBlendMode: BlendMode.srcIn,
              ),
            ),
            Positioned(
              top: 0,
              bottom: 0,
              left: 24,
              right: 24,
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Container(
                    width: context.deviceWidth/2,
                    decoration: BoxDecoration(color: ref.theme.background, shape: BoxShape.circle),
                    child: Image.asset("assets/logo/tinted_white_transparent.png")),
                  ConstantSizing.columnSpacing(kToolbarHeight),

                  CustomText("Sign in to Slide..Sync and Simplify your learning journey", color: ref.theme.primaryText, textAlign: TextAlign.center,),
                  ConstantSizing.columnSpacing(kToolbarHeight),
                  CustomElevatedButton(
                    label: "Sign in",
                    textSize: 18,
                    pixelHeight: 60,
                    borderRadius: 100,
                    backgroundColor: primaryPurple,
                    textColor: ref.theme.onPrimaryText,
                    onClick: () async {
                      UiUtils.showCustomDialog(
                        context,
                        canPop: false,
                        blurSigma: Offset(2, 2),
                        transitionType: TransitionType.fade,
                        child: Stack(
                          fit: StackFit.expand,
                          alignment: Alignment.center,
                          children: [
                            Positioned.fill(child: OrganicBackgroundEffect(gradientColors: [ref.theme.primaryColor, Color(0xFF008080)], gradientOpacity: 0.1,)),
                            Positioned.fill(
                              child: Column(
                                mainAxisAlignment: MainAxisAlignment.center,
                                mainAxisSize: MainAxisSize.min,
                                spacing: 12,
                                children: [
                                  SizedBox.square(
                                    dimension: 120,
                                    child: Lottie.asset(
                                      IconStrings.instance.loadingSpinner,
                                      delegates: LottieDelegates(
                                        values: [
                                          ValueDelegate.colorFilter([
                                            "**",
                                          ], value: ColorFilter.mode(ref.theme.primaryColor, BlendMode.srcIn)),
                                        ],
                                      ),
                                    ),
                                  ),
                                  CustomText("Signing you in...Just a moment", color: ref.theme.onPrimaryText, fontSize: 20, fontWeight: FontWeight.bold,)
                                ],
                              ),
                            ),
                          ],
                        ),
                      );
                      final auth = FirebaseGoogleAuth();
                      final result = await auth.signInWithGoogle();
                      if(context.mounted) {
                        context.pop();
                      }else{
                        rootNavigatorKey.currentContext?.pop();
                      }

                     if(result.isSuccess) context.go(RoutesStrings.homeView);
                    },
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
