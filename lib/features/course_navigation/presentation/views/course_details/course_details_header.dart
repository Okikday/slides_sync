import 'package:custom_widgets_toolkit/custom_widgets_toolkit.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:slides_sync/data/models/course_model/course_model.dart';
import 'package:slides_sync/features/course_navigation/presentation/views/course_details/course_details_header/course_details_header_top.dart';
import 'package:slides_sync/shared/helpers/extension_helper.dart';

class CourseDetailsHeader extends ConsumerWidget {
  final CourseModel courseModel;
  const CourseDetailsHeader({super.key, required this.courseModel});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    return SliverToBoxAdapter(
      child: Column(
        children: [
          ConstantSizing.columnSpacingMedium,

          CourseDetailsHeaderTop(courseModel: courseModel),

          ConstantSizing.columnSpacingLarge,

          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 16),
            child: Row(
              spacing: 8.0,
              children: [
                Expanded(
                  child: CustomElevatedButton(
                    label: "Reading history",
                    // textColor: context.isDarkMode ? Colors.white : Colors.black,
                    textColor: context.theme.colorScheme.outline,
                    textSize: 14,
                    borderRadius: 24,
                    pixelHeight: 48,
                    backgroundColor: context.theme.primaryColor.withAlpha(80),
                    onClick: () async {
                      await showModalBottomSheet(
                        context: context,
                        enableDrag: true,
                        showDragHandle: true,
                        builder: (context) {
                          return DraggableScrollableSheet(
                            builder: (context, scrollController) {
                              return Container();
                            },
                          );
                        },
                      );
                    },
                  ),
                ),

                CustomElevatedButton(
                  shape: CircleBorder(),
                  pixelHeight: 48,
                  pixelWidth: 48,
                  backgroundColor: context.theme.colorScheme.secondary.withAlpha(80),
                  child: Icon(Icons.share_outlined, size: 20, color: context.theme.colorScheme.onSecondary),
                ),
              ],
            ),
          ),

          ConstantSizing.columnSpacingLarge,
        ],
      ),
    );
  }
}
