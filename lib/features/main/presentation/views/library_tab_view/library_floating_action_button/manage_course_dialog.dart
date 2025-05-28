import 'package:custom_widgets_toolkit/custom_widgets_toolkit.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_animate/flutter_animate.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:iconsax_flutter/iconsax_flutter.dart';
import 'package:slides_sync/core/usecases/app_navigator.dart';
import 'package:slides_sync/features/course_mgmt/presentation/views/create_course_view.dart';
import 'package:slides_sync/features/course_mgmt/presentation/views/select_to_modify_course_view.dart';
import 'package:slides_sync/shared/styles/app_ui_context.dart';

class ManageCourseDialog extends ConsumerStatefulWidget {
  const ManageCourseDialog({super.key});

  @override
  ConsumerState<ConsumerStatefulWidget> createState() => _ManageCourseDialogState();
}

class _ManageCourseDialogState extends ConsumerState<ManageCourseDialog> with SingleTickerProviderStateMixin {
  late final AnimationController animationController;

  @override
  void initState() {
    super.initState();
    animationController = AnimationController(vsync: this);
  }

  @override
  void dispose() {
    animationController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final double bottomPad = kBottomNavigationBarHeight + context.padding.bottom + context.viewInsets.bottom + kFloatingActionButtonMargin;
    final double rightPad = kToolbarHeight + 16 + 8.0;
    final double containerDimension = context.deviceHeight > context.deviceWidth ? context.deviceWidth * 0.65 : context.deviceWidth * 0.65;
    return Stack(
      children: [
        SizedBox(height: context.deviceHeight, width: context.deviceWidth),

        Positioned(
          bottom: bottomPad,
          right: 16,
          child: FloatingActionButton(
            onPressed: () async {
              animationController.reverse();
              if (context.mounted) LoadingDialog.hideLoadingDialog(context);
            },
            elevation: 8.0,
            backgroundColor: context.isDarkMode ? Colors.lightBlueAccent.withAlpha(40) : Colors.lightBlueAccent.withAlpha(80),
            shape: CircleBorder(),

            child: CircleAvatar(
              radius: 25,
              backgroundColor: context.isDarkMode ? Colors.lightBlueAccent : Colors.deepPurpleAccent,
              child: Icon(Iconsax.close_circle, color: context.isDarkMode ? Colors.blueGrey : Colors.white),
            ),
          ),
        ),

        Positioned(
          bottom: bottomPad + 28,
          right: rightPad,
          child: SingleChildScrollView(
            child: Container(
                  width: containerDimension,
                  height: containerDimension,
                  clipBehavior: Clip.hardEdge,
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(16),
                    color: context.isDarkMode ? Color(0xFF0E1F27).withValues(alpha: 0.87) : Color(0XFFDCF4FF).withValues(alpha: 0.80),
                    border: Border.fromBorderSide(BorderSide(color: Colors.deepPurple.withAlpha(40), width: 2)),
                  ),
                  child: SingleChildScrollView(
                    child: Padding(
                      padding: const EdgeInsets.all(8.0),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          ConstantSizing.columnSpacingMedium,
                          Divider(color: context.isDarkMode ? Colors.white.withAlpha(40) : Colors.black.withAlpha(40)),
                          CustomElevatedButton(
                            contentPadding: const EdgeInsets.only(left: 4.0, top: 4.0, bottom: 4.0),
                            backgroundColor: Colors.transparent,
                            onClick: () {
                              LoadingDialog.hideLoadingDialog(context);
                              Navigator.push(
                                context,
                                CupertinoSheetRoute(
                                  builder: (context) {
                                    return CreateCourseView();
                                  },
                                ),
                              );
                            },
                            child: Row(
                              spacing: 8.0,
                              children: [
                                Icon(Iconsax.add_circle, size: 24, color: Colors.deepPurpleAccent),
                                Expanded(child: CustomText("Create your course", fontSize: 14, fontWeight: FontWeight.bold)),
                              ],
                            ),
                          ),
                          Divider(color: context.isDarkMode ? Colors.white.withAlpha(40) : Colors.black.withAlpha(40)),
                          CustomElevatedButton(
                            contentPadding: const EdgeInsets.only(left: 4.0, top: 4.0, bottom: 4.0),
                            backgroundColor: Colors.transparent,
                            onClick: () {
                              LoadingDialog.hideLoadingDialog(context);
                              // AppNavigator.to(context).modifyExistingCoursesRoute();
                              Navigator.push(
                                context,
                                CupertinoSheetRoute(
                                  builder: (context) {
                                    return SelectToModifyCourseView();
                                  },
                                ),
                              );
                            },
                            child: Row(
                              spacing: 8.0,
                              children: [
                                Icon(Iconsax.setting_2, size: 24, color: Colors.deepPurpleAccent),
                                Expanded(child: CustomText("Modify Existing course", fontSize: 14, fontWeight: FontWeight.bold)),
                              ],
                            ),
                          ),
                          Divider(color: context.isDarkMode ? Colors.white.withAlpha(40) : Colors.black.withAlpha(40)),
                        ],
                      ),
                    ),
                  ),
                )
                .animate(controller: animationController)
                .scale(alignment: Alignment.bottomRight, curve: CustomCurves.defaultIosSpring, duration: Durations.medium2)
                .fade(begin: 0.0, end: 1.0),
          ),
        ),
      ],
    );
  }
}
