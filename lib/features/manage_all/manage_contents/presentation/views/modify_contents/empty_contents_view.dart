import 'package:custom_widgets_toolkit/custom_widgets_toolkit.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:lottie/lottie.dart';
import 'package:slides_sync/domain/models/course_model/sub/course_collection.dart';
import 'package:slides_sync/features/manage_all/manage_contents/presentation/views/add_contents/add_contents_bottom_sheet.dart';
import 'package:slides_sync/shared/helpers/extension_helper.dart';
import 'package:slides_sync/shared/assets/strings/icon_strings.dart';

class EmptyContentsView extends ConsumerWidget {
  final CourseCollection collection;
  const EmptyContentsView({super.key, required this.collection});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    return SliverToBoxAdapter(
      child: Center(
        child: ListView(
          shrinkWrap: true,
          physics: const NeverScrollableScrollPhysics(),
          children: [
            ConstantSizing.columnSpacing(context.deviceHeight * 0.2),
            SizedBox.square(
              dimension: context.deviceWidth * 0.5,
              child: LottieBuilder.asset(IconStrings.instance.roundedPlayingFace, reverse: true),
            ),

            ConstantSizing.columnSpacingExtraLarge,
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 20.0),
              child: CustomElevatedButton(
                onClick: () {
                  CustomDialog.show(
                    context,
                    transitionDuration: Durations.short1,
                    reverseTransitionDuration: Durations.short1,
                    barrierColor: Colors.black45,
                    child: AddContentsBottomSheet(collection: collection),
                  );
                },
                backgroundColor: ref.theme.primaryColor,
                // backgroundColor: context.theme.colorScheme.secondary,
                borderRadius: 12,
                pixelHeight: 44,
                label: "Add a content",
                textSize: 15,
                textColor: ref.theme.onPrimaryText,
              ),
            ),

            // ConstantSizing.columnSpacingMedium,

            // Padding(
            //   padding: const EdgeInsets.symmetric(horizontal: 20.0),
            //   child: CustomElevatedButton(
            //     backgroundColor: ref.theme.primaryColor,
            //     borderRadius: 12,
            //     pixelHeight: 44,
            //     label: "Explore Contents",
            //     textSize: 15,
            //     textColor: Colors.white,
            //   ),
            // ),
          ],
        ),
      ),
    );
  }
}
