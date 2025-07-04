import 'dart:ui';

import 'package:custom_widgets_toolkit/custom_widgets_toolkit.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_animate/flutter_animate.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:iconsax_flutter/iconsax_flutter.dart';
import 'package:slides_sync/core/utils/app_navigator.dart';
import 'package:slides_sync/features/create_content/presentation/views/add_contents_bottom_sheet.dart';
import 'package:slides_sync/features/modify_courses/presentation/views/select_to_modify_course_view.dart';
import 'package:slides_sync/shared/components/dialogs/app_action_dialog.dart';
import 'package:slides_sync/shared/helpers/extension_helper.dart';
import 'package:slides_sync/test/file_manager_page.dart';

class ManageCourseDialog extends ConsumerStatefulWidget {
  const ManageCourseDialog({super.key});

  @override
  ConsumerState<ManageCourseDialog> createState() => _ManageCourseDialogState();
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
    final double rightPad = kToolbarHeight + 16 + 8.0;
    // final double containerDimension = context.deviceHeight > context.deviceWidth ? context.deviceWidth * 0.65 : context.deviceWidth * 0.65;

    return PopScope(
      child: Stack(
        children: [
          Positioned.fill(child: GestureDetector(onTap: () {})),

          Positioned(
            bottom: 88,
            right: 16,
            child: FloatingActionButton(
              onPressed: () async {
                animationController.reverse();
                if (context.mounted) CustomDialog.hide(context);
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
            bottom: 88 + 24,
            right: rightPad,
            child: ManageCourseDialogCard(rightPad: rightPad, animationController: animationController),
          ),
        ],
      ),
    );
  }
}

class ManageCourseDialogCard extends StatelessWidget {
  const ManageCourseDialogCard({super.key, required this.rightPad, required this.animationController});

  final double rightPad;
  final AnimationController animationController;

  @override
  Widget build(BuildContext context) {
    final width = context.deviceWidth;
    final height = context.deviceHeight;
    var divider = Divider(color: Colors.blueGrey.withAlpha(40), height: 4);
    return SingleChildScrollView(
      child:
          Container(
                width: width - (rightPad + 32),
                height: width > height ? height * 0.5 : height * 0.3,
                constraints: BoxConstraints(maxHeight: 400, maxWidth: 400),
                clipBehavior: Clip.hardEdge,
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(16),
                  color:
                      context.isDarkMode
                          ? Color(0xFF0E1F27).withValues(alpha: 0.6)
                          : Color.fromARGB(255, 235, 248, 253).withValues(alpha: 0.6),
                  border: Border.fromBorderSide(BorderSide(color: Colors.deepPurple.withAlpha(100), width: 0)),
                ),
                child: BackdropFilter(
                  filter: ImageFilter.blur(sigmaX: 4, sigmaY: 4),
                  child: SingleChildScrollView(
                    child: Padding(
                      padding: const EdgeInsets.all(8.0),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          ClipRSuperellipse(
                            borderRadius: BorderRadius.circular(12),
                            child: BuildPlainActionButton(
                              contentPadding: EdgeInsets.fromLTRB(4, 8, 4, 8),
                              title: "Add material",
                              icon: Icon(Iconsax.add_circle, size: 24, color: Colors.deepPurpleAccent),
                              onTap: () {
                                // CustomDialog.hide(context);
                                // CustomDialog.show(context,
                                // barrierColor: Colors.black12,
                                //  child: AddContentsBottomSheet());
                              },
                            ),
                          ),

                          divider,

                          ClipRSuperellipse(
                            borderRadius: BorderRadius.circular(12),
                            child: BuildPlainActionButton(
                              contentPadding: EdgeInsets.fromLTRB(4, 8, 4, 8),
                              title: "Create course",
                              icon: Icon(Iconsax.add_circle, size: 24, color: Colors.deepPurpleAccent),
                              onTap: () {
                                CustomDialog.hide(context);
                                // AppNavigator.to(context).modifyExistingCoursesRoute();
                                AppNavigator.to(context).createCourseRoute();
                              },
                            ),
                          ),

                          divider,

                          ClipRSuperellipse(
                            borderRadius: BorderRadius.circular(12),
                            child: BuildPlainActionButton(
                              contentPadding: EdgeInsets.fromLTRB(4, 8, 4, 8),
                              title: "Modify Existing course",
                              icon: Icon(Iconsax.edit, size: 24, color: Colors.deepPurpleAccent),
                              onTap: () {
                                CustomDialog.hide(context);
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
                            ),
                          ),

                          divider,

                          ClipRSuperellipse(
                            borderRadius: BorderRadius.circular(12),
                            child: BuildPlainActionButton(
                              contentPadding: EdgeInsets.fromLTRB(4, 8, 4, 8),
                              title: "App File Manager",
                              icon: Icon(Iconsax.folder, size: 24, color: Colors.deepPurpleAccent),
                              onTap: () {
                                CustomDialog.hide(context);
                                // AppNavigator.to(context).modifyExistingCoursesRoute();
                                Navigator.push(
                                  context,
                                  CupertinoSheetRoute(
                                    builder: (context) {
                                      return FileManagerPage();
                                    },
                                  ),
                                );
                              },
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),
                ),
              )
              .animate(controller: animationController)
              .scaleXY(
                begin: 0.5,
                end: 1.0,
                alignment: Alignment.bottomRight,
                duration: Duration(milliseconds: 200),
                curve: CustomCurves.easeInOutSine,
              )
              .fadeIn(),
    );
  }
}
