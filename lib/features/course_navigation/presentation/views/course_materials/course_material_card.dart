import 'dart:developer';
import 'dart:math' as math;

import 'package:custom_widgets_toolkit/custom_widgets_toolkit.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:iconsax_flutter/iconsax_flutter.dart';
import 'package:slides_sync/data/models/course_model/course_model.dart';
import 'package:slides_sync/shared/helpers/extension_helper.dart';
import 'package:slides_sync/shared/helpers/widget_helper.dart';
import 'package:slides_sync/shared/styles/external/ui_styles.dart';

class CourseMaterialCard extends ConsumerStatefulWidget {
  final CourseContent courseContent;
  final AutoDisposeStateProvider<bool> isCourseMaterialCardExpandedProvider;
  final List<CourseMaterialCardActionModel> courseMaterialCardActionModels;
  final void Function() onTapCard;
  final void Function() onLongPressed;

  const CourseMaterialCard({
    super.key,
    required this.courseContent,
    required this.isCourseMaterialCardExpandedProvider,
    this.courseMaterialCardActionModels = const <CourseMaterialCardActionModel>[],
    required this.onTapCard,
    required this.onLongPressed,
  });

  @override
  ConsumerState<CourseMaterialCard> createState() => _CourseMaterialCardState();
}

class _CourseMaterialCardState extends ConsumerState<CourseMaterialCard> with SingleTickerProviderStateMixin {
  late AnimationController expandAnimationController;
  late Animation<double> expandAnim;

  @override
  void initState() {
    super.initState();
    expandAnimationController = AnimationController(vsync: this, duration: Durations.extralong2, reverseDuration: Durations.medium2);
    expandAnim = Tween<double>(begin: 0, end: 1).animate(
      CurvedAnimation(parent: expandAnimationController, curve: CustomCurves.bouncySpring, reverseCurve: CustomCurves.bouncySpring),
    );
  }

  @override
  void dispose() {
    expandAnimationController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    ref.listen<bool>(widget.isCourseMaterialCardExpandedProvider, (previous, next) {
      if (!mounted) return;
      next ? expandAnimationController.forward() : expandAnimationController.reverse();
    });

    final courseContent = widget.courseContent;
    return AnimatedContainer(
      duration: Durations.extralong4,
      margin: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
      decoration: UiStyles.getBlueThemedBoxDecoration(context.isDarkMode),
      child: InkWell(
        borderRadius: BorderRadius.circular(10),
        onTap: widget.onTapCard,
        onLongPress: widget.onLongPressed,
        child: Padding(
          padding: EdgeInsets.symmetric(vertical: 12, horizontal: 12),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  // if (courseContent.path.isEmpty)
                  CustomElevatedButton(
                    onClick: () {},
                    pixelWidth: 64,
                    pixelHeight: 64,
                    borderRadius: 8.0,
                    backgroundColor: Colors.deepPurple.withAlpha(40),
                    child: Icon(WidgetHelper.resolveIconData(courseContent.courseContentType, true)),
                  ),
                  // else
                  //   Badge(
                  //     backgroundColor: Colors.transparent,
                  //     label: CircleAvatar(
                  //       radius: 13,
                  //       backgroundColor: UiStyles.getBlueThemedBoxDecoration(context.isDarkMode).color,
                  //       child: CircleAvatar(
                  //         radius: 12,
                  //         backgroundColor: Colors.deepPurple.withAlpha(40),
                  //         child: Icon(Iconsax.music, size: 15),
                  //       ),
                  //     ),
                  //     offset: Offset(-8, 0),
                  //     child: CustomElevatedButton(
                  //       onClick: () {},
                  //       pixelWidth: 72,
                  //       pixelHeight: 72,
                  //       borderRadius: 8.0,
                  //       backgroundColor: Colors.deepPurple.withAlpha(40),
                  //       child: courseMaterialCardModel.previewImage,
                  //     ),
                  //   )
                  ConstantSizing.rowSpacingMedium,
                  Expanded(
                    child: Column(
                      mainAxisSize: MainAxisSize.min,
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        CustomText(courseContent.title, fontSize: 13),
                        ConstantSizing.columnSpacingMedium,
                        LinearProgressIndicator(
                          minHeight: 8,
                          borderRadius: BorderRadius.circular(36),
                          value: math.Random().nextDouble(),
                          backgroundColor: Colors.black.withAlpha(40),
                          color: Colors.deepPurple, //.withAlpha(40)
                        ),
                      ],
                    ),
                  ),
                  ConstantSizing.rowSpacingMedium,
                  IconButton(
                    onPressed: () {},
                    style: ButtonStyle(backgroundColor: WidgetStatePropertyAll(Colors.lightBlueAccent.withAlpha(15))),
                    icon: Icon(Iconsax.arrow_circle_right),
                  ),
                ],
              ),

              SizeTransition(sizeFactor: expandAnim, child: ConstantSizing.columnSpacingMedium),

              AnimatedCourseMaterialCardMenu(courseMaterialCardActionModels: widget.courseMaterialCardActionModels, expandAnim: expandAnim),
            ],
          ),
        ),
      ),
    );
  }
}

