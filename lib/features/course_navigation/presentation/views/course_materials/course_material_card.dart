import 'dart:math' as math;

import 'package:custom_widgets_toolkit/custom_widgets_toolkit.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:iconsax_flutter/iconsax_flutter.dart';
import 'package:slides_sync/domain/models/file_details.dart';
import 'package:slides_sync/domain/models/course_model/course.dart';
import 'package:slides_sync/features/manage_all/manage_contents/usecases/create_contents_uc/create_content_preview_image.dart';
import 'package:slides_sync/shared/helpers/extension_helper.dart';
import 'package:slides_sync/shared/helpers/formatter.dart';
import 'package:slides_sync/shared/helpers/widget_helper.dart';
import 'package:slides_sync/shared/styles/colors.dart';
import 'package:slides_sync/shared/widgets/build_image_path_widget.dart';

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
    expandAnimationController = AnimationController(vsync: this, duration: Durations.extralong2, reverseDuration: Durations.medium1);
    expandAnim = Tween<double>(begin: 0, end: 1).animate(
      CurvedAnimation(parent: expandAnimationController, curve: CustomCurves.bouncySpring, reverseCurve: CustomCurves.defaultIosSpring),
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

    final CourseContent courseContent = widget.courseContent;
    return AnimatedContainer(
      duration: Durations.extralong4,
      margin: const EdgeInsets.symmetric(horizontal: 12, vertical: 10),
      decoration: BoxDecoration(color: AppColors.bgBlendColor(context), borderRadius: BorderRadius.circular(12)),
      child: Material(
        type: MaterialType.transparency,
        child: InkWell(
          borderRadius: BorderRadius.circular(10),
          overlayColor: WidgetStatePropertyAll(ref.theme.altBackgroundPrimary),
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
                    Container(
                      width: 50,
                      height: 50,
                      clipBehavior: Clip.antiAlias,
                      decoration: BoxDecoration(
                        color: ref.theme.primaryColor.withAlpha(40),
                        borderRadius: BorderRadius.circular(12),
                        // boxShadow: [BoxShadow(color: ref.theme.primaryColor.withAlpha(80), blurRadius: 2, spreadRadius: 2)],
                      ),
                      child: BuildImagePathWidget(
                        fileDetails: FileDetails(
                          filePath: CreateContentPreviewImage.genPreviewImagePath(
                            filePath: courseContent.path.filePath,
                          ),
                        ),
                        fallbackWidget: Icon(
                          WidgetHelper.resolveIconData(courseContent.courseContentType, true),
                          size: 20,
                        ),
                      ),
                    ),
                    ConstantSizing.rowSpacingMedium,
                    Expanded(
                      child: ConstrainedBox(
                        constraints: BoxConstraints(maxHeight: 100),
                        child: Column(
                          mainAxisSize: MainAxisSize.min,
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Flexible(
                              child: CustomText(
                                courseContent.title,
                                fontSize: 13,
                                color: ref.theme.primaryText,
                                fontWeight: FontWeight.w600,
                                overflow: TextOverflow.fade,
                              ),
                            ),
                            // ConstantSizing.columnSpacing(2),
                            CustomText(
                              Formatter.formatEnumName(courseContent.courseContentType.name),
                              fontSize: 11,
                              color: ref.theme.secondaryText,
                            ),
                            // ConstantSizing.columnSpacing(8),
                            // LinearProgressIndicator(
                            //   minHeight: 8,
                            //   borderRadius: BorderRadius.circular(36),
                            //   value: math.Random().nextDouble(),
                            //   backgroundColor: Colors.black.withAlpha(40),
                            //   color: ref.theme.primaryColor, //.withAlpha(40)
                            // ),
                          ],
                        ),
                      ),
                    ),
                    ConstantSizing.rowSpacingMedium,
                    // Icon(Iconsax.arrow_circle_right, color: AppColors.secondaryText(context)),
                  ],
                ),

                SizeTransition(sizeFactor: expandAnim, child: ConstantSizing.columnSpacingMedium),

                AnimatedCourseMaterialCardMenu(
                  courseMaterialCardActionModels: widget.courseMaterialCardActionModels,
                  expandAnim: expandAnim,
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}

class AnimatedCourseMaterialCardMenu extends ConsumerStatefulWidget {
  const AnimatedCourseMaterialCardMenu({super.key, required this.courseMaterialCardActionModels, required this.expandAnim});

  final List<CourseMaterialCardActionModel> courseMaterialCardActionModels;
  final Animation<double> expandAnim;

  @override
  ConsumerState<AnimatedCourseMaterialCardMenu> createState() =>
      _AnimatedCourseMaterialCardMenuState();
}

class _AnimatedCourseMaterialCardMenuState
    extends ConsumerState<AnimatedCourseMaterialCardMenu> {
  @override
  Widget build(BuildContext context) {
    return Builder(
      builder: (context) {
        final cam = widget.courseMaterialCardActionModels;
        final List<Widget> genCardFuncs = List.generate(cam.length, (index) {
          return ScaleTransition(
            scale: widget.expandAnim,
            child: CustomElevatedButton(
              borderRadius: 24,
              backgroundColor: ref.theme.primaryColor.withAlpha(40),
              onClick: cam[index].onTap,
              child: Row(
                mainAxisSize: MainAxisSize.min,
                children: [
                  Icon(cam[index].icon),
                  ConstantSizing.rowSpacingSmall,
                  CustomText(cam[index].label, color: ref.theme.primaryText),
                ],
              ),
            ),
          );
        });
        return SizeTransition(
          sizeFactor: widget.expandAnim,
          child: FadeTransition(
            opacity: widget.expandAnim,
            child: Padding(
              padding: EdgeInsets.only(left: context.deviceWidth * 0.2),
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
