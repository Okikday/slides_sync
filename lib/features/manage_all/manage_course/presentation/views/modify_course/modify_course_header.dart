import 'package:custom_widgets_toolkit/custom_widgets_toolkit.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:heroine/heroine.dart';
import 'package:iconsax_flutter/iconsax_flutter.dart';
import 'package:slides_sync/domain/models/file_details.dart';
import 'package:slides_sync/shared/helpers/extension_helper.dart';
import 'package:slides_sync/shared/widgets/build_image_path_widget.dart';

class ModifyCourseHeader extends ConsumerWidget {
  final String title;
  final String courseCode;
  final String description;
  final String courseFileDetails;
  final String? heroineTag;

  final void Function() onClickAddDescription;
  final void Function() onClickEditCourse;
  final void Function() onClickDelete;
  final void Function() onClickImage;
  final void Function() onLongPressImage;

  const ModifyCourseHeader({
    super.key,
    required this.title,
    this.courseCode = "",
    this.heroineTag,
    required this.description,
    required this.courseFileDetails,
    required this.onClickAddDescription,
    required this.onClickEditCourse,
    required this.onClickDelete,
    required this.onClickImage,
    required this.onLongPressImage,
  });

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final theme = ref.theme;
    return SliverToBoxAdapter(
      child: Column(
        spacing: 24.0,
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  mainAxisAlignment: MainAxisAlignment.center,
                  mainAxisSize: MainAxisSize.min,
                  spacing: 8.0,
                  children: [
                    ConstantSizing.columnSpacingSmall,
                    if (courseCode.isNotEmpty)
                      Padding(
                        padding: const EdgeInsets.only(left: 12.0),
                        child: CustomTextButton(
                          backgroundColor: theme.primaryColor.withAlpha(60),
                          pixelHeight: 28,
                          contentPadding: EdgeInsets.symmetric(horizontal: 10.0),
                          child: CustomText(
                            courseCode,
                            fontSize: 12,
                            fontWeight: FontWeight.bold,
                            color: theme.primaryColor,
                          ),
                        ),
                      ),

                    Flexible(
                      child: Tooltip(
                        message: title,
                        triggerMode: TooltipTriggerMode.tap,
                        child: Padding(
                          padding: const EdgeInsets.symmetric(horizontal: 16.0),
                          child: CustomText(
                            title,
                            fontSize: 20,
                            fontWeight: FontWeight.bold,
                            color: theme.onBackground,
                          ),
                        ),
                      ),
                    ),
                    Flexible(
                      child: Padding(
                        padding: const EdgeInsets.only(left: 16.0),
                        child: ConstrainedBox(
                          constraints: BoxConstraints(maxHeight: 80),
                          child: SingleChildScrollView(
                            child: CustomTextButton(
                              borderRadius: 4.0,
                              contentPadding: EdgeInsets.symmetric(horizontal: 2, vertical: 2),
                              onClick: onClickAddDescription,
                              child: CustomText(
                                description.isEmpty ? "Add description" : description,
                                color: theme.supportingText.withValues(alpha: 0.9),
                              ),
                            ),
                          ),
                        ),
                      ),
                    ),
                  ],
                ),
              ),
              ConstantSizing.rowSpacingLarge,
              Heroine(
                tag: "PreviewModifyCourseImageDialog => $courseFileDetails",
                placeholderBuilder: (context, heroSize, child) => child,
                spring: Spring.snappy,
                child: Container(
                  width: 80,
                  height: 80,
                  clipBehavior: Clip.antiAlias,
                  decoration: BoxDecoration(
                    shape: BoxShape.circle,
                    boxShadow: [BoxShadow(color: theme.altBackgroundPrimary, spreadRadius: 2, blurRadius: 3)],
                  ),
                  child: GestureDetector(
                    onTap: onClickImage,
                    onLongPress: onLongPressImage,
                    child: ColoredBox(
                      color: theme.altBackgroundPrimary,
                      child: SizedBox.square(
                        dimension: 80,
                        child: BuildImagePathWidget(
                          fileDetails: courseFileDetails.fileDetails,
                          fallbackWidget: Icon(
                            Iconsax.document,
                            color: context.isDarkMode ? theme.primaryColor : theme.primaryColor,
                          ),
                        ),
                      ),
                    ),
                  ),
                ),
              ),
              ConstantSizing.rowSpacingMedium,
            ],
          ),

          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 16.0),
            child: Row(
              spacing: 12.0,
              children: [
                Expanded(
                  child: CustomElevatedButton(
                    onClick: onClickEditCourse,
                    buttonStyle: ElevatedButton.styleFrom(
                      fixedSize: Size(double.infinity, 48),
                      backgroundColor: theme.primaryColor.withAlpha(40),
                      elevation: 0,
                      shape: RoundedSuperellipseBorder(
                        side: BorderSide(color: theme.primaryColor.withAlpha(41), width: 1.5),
                        borderRadius: BorderRadius.circular(24),
                      ),
                    ),
                    child: Row(
                      spacing: 8.0,
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        CustomText("Edit course", color: theme.primaryColor),
                        Icon(Iconsax.edit_2, color: theme.supportingText),
                      ],
                    ),
                  ),
                ),
                CustomElevatedButton(
                  pixelHeight: 48,
                  onClick: onClickDelete,
                  contentPadding: EdgeInsets.all(16),
                  backgroundColor: Colors.red.withAlpha(50),
                  shape: CircleBorder(),
                  child: Icon(Iconsax.trash_copy, color: Colors.red),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
