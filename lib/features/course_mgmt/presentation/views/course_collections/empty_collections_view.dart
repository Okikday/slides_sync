import 'package:custom_widgets_toolkit/custom_widgets_toolkit.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:lottie/lottie.dart';
import 'package:slides_sync/shared/strings/icon_strings.dart';
import 'package:slides_sync/shared/styles/app_ui_context.dart';

class EmptyCollectionsView extends ConsumerWidget {
  const EmptyCollectionsView({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    return SliverToBoxAdapter(
      child: SingleChildScrollView(
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            ConstantSizing.columnSpacing((context.deviceHeight / 2) - context.deviceWidth * 0.5 - ConstantSizing.spaceHuge - 48),
            SizedBox.square(
              dimension: context.deviceWidth * 0.5,
              child: LottieBuilder.asset(IconStrings.instance.roundedPlayingFace, reverse: true),
            ),

            CustomText("Oops, can't find any collections", color: Colors.blueGrey),

            ConstantSizing.columnSpacingHuge,
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 20.0),
              child: CustomElevatedButton(
                backgroundColor: Colors.deepPurple,
                borderRadius: 12,
                pixelHeight: 44,
                label: "Add a new collection",
                textSize: 15,
                textColor: Colors.white,
              ),
            ),
          ],
        ),
      ),
    );
  }
}
