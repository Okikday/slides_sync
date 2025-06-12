import 'dart:math' as math;

import 'package:custom_widgets_toolkit/custom_widgets_toolkit.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:iconsax_flutter/iconsax_flutter.dart';
import 'package:slides_sync/features/course_navigation/presentation/models/course_materials_models/course_material_card_model.dart';
import 'package:slides_sync/shared/styles/app_ui_context.dart';
import 'package:slides_sync/shared/styles/external/ui_styles.dart';

class CourseMaterialCard extends ConsumerStatefulWidget {
  final int index;
  final int listLength;
  final AutoDisposeStateProviderFamily<bool, int> isCourseMaterialCardExpandedFamily;
  final CourseMaterialCardModel courseMaterialCardModel;

  const CourseMaterialCard({
    super.key,
    required this.courseMaterialCardModel,
    required this.index,
    required this.listLength,
    required this.isCourseMaterialCardExpandedFamily,
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
    final CourseMaterialCardModel courseMaterialCardModel = widget.courseMaterialCardModel;

    ref.listen<bool>(widget.isCourseMaterialCardExpandedFamily(widget.index), (previous, next) {
      if (!mounted) return;
      next ? expandAnimationController.forward() : expandAnimationController.reverse();
    });

    return AnimatedContainer(
      duration: Durations.extralong4,
      margin: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
      decoration: UiStyles.getBlueThemedBoxDecoration(context.isDarkMode),
      child: InkWell(
        borderRadius: BorderRadius.circular(10),
        onTap: (){

        },
        child: Padding(
          padding: EdgeInsets.symmetric(vertical: 12, horizontal: 12),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  courseMaterialCardModel.previewImage == null
                      ? CustomElevatedButton(
                        onClick: () {},
                        pixelWidth: 72,
                        pixelHeight: 72,
                        borderRadius: 8.0,
                        backgroundColor: Colors.deepPurple.withAlpha(40),
                        child: Icon(Iconsax.book_1_copy),
                      )
                      : CustomElevatedButton(
                        onClick: () {},
                        pixelWidth: 72,
                        pixelHeight: 72,
                        borderRadius: 8.0,
                        backgroundColor: Colors.deepPurple.withAlpha(40),
                        child: courseMaterialCardModel.previewImage,
                      ),
                  ConstantSizing.rowSpacingMedium,
                  Expanded(
                    child: Column(
                      mainAxisSize: MainAxisSize.min,
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        CustomText(courseMaterialCardModel.title, fontSize: 13),
                        ConstantSizing.columnSpacingMedium,
                        LinearProgressIndicator(
                          minHeight: 8,
                          borderRadius: BorderRadius.circular(36),
                          value: courseMaterialCardModel.progress,
                          backgroundColor: Colors.black.withAlpha(40),
                          color: Colors.deepPurple, //.withAlpha(40)
                        ),
                      ],
                    ),
                  ),
                  ConstantSizing.rowSpacingMedium,
                  IconButton(
                    onPressed: () {
                      for (int i = 0; i < widget.listLength; i++) {
                        final isExpandedNotifier = ref.read(widget.isCourseMaterialCardExpandedFamily(i).notifier);
                        if (i == widget.index) {
                          isExpandedNotifier.update((cb) => !isExpandedNotifier.state);
                        } else {
                          if (isExpandedNotifier.state) {
                            isExpandedNotifier.update((cb) => false);
                          }
                        }
                        // log("$i. ${isExpandedNotifier.state}");
                      }
                    },
                    style: ButtonStyle(backgroundColor: WidgetStatePropertyAll(Colors.lightBlueAccent.withAlpha(20))),
                    icon: AnimatedBuilder(
                      animation: expandAnim,
                      builder: (context, child) {
                        return Transform.rotate(
                          angle: double.parse((math.pi).toStringAsFixed(3)) * expandAnim.value,
                          child: Icon(Icons.keyboard_arrow_down, size: 28),
                        );
                      },
                    ),
                  ),
                ],
              ),

              SizeTransition(sizeFactor: expandAnim, child: ConstantSizing.columnSpacingMedium),

              Builder(
                builder: (context) {
                  final List<CourseMaterialCardFunctionsModel> cardsList = courseMaterialCardModel.courseMaterialCardFunctionsModels;
                  final List<Widget> genCardFuncs = List.generate(cardsList.length, (index) {
                    return ScaleTransition(
                      scale: expandAnim,
                      child: CustomElevatedButton(
                        borderRadius: 24,
                        backgroundColor: Colors.deepPurple.withAlpha(40),
                        onClick: cardsList[index].onTap,
                        child: Row(
                          mainAxisSize: MainAxisSize.min,
                          children: [Icon(cardsList[index].icon), ConstantSizing.rowSpacingSmall, CustomText(cardsList[index].label)],
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
              ),
            ],
          ),
        ),
      ),
    );
  }
}
