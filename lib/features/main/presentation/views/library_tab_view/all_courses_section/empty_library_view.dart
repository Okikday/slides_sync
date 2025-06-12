import 'package:custom_widgets_toolkit/custom_widgets_toolkit.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:lottie/lottie.dart';
import 'package:slides_sync/features/create_course/presentation/views/create_course_view.dart';
import 'package:slides_sync/shared/strings/icon_strings.dart';
import 'package:slides_sync/shared/styles/app_ui_context.dart';

class EmptyLibraryView extends ConsumerWidget {
  const EmptyLibraryView({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    return SliverToBoxAdapter(
      child: ListView(
        shrinkWrap: true,
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
                Navigator.push(
                  context,
                  CupertinoSheetRoute(
                    builder: (context) {
                      return CreateCourseView();
                    },
                  ),
                );
              },
              backgroundColor: Colors.lightBlueAccent.withAlpha(40),
              borderRadius: 12,
              pixelHeight: 44,
              label: "Create your course",
              textSize: 15,
              textColor: context.isDarkMode ? Colors.white : Colors.black,
            ),
          ),

          ConstantSizing.columnSpacingMedium,

          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 20.0),
            child: CustomElevatedButton(
              backgroundColor: Colors.deepPurple,
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
