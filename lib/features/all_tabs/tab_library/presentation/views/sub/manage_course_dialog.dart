import 'dart:ui';

import 'package:custom_widgets_toolkit/custom_widgets_toolkit.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_animate/flutter_animate.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:iconsax_flutter/iconsax_flutter.dart';
import 'package:slides_sync/core/utils/app_navigator.dart';
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
          Positioned.fill(
            child: OrganicBackgroundEffect(
              gradientOpacity: 0.015,
              gradientColors: [context.theme.primaryColor, context.theme.colorScheme.onSecondary],
            ),
          ),

          Positioned(
            bottom: 88,
            right: 16,
            child: FloatingActionButton(
              onPressed: () async {
                animationController.reverse();
                if (context.mounted) CustomDialog.hide(context);
              },
              elevation: 8.0,
              backgroundColor: context.isDarkMode ? context.theme.colorScheme.secondary.withAlpha(40) : context.theme.colorScheme.secondary.withAlpha(80),
              shape: RoundedRectangleBorder(borderRadius: BorderRadiusGeometry.circular(18)),
              child: ClipRSuperellipse(
                borderRadius: BorderRadius.circular(16.0),
                child: ColoredBox(
                  color: context.theme.primaryColor,
                  child: SizedBox(width: 51, height: 51, child: Icon(Iconsax.close_circle, color: context.theme.colorScheme.tertiary)),
                ),
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
    var divider = Divider(color: context.theme.colorScheme.secondary.withAlpha(40).withAlpha(40), height: 4);
    return SingleChildScrollView(
      child:
          Container(
                width: width - (rightPad + 20),
                
                constraints: BoxConstraints(maxHeight: 200, maxWidth: 300),
                clipBehavior: Clip.hardEdge,
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(16),
                  color: context.theme.colorScheme.onSurface.withValues(alpha: 0.8),
                  border: Border.fromBorderSide(BorderSide(color: context.theme.colorScheme.secondary.withAlpha(40), width: 0)),
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
                              icon: Icon(Iconsax.add_circle, size: 24, color: context.theme.colorScheme.outline),
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
                              icon: Icon(Iconsax.creative_commons, size: 24, color: context.theme.colorScheme.outline),
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
                              icon: Icon(Iconsax.edit, size: 24, color: context.theme.colorScheme.outline),
                              onTap: () {
                                CustomDialog.hide(context);
                                AppNavigator.to(context).modifyExistingCoursesRoute();
                              },
                            ),
                          ),

                          divider,

                          ClipRSuperellipse(
                            borderRadius: BorderRadius.circular(12),
                            child: BuildPlainActionButton(
                              contentPadding: EdgeInsets.fromLTRB(4, 8, 4, 8),
                              title: "App File Manager",
                              icon: Icon(Iconsax.folder, size: 24, color: context.theme.colorScheme.outline),
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
