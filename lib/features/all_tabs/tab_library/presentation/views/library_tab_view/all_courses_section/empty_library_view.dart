import 'package:custom_widgets_toolkit/custom_widgets_toolkit.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:lottie/lottie.dart';
import 'package:slides_sync/core/utils/app_navigator.dart';
import 'package:slides_sync/features/manage_all/manage_course/presentation/views/create_course_view.dart';
import 'package:slides_sync/shared/assets/strings/icon_strings.dart';
import 'package:slides_sync/shared/helpers/extension_helper.dart';

// class SimpleActionModel {
//   final String title;
//   final void Function() onTap;

//   SimpleActionModel({required this.title, required this.onTap});
// }

class EmptyLibraryView extends ConsumerWidget {
  const EmptyLibraryView({super.key, });

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    return SliverToBoxAdapter(
      child: ListView(
        shrinkWrap: true,
        physics: const NeverScrollableScrollPhysics(),
        children: [
          SizedBox.square(
            dimension: context.deviceWidth * 0.5,
            child: LottieBuilder.asset(IconStrings.instance.roundedPlayingFace, reverse: true),
          ),

          ConstantSizing.columnSpacingExtraLarge,
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 20.0),
            child: CustomElevatedButton(
              onClick: () {
                AppNavigator.to(context).createCourseRoute();
              },
              backgroundColor: ref.theme.altBackgroundPrimary,
              borderRadius: 12,
              pixelHeight: 44,
              label: "Create your course",
              textSize: 15,
              textColor: ref.theme.primaryText,
            ),
          ),

          ConstantSizing.columnSpacingMedium,

          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 20.0),
            child: CustomElevatedButton(
              backgroundColor: ref.theme.primaryColor,
              borderRadius: 12,
              pixelHeight: 44,
              label: "Explore Courses",
              textSize: 15,
              textColor: Colors.white,
            ),
          ),
        ],
      ),
    );
  }
}
