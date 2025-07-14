import 'package:custom_widgets_toolkit/custom_widgets_toolkit.dart';
import 'package:flutter/material.dart';
import 'package:flutter_animate/flutter_animate.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:iconsax_flutter/iconsax_flutter.dart';
import 'package:slides_sync/core/models/file_details.dart';
import 'package:slides_sync/core/utils/app_navigator.dart';
import 'package:slides_sync/data/models/course_model/course_model.dart';
import 'package:slides_sync/data/models/course_model/sub/course_sub_collection.dart';
import 'package:slides_sync/features/manage_all/manage_collections/usecases/modify_collections_uc/modify_collection_actions.dart';
import 'package:slides_sync/routes/routes.dart';
import 'package:slides_sync/shared/components/dialogs/app_action_dialog.dart';
import 'package:slides_sync/shared/components/dialogs/app_customizable_dialog.dart';
import 'package:slides_sync/shared/components/dialogs/confirm_deletion_dialog.dart';
import 'package:slides_sync/shared/helpers/extension_helper.dart';
import 'package:slides_sync/shared/widgets/build_image_path_widget.dart';

class ModCollectionDialog extends ConsumerStatefulWidget {
  final int courseDbId;
  final CourseSubCollection collection;

  const ModCollectionDialog({super.key, required this.courseDbId, required this.collection});

  @override
  ConsumerState<ConsumerStatefulWidget> createState() => _ModCollectionDialogState();
}

class _ModCollectionDialogState extends ConsumerState<ModCollectionDialog> {
  late final TextEditingController textEditingController;
  late final FocusNode focusNode;
  @override
  void initState() {
    super.initState();
    textEditingController = TextEditingController();
    textEditingController.text = widget.collection.collectionTitle;
    focusNode = FocusNode();
  }

  @override
  void dispose() {
    textEditingController.dispose();
    focusNode.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    var divider = Divider(color: context.theme.colorScheme.secondary.withAlpha(40), height: 0);
    final collection = widget.collection;
    final mca = ModifyCollectionActions();
    return AppCustomizableDialog(
      blurSigma: Offset(4, 4),
      backgroundColor: context.scaffoldBackgroundColor.withValues(alpha: 0.5),
      onPop: () async {
        final newText = textEditingController.text;
        await mca.onRenameCollection(context, newText: newText, courseDbId: widget.courseDbId, collection: collection);
      },
      child: SingleChildScrollView(
        physics: BouncingScrollPhysics(),
        child: Column(
          children: [
            Row(
              children: [
                Padding(
                  padding: const EdgeInsets.only(left: 4.0),
                  child: Container(
                    padding: EdgeInsets.all(16),
                    alignment: Alignment.center,
                    margin: EdgeInsets.only(left: 12),
                    decoration: BoxDecoration(shape: BoxShape.circle, color: context.theme.colorScheme.outlineVariant),
                    child: BuildImagePathWidget(fileDetails: FileDetails()),
                  ),
                ),
                ConstantSizing.rowSpacingMedium,

                Expanded(
                  child: Padding(
                    padding: const EdgeInsets.only(top: 4,),
                    child: CustomText(
                      collection.collectionTitle,
                      fontSize: 14.5,
                      fontWeight: FontWeight.bold,
                      color: context.theme.colorScheme.tertiary,
                    ),
                  ),
                ),
                
                ConstantSizing.rowSpacingMedium,
              ],
            ),

            // Expanded(
            //   child: CustomTextfield(
            //     hint: "New collection name",
            //     // onSubmitted: (text) async {
            //     //   final String? result = await mca.renameCollectionAction(
            //     //     newText: text,
            //     //     courseDbId: widget.courseDbId,
            //     //     collectionId: collection.collectionId,
            //     //   );
            //     //   if (result == null && context.mounted) focusNode.unfocus();
            //     // },
            //     inputContentPadding: EdgeInsets.symmetric(horizontal: 12.0),
            //     defaultText: widget.collection.collectionTitle,
            //     controller: textEditingController,
            //     focusNode: focusNode,
            //     autoDispose: false,
            //     inputTextStyle: TextStyle(color: Colors.white),
            //     backgroundColor: context.theme.colorScheme.onSecondary,
            //     cursorColor: context.theme.primaryColor,

            //   ),
            // ),
            ConstantSizing.columnSpacingMedium,

            Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                divider,

                BuildPlainActionButton(
                  contentPadding: EdgeInsets.symmetric(horizontal: 16, vertical: 12),
                  title: "Select",
                  icon: Icon(Iconsax.tick_circle_copy, size: 24, color: context.theme.colorScheme.onTertiary),
                  textStyle: TextStyle(fontSize: 16, color: context.theme.colorScheme.tertiary),
                  onTap: () {},
                ),

                divider,

                BuildPlainActionButton(
                  contentPadding: EdgeInsets.symmetric(horizontal: 16, vertical: 12),
                  title: "View contents",
                  icon: Icon(Iconsax.forward_copy, size: 24, color: context.theme.colorScheme.onTertiary),
                  textStyle: TextStyle(fontSize: 16, color: context.theme.colorScheme.tertiary),
                  onTap: () {
                    CustomDialog.hide(context);
                    AppNavigator.to(context).modifyContentsRoute((
                      collection: collection,
                      courseDbId: widget.courseDbId,
                      courseTitle: (courseCode: "", courseName: "CourseName"),
                    ));
                  },
                ),

                divider,

                BuildPlainActionButton(
                  contentPadding: EdgeInsets.symmetric(horizontal: 16, vertical: 12),
                  title: "Share",
                  icon: Icon(Icons.share_outlined, size: 24, color: context.theme.colorScheme.onTertiary),
                  textStyle: TextStyle(fontSize: 16, color: context.theme.colorScheme.tertiary),
                  onTap: () {},
                ),

                divider,

                BuildPlainActionButton(
                  contentPadding: EdgeInsets.symmetric(horizontal: 16, vertical: 12),
                  title: "Delete",
                  icon: Icon(Iconsax.box_remove_copy, size: 24, color: Colors.redAccent),
                  textStyle: TextStyle(fontSize: 16, color: context.theme.colorScheme.tertiary),
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
                            await mca.onDeleteCollection(context, courseDbId: widget.courseDbId, collection: collection);
                          },
                        ),
                      );
                    }
                  },
                ),
                divider,
              ],
            ),
          ],
        ),
      ),
    ).animate().fadeIn().scaleXY(
      begin: 0.4,
      end: 1,
      alignment: Alignment.topRight,
      duration: Durations.extralong1,
      curve: CustomCurves.defaultIosSpring,
    );
  }
}
