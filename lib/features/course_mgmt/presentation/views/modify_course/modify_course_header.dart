import 'package:custom_widgets_toolkit/custom_widgets_toolkit.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:iconsax_flutter/iconsax_flutter.dart';
import 'package:slides_sync/shared/helpers/widget_helper.dart';

class ModifyCourseHeader extends ConsumerWidget {
  
  final String title;
  final String description;
  final String? courseImagePath;

  final void Function() onClickAddDescription;
  final void Function() onClickEditCourse;
  final void Function() onClickFilter;

  const ModifyCourseHeader(
    {
    super.key,
    required this.title,
    required this.description,
    this.courseImagePath,
    required this.onClickAddDescription,
    required this.onClickEditCourse,
    required this.onClickFilter,
  });

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    return SliverPadding(
      padding: EdgeInsets.symmetric(horizontal: 16.0),
      sliver: SliverToBoxAdapter(
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
                      ConstantSizing.columnSpacingMedium,
                      Flexible(child: CustomText(title, fontSize: 22, fontWeight: FontWeight.bold)),
                      Flexible(
                        child: ConstrainedBox(
                          constraints: BoxConstraints(maxHeight: 80),
                          child: SingleChildScrollView(
                            child: CustomTextButton(
                              borderRadius: 4.0,
                              contentPadding: EdgeInsets.symmetric(horizontal: 2, vertical: 2),
                              onClick: onClickAddDescription,
                              child: CustomText(description.isEmpty ? "Add description" : description, color: Colors.deepPurple),
                            ),
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
                ConstantSizing.rowSpacingLarge,
                CircleAvatar(
                  radius: 42,
                  backgroundColor: Colors.deepPurple,
                  child: ClipOval(child: SizedBox.square(dimension: 80, child: WidgetHelper.resolveImageWidget(courseImagePath)))),
              ],
            ),

            Row(
              spacing: 12.0,
              children: [
                Expanded(
                  child: CustomElevatedButton(
                    label: "Edit course",
                    onClick: onClickEditCourse,
                    textColor: Colors.lightBlueAccent,
                    textSize: 14,
                    backgroundColor: Colors.lightBlueAccent.withAlpha(50),
                    pixelHeight: 48,
                    borderRadius: 48,
                  ),
                ),
                CustomElevatedButton(
                  pixelHeight: 48,
                  onClick: onClickFilter,
                  contentPadding: EdgeInsets.all(16),
                  backgroundColor: Colors.lightBlueAccent.withAlpha(50),
                  shape: CircleBorder(),
                  child: Icon(Iconsax.filter, color: Colors.lightBlueAccent),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}
