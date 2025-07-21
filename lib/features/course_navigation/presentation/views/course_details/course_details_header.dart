import 'package:custom_widgets_toolkit/custom_widgets_toolkit.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:slides_sync/data/models/course_model/course.dart';
import 'package:slides_sync/features/course_navigation/presentation/views/course_details/course_details_header/course_details_header_top.dart';
import 'package:slides_sync/features/manage_all/manage_collections/presentation/views/modify_collections/collections_view_search_bar.dart';
import 'package:slides_sync/shared/components/component_widgets.dart';
import 'package:slides_sync/shared/helpers/extension_helper.dart';
import 'package:slides_sync/shared/styles/colors.dart';

class CourseDetailsHeader extends ConsumerWidget {
  final Course course;
  const CourseDetailsHeader({super.key, required this.course});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    return SliverToBoxAdapter(
      child: Column(
        children: [
          ConstantSizing.columnSpacing(context.topPadding + 4),

          CourseDetailsHeaderTop(course: course),

          ConstantSizing.columnSpacingMedium,

          CollectionsViewSearchBar(),
          
          ConstantSizing.columnSpacingMedium,
        ],
      ),
    );
  }
}
