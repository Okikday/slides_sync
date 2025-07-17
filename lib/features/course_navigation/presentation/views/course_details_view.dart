import 'package:custom_widgets_toolkit/custom_widgets_toolkit.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:slides_sync/core/utils/ui_utils.dart';
import 'package:slides_sync/data/models/course_model/course_model.dart';
import 'package:slides_sync/data/repos/course_repo.dart';
import 'package:slides_sync/features/course_navigation/presentation/providers/course_provider.dart';
import 'package:slides_sync/features/course_navigation/presentation/views/course_details/course_details_collection_section.dart';
import 'package:slides_sync/features/course_navigation/presentation/views/course_details/course_details_header.dart';
import 'package:slides_sync/shared/components/app_bar_container.dart';
import 'package:slides_sync/shared/helpers/extension_helper.dart';

class CourseDetailsView extends ConsumerStatefulWidget {
  final CourseModel courseModel;
  const CourseDetailsView({super.key, required this.courseModel});

  @override
  ConsumerState<ConsumerStatefulWidget> createState() => _CourseDetailsViewState();
}

class _CourseDetailsViewState extends ConsumerState<CourseDetailsView> {

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      final modifyCourseNotifier = ref.read(CourseProviders.courseProvider.notifier);
      if (modifyCourseNotifier.value != widget.courseModel) {
        modifyCourseNotifier.update(widget.courseModel);
      }
    });
  }


  @override
  Widget build(BuildContext context) {
    

    return AnnotatedRegion(
      value: UiUtils.getSystemUiOverlayStyle(context.scaffoldBackgroundColor, context.isDarkMode),
      child: Scaffold(
        extendBody: true,
        appBar: AppBarContainer(
          appBarHeight: kToolbarHeight + 12,
          padding: EdgeInsets.zero,
          child: AppBarContainerChild(context.isDarkMode, title: "Course Info"),
        ),
        body: CourseDetailsOuterSection(),
      ),
    );
  }
}

class CourseDetailsOuterSection extends ConsumerWidget {
  const CourseDetailsOuterSection({
    super.key,
  });


  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final CourseModel courseModel = ref.watch(CourseProviders.courseProvider);
    return CustomScrollView(
      slivers: [
        CourseDetailsHeader(courseModel: courseModel),
    
        if (courseModel.subCollections.isNotEmpty)
          PinnedHeaderSliver(
            child: ColoredBox(
              color: context.scaffoldBackgroundColor.withValues(alpha: 0.8),
              child: Padding(
                padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
                child: CustomText("Collections", fontSize: 16, fontWeight: FontWeight.bold, color: context.theme.colorScheme.tertiary),
              ),
            ),
          ),
    
        SliverToBoxAdapter(child: ConstantSizing.columnSpacingSmall),
    
        CourseDetailsCollectionSection(courseModel: courseModel),
    
        SliverToBoxAdapter(child: ConstantSizing.columnSpacingMedium),
      ],
    );
  }
}
