import 'package:custom_widgets_toolkit/custom_widgets_toolkit.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:slides_sync/core/utils/ui_utils.dart';
import 'package:slides_sync/features/course_mgmt/data/models/course_model/course_model.dart';
import 'package:slides_sync/features/course_navigation/presentation/views/course_details/course_details_collection_section.dart';
import 'package:slides_sync/features/course_navigation/presentation/views/course_details/course_details_header.dart';
import 'package:slides_sync/shared/components/app_bar_container.dart';
import 'package:slides_sync/shared/components/app_bar_container_child.dart';
import 'package:slides_sync/shared/styles/app_ui_context.dart';

class CourseDetailsView extends ConsumerWidget {
  final CourseModel courseModel;
  const CourseDetailsView({super.key, required this.courseModel});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    return AnnotatedRegion(
      value: UiUtils.getSystemUiOverlayStyle(context.scaffoldBackgroundColor, context.isDarkMode),
      child: Scaffold(
        extendBody: true,
        appBar: AppBarContainer(
          appBarHeight: kToolbarHeight + 12,
          padding: EdgeInsets.zero,
          child: AppBarContainerChild(context.isDarkMode, title: "Course Info"),
        ),
        body: CustomScrollView(
          slivers: [
            CourseDetailsHeader(courseModel: courseModel),

            if (courseModel.subCollections.isNotEmpty)
              PinnedHeaderSliver(
                child: ColoredBox(
                  color: context.scaffoldBackgroundColor.withValues(alpha: 0.8),
                  child: Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
                    child: CustomText("Collections", fontSize: 16, fontWeight: FontWeight.bold),
                  ),
                ),
              ),

            SliverToBoxAdapter(child: ConstantSizing.columnSpacingSmall),

            CourseDetailsCollectionSection(collections: courseModel.subCollections),
          ],
        ),
      ),
    );
  }
}
