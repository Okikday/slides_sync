import 'package:custom_widgets_toolkit/custom_widgets_toolkit.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:heroine/heroine.dart';
import 'package:iconsax_flutter/iconsax_flutter.dart';
import 'package:slides_sync/core/models/file_details.dart';
import 'package:slides_sync/shared/helpers/extension_helper.dart';
import 'package:slides_sync/shared/styles/colors.dart';
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
                          backgroundColor: context.theme.primaryColor.withAlpha(60),
                          pixelHeight: 28,
                          contentPadding: EdgeInsets.symmetric(horizontal: 10.0),
                          child: CustomText(courseCode, fontSize: 12, fontWeight: FontWeight.bold, color: context.theme.primaryColor),
                        ),
                      ),

                    Flexible(
                      child: Padding(
                        padding: const EdgeInsets.symmetric(horizontal: 16.0),
                        child: CustomText(title, fontSize: 22, fontWeight: FontWeight.bold, color: context.theme.colorScheme.tertiary,),
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
                              child: CustomText(description.isEmpty ? "Add description" : description, color: context.theme.primaryColor),
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
                  decoration: BoxDecoration(shape: BoxShape.circle, boxShadow: [
                    BoxShadow(color: Colors.white12, offset: Offset(1, 1), blurRadius: 3, spreadRadius: 2),
                    BoxShadow(color: Colors.black12, offset: Offset(-1, -1), blurRadius: 3, spreadRadius: 2),
                    BoxShadow(color: AppColors.lightenColor(context.theme.primaryColor.withValues(alpha: 0.2), 0.6), spreadRadius: 2, blurRadius: 3)
                  ]),
                  child: GestureDetector(
                    onTap: onClickImage,
                    onLongPress: onLongPressImage,
                    child: ColoredBox(
                      color: context.theme.primaryColor.withAlpha(60),
                      child: SizedBox.square(
                        dimension: 80,
                        child: BuildImagePathWidget(
                          fileDetails: courseFileDetails.fileDetails,
                          fallbackWidget: Icon(Iconsax.document, color: context.isDarkMode ? context.theme.primaryColor : context.theme.primaryColor),
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
                    label: "Edit course",
                    onClick: onClickEditCourse,
                    textColor: context.theme.colorScheme.primary,
                    textSize: 14,
                    backgroundColor: context.theme.primaryColor.withAlpha(60),
                    pixelHeight: 48,
                    borderRadius: 48,
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
