import 'package:custom_widgets_toolkit/custom_widgets_toolkit.dart';
import 'package:flutter/material.dart';
import 'package:flutter_animate/flutter_animate.dart';
import 'package:iconsax_flutter/iconsax_flutter.dart';
import 'package:lottie/lottie.dart';
import 'package:page_transition/page_transition.dart';
import 'package:slides_sync/features/course_mgmt/data/models/course_model/course_model.dart';
import 'package:slides_sync/features/course_navigation/presentation/views/course_details/course_categories_card.dart';
import 'package:slides_sync/features/course_navigation/presentation/views/course_materials_view.dart';
import 'package:slides_sync/shared/helpers/widget_helper.dart';
import 'package:slides_sync/shared/strings/icon_strings.dart';
import 'package:slides_sync/shared/styles/app_ui_context.dart';

class CourseDetailsCollectionSection extends StatelessWidget {
  const CourseDetailsCollectionSection({super.key, required this.collections});

  final List<CourseSubCollection> collections;

  @override
  Widget build(BuildContext context) {
    if (collections.isEmpty) {
      return SliverToBoxAdapter(
        child: SingleChildScrollView(
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
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

    return SliverList.builder(
      itemCount: collections.length,
      itemBuilder: (context, index) {
        return Padding(
          padding: const EdgeInsets.only(bottom: 12.0, left: 16.0, right: 16.0),
          child: CourseCategoriesCard(
            isDarkMode: context.isDarkMode,
            title: collections[index].collectionTitle,
            icon: WidgetHelper.resolveImageWidget(collections[index].imagePath, fallbackWidget: Icon(Iconsax.book)),
            onTap: () {
              if (context.mounted) {
                Navigator.of(context).push(
                  PageTransition(
                    type: PageTransitionType.rightToLeftWithFade,
                    duration: Durations.extralong3,
                    reverseDuration: Durations.medium1,
                    curve: CustomCurves.snappySpring,
                    child: CourseMaterialsView(),
                  ),
                );
              }
            },
          ).animate().slideY(
            begin: double.parse((0.5 * (index + (collections.length / 2) / collections.length)).toStringAsFixed(2)),
            end: 0,
            curve: CustomCurves.bouncySpring,
            duration: Durations.extralong4,
          ),
        );
      },
    );
  }
}
