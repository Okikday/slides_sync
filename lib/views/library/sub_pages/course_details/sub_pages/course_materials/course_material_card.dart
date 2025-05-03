import 'dart:developer';
import 'dart:math' as math;

import 'package:custom_widgets_toolkit/custom_widgets_toolkit.dart';
import 'package:flutter/material.dart';
import 'package:flutter_animate/flutter_animate.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:iconsax_flutter/iconsax_flutter.dart';
import 'package:slides_sync/app/states/app_ui_state.dart';
import 'package:slides_sync/use_cases/library/library_ui_funcs.dart';
import 'package:slides_sync/views/library/sub_pages/course_details/sub_pages/course_materials_view.dart';

class CourseMaterialCard extends ConsumerStatefulWidget {
  final AppUiModel appUiModel;
  final int index;
  final int listLength;
  final NotifierProviderFamily<IsCourseMaterialCardExpanded, bool, int> isCourseMaterialCardExpandedFamily;
  final CourseMaterialCardModel courseMaterialCardModel;

  const CourseMaterialCard(this.appUiModel, {super.key, required this.courseMaterialCardModel, required this.index, required this.listLength, required this.isCourseMaterialCardExpandedFamily});

  @override
  ConsumerState<CourseMaterialCard> createState() => _CourseMaterialCardState();
}

class _CourseMaterialCardState extends ConsumerState<CourseMaterialCard> with SingleTickerProviderStateMixin {
  late AnimationController expandAnimationController;
  late Animation<double> expandAnim;

  @override
  void initState() {
    super.initState();
    expandAnimationController = AnimationController(vsync: this, duration: Durations.extralong2, reverseDuration: Duration(milliseconds: 300));
    expandAnim = Tween<double>(begin: 0, end: 1).animate(
      CurvedAnimation(parent: expandAnimationController, curve: CustomCurves.bouncySpring, reverseCurve: CustomCurves.decelerate),
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
    final AppUiModel appUiModel = widget.appUiModel;

    WidgetsBinding.instance.addPostFrameCallback((_){
      final bool isMenuExpanded = ref.watch(widget.isCourseMaterialCardExpandedFamily(widget.index));
      isMenuExpanded ? expandAnimationController.forward() : expandAnimationController.reverse();
    });

    return AnimatedContainer(
      duration: Durations.extralong4,
      margin: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
      padding: EdgeInsets.symmetric(vertical: 8, horizontal: 12),
      decoration: LibraryUiFuncs.getBoxDecorationStyle(appUiModel.isDarkMode),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              courseMaterialCardModel.previewImage == null
                  ? Container(
                    width: appUiModel.deviceWidth * 0.2,
                    height: appUiModel.deviceWidth * 0.2,
                    decoration: BoxDecoration(color: Colors.deepPurple.withAlpha(40), borderRadius: BorderRadius.circular(8.0)),
                    child: Icon(Iconsax.book_1_copy),
                  )
                  : Container(
                    color: Colors.deepPurple.withAlpha(40),
                    width: appUiModel.deviceWidth * 0.2,
                    height: appUiModel.deviceWidth * 0.2,
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
                  final bool newValue = !ref.watch(widget.isCourseMaterialCardExpandedFamily(widget.index));

                  log("$newValue");
                  for(int i = 0; i < widget.listLength; i++){
                    final NotifierFamilyProvider<IsCourseMaterialCardExpanded, bool, int> specificElementProvider = widget.isCourseMaterialCardExpandedFamily(i);
                    ref.read(specificElementProvider.notifier).update(false);
                  }
                  final NotifierFamilyProvider<IsCourseMaterialCardExpanded, bool, int> thisElementProvider = widget.isCourseMaterialCardExpandedFamily(widget.index);
                  ref.read(thisElementProvider.notifier).update(newValue);
                  newValue ? expandAnimationController.forward() : expandAnimationController.reverse();
                },
                style: ButtonStyle(backgroundColor: WidgetStatePropertyAll(Colors.lightBlueAccent.withAlpha(20))),
                icon: AnimatedBuilder(
                  animation: expandAnim,
                  builder: (context, child) {
                    return Transform.rotate(
                        angle: double.parse((math.pi).toStringAsFixed(3)) * expandAnim.value,
                        child: Icon(Icons.keyboard_arrow_down, size: 28));
                  }
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
                    padding: EdgeInsets.only(left: appUiModel.deviceWidth * 0.2 + ConstantSizing.rowSpacingMedium.width!),
                    child: Wrap(runAlignment: WrapAlignment.start, spacing: 8.0, runSpacing: 8.0, children: genCardFuncs),
                  ),
                ),
              );
            },
          ),
        ],
      ),
    );
  }
}

class CourseMaterialCardModel {
  final String title;
  final double progress;
  final Widget? previewImage;
  final void Function()? onOpen;
  final List<CourseMaterialCardFunctionsModel> courseMaterialCardFunctionsModels;

  CourseMaterialCardModel({
    required this.title,
    required this.progress,
    this.previewImage,
    this.onOpen,
    required this.courseMaterialCardFunctionsModels,
  });

  CourseMaterialCardModel copyWith({
    String? title,
    double? progress,
    Widget? previewImage,
    void Function()? onOpen,
    List<CourseMaterialCardFunctionsModel>? courseMaterialCardFunctionsModels,
  }) {
    return CourseMaterialCardModel(
      title: title ?? this.title,
      progress: progress ?? this.progress,
      previewImage: previewImage ?? this.previewImage,
      onOpen: onOpen ?? this.onOpen,
      courseMaterialCardFunctionsModels: courseMaterialCardFunctionsModels ?? this.courseMaterialCardFunctionsModels,
    );
  }
}

class CourseMaterialCardFunctionsModel {
  final String label;
  final IconData icon;
  final void Function() onTap;

  CourseMaterialCardFunctionsModel({required this.label, required this.icon, required this.onTap});

  CourseMaterialCardFunctionsModel copyWith({String? label, IconData? icon, void Function()? onTap}) {
    return CourseMaterialCardFunctionsModel(label: label ?? this.label, icon: icon ?? this.icon, onTap: onTap ?? this.onTap);
  }
}
