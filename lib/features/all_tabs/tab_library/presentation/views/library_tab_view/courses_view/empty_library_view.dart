import 'package:custom_widgets_toolkit/custom_widgets_toolkit.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:lottie/lottie.dart';
import 'package:slides_sync/core/routes/app_route_navigator.dart';
import 'package:slides_sync/shared/assets/strings/icon_strings.dart';
import 'package:slides_sync/shared/helpers/extension_helper.dart';

// class SimpleActionModel {
//   final String title;
//   final void Function() onTap;

//   SimpleActionModel({required this.title, required this.onTap});
// }

class EmptyLibraryView extends ConsumerWidget {
  final bool asSliver;
  const EmptyLibraryView({super.key, this.asSliver = true});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final theme = ref.theme;
    final child = SingleChildScrollView(
      physics: NeverScrollableScrollPhysics(),
      child: Column(
        // shrinkWrap: true,
        mainAxisSize: MainAxisSize.min,
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
                AppRouteNavigator.to(context).createCourseRoute();
              },
              backgroundColor: theme.altBackgroundPrimary,
              borderRadius: 12,
              pixelHeight: 44,
              label: "Create your course",
              textSize: 15,
              textColor: theme.onBackground,
            ),
          ),

          ConstantSizing.columnSpacingMedium,

          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 20.0),
            child: CustomElevatedButton(
              backgroundColor: theme.primaryColor,
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
    if (asSliver) {
      return SliverToBoxAdapter(child: child);
    } else {
      return child;
    }
  }
}