class AnimatedCourseMaterialCardMenu extends StatelessWidget {
  const AnimatedCourseMaterialCardMenu({super.key, required this.courseMaterialCardActionModels, required this.expandAnim});

  final List<CourseMaterialCardActionModel> courseMaterialCardActionModels;
  final Animation<double> expandAnim;

  @override
  Widget build(BuildContext context) {
    return Builder(
      builder: (context) {
        final cam = courseMaterialCardActionModels;
        final List<Widget> genCardFuncs = List.generate(cam.length, (index) {
          return ScaleTransition(
            scale: expandAnim,
            child: CustomElevatedButton(
              borderRadius: 24,
              backgroundColor: Colors.deepPurple.withAlpha(40),
              onClick: cam[index].onTap,
              child: Row(
                mainAxisSize: MainAxisSize.min,
                children: [Icon(cam[index].icon), ConstantSizing.rowSpacingSmall, CustomText(cam[index].label)],
              ),
            ),
          );
        });
        return SizeTransition(
          sizeFactor: expandAnim,
          child: FadeTransition(
            opacity: expandAnim,
            child: Padding(
              padding: EdgeInsets.only(left: context.deviceWidth * 0.2 + ConstantSizing.rowSpacingMedium.width!),
              child: Wrap(runAlignment: WrapAlignment.start, spacing: 8.0, runSpacing: 8.0, children: genCardFuncs),
            ),
          ),
        );
      },
    );
  }
}

// class CourseMaterialCardModel {
//   final String title;
//   final double progress;
//   final Widget? previewImage;
//   final void Function()? onOpen;
//   final List<CourseMaterialCardActionModel> CourseMaterialCardActionModels;

//   CourseMaterialCardModel({
//     required this.title,
//     required this.progress,
//     this.previewImage,
//     this.onOpen,
//     required this.CourseMaterialCardActionModels,
//   });

//   CourseMaterialCardModel copyWith({
//     String? title,
//     double? progress,
//     Widget? previewImage,
//     void Function()? onOpen,
//     List<CourseMaterialCardActionModel>? CourseMaterialCardActionModels,
//   }) {
//     return CourseMaterialCardModel(
//       title: title ?? this.title,
//       progress: progress ?? this.progress,
//       previewImage: previewImage ?? this.previewImage,
//       onOpen: onOpen ?? this.onOpen,
//       CourseMaterialCardActionModels: CourseMaterialCardActionModels ?? this.CourseMaterialCardActionModels,
//     );
//   }
// }

class CourseMaterialCardActionModel {
  final String label;
  final IconData icon;
  final void Function() onTap;

  CourseMaterialCardActionModel({required this.label, required this.icon, required this.onTap});

  CourseMaterialCardActionModel copyWith({String? label, IconData? icon, void Function()? onTap}) {
    return CourseMaterialCardActionModel(label: label ?? this.label, icon: icon ?? this.icon, onTap: onTap ?? this.onTap);
  }
}
