import 'dart:developer';
import 'dart:math' as math;

import 'package:custom_widgets_toolkit/custom_widgets_toolkit.dart';
import 'package:flutter/material.dart';
import 'package:flutter_animate/flutter_animate.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:iconsax_flutter/iconsax_flutter.dart';
import 'package:slides_sync/core/routes/app_route_navigator.dart';
import 'package:slides_sync/core/utils/ui_utils.dart';
import 'package:slides_sync/domain/models/course_model/course.dart';
import 'package:slides_sync/domain/models/course_model/sub/course_collection.dart';
import 'package:slides_sync/features/course_navigation/presentation/views/course_details/course_details_header/animated_shape.dart';
import 'package:slides_sync/features/manage_all/manage_collections/presentation/views/modify_collections/edit_collection_title_bottom_sheet.dart';
import 'package:slides_sync/features/manage_all/manage_collections/usecases/modify_collections_uc/modify_collection_actions.dart';
import 'package:slides_sync/core/routes/routes.dart';
import 'package:slides_sync/shared/components/dialogs/app_action_dialog.dart';
import 'package:slides_sync/shared/components/dialogs/confirm_deletion_dialog.dart';
import 'package:slides_sync/shared/helpers/extension_helper.dart';

class ModCollectionDialog extends ConsumerStatefulWidget {
  final int courseDbId;
  final CourseCollection collection;

  const ModCollectionDialog({super.key, required this.courseDbId, required this.collection});

  @override
  ConsumerState<ConsumerStatefulWidget> createState() => _ModCollectionDialogState();
}

class _ModCollectionDialogState extends ConsumerState<ModCollectionDialog> {
  late final TextEditingController textEditingController;
  late final FocusNode focusNode;
  late final RoundedPolygon shape;
  @override
  void initState() {
    super.initState();
    textEditingController = TextEditingController();
    textEditingController.text = widget.collection.collectionTitle;
    focusNode = FocusNode();
    shape = materialShapes[math.Random().nextInt(materialShapes.length)].shape;
  }

  @override
  void dispose() {
    textEditingController.dispose();
    focusNode.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final theme = ref.theme;
    final collection = widget.collection;
    final mca = ModifyCollectionActions();
    return AppActionDialog(
      blurSigma: Offset(4, 4),
      backgroundColor: theme.surface.withAlpha(200),

      leading: Padding(
        padding: const EdgeInsets.only(bottom: ConstantSizing.spaceLarge),
        child: Row(
          children: [
            // Padding(
            //   padding: const EdgeInsets.only(left: 4.0),
            //   child: Container(
            //     padding: EdgeInsets.all(16),
            //     alignment: Alignment.center,
            //     margin: EdgeInsets.only(left: 12),
            //     decoration: BoxDecoration(shape: BoxShape.circle, color: theme.primaryColor.withAlpha(40)),
            //     child: BuildImagePathWidget(
            //       fileDetails: FileDetails(),
            //       fallbackWidget: SizedBox.square(
            //         dimension: 30,
            //         child: ClipPath(
            //           clipper: MorphClipper(path: shape.toPath(), size: Size(20, 20)),
            //           child: ColoredBox(color: theme.primaryColor),
            //         ),
            //       )
            //     ),
            //   ),
            // ),
            ConstantSizing.rowSpacingMedium,

            Expanded(
              child: GestureDetector(
                onTap: () {
                  CustomDialog.hide(context);
                  UiUtils.showCustomDialog(context, child: EditCollectionTitleBottomSheet(collection: collection));
                },
                child: Padding(
                  padding: const EdgeInsets.only(top: 4),
                  child: CustomText(
                    collection.collectionTitle,
                    fontSize: 16,
                    fontWeight: FontWeight.bold,
                    color: theme.onBackground,
                  ),
                ),
              ),
            ),

            ConstantSizing.rowSpacingMedium,
          ],
        ),
      ),
      actions: [
        AppActionDialogModel(
          title: "Select",
          icon: Icon(Iconsax.tick_circle_copy, size: 24, color: theme.supportingText),
          onTap: () {},
        ),

        AppActionDialogModel(
          title: "View contents",
          icon: Icon(Iconsax.forward_copy, size: 24, color: theme.supportingText),
          onTap: () {
            CustomDialog.hide(context);
            AppRouteNavigator.to(context).modifyContentsRoute((
              collection: collection,
              courseDbId: widget.courseDbId,
              courseTitle: (courseCode: "", courseName: "CourseName"),
            ));
          },
        ),

        AppActionDialogModel(
          title: "Share",
          icon: Icon(Icons.share_outlined, size: 24, color: theme.supportingText),
          onTap: () {},
        ),
        AppActionDialogModel(
          title: "Delete",
          icon: Icon(Iconsax.box_remove_copy, size: 24, color: Colors.redAccent),
          onTap: () async {
            if (context.mounted) {
              CustomDialog.hide(context);
            } else {
              rootNavigatorKey.currentContext?.pop();
            }

            if (context.mounted) {
              CustomDialog.show(
                context,
                canPop: true,
                barrierColor: Colors.black.withValues(alpha: 0.6),
                transitionType: TransitionType.cupertinoDialog,
                transitionDuration: Durations.medium2,
                child: ConfirmDeletionDialog(
                  content:
                      "This will delete \"${collection.collectionTitle}\"."
                      "\n\nAre you sure you want to delete this course?",
                  onPop: () {
                    log("Popping");
                    if (context.mounted) {
                      CustomDialog.hide(context);
                    } else {
                      rootNavigatorKey.currentContext?.pop();
                    }
                  },
                  onCancel: () {
                    rootNavigatorKey.currentContext?.pop();
                  },
                  onDelete: () async {
                    await mca.onDeleteCollection(context, collection: collection);
                  },
                ),
              );
            }
          },
        ),
      ],
    ).animate().fadeIn().scaleXY(
      begin: 0.4,
      end: 1,
      alignment: Alignment.centerRight,
      duration: Durations.extralong1,
      curve: CustomCurves.defaultIosSpring,
    );
  }
}
