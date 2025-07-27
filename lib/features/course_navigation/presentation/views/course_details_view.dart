import 'package:custom_widgets_toolkit/custom_widgets_toolkit.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:iconsax_flutter/iconsax_flutter.dart';
import 'package:slides_sync/core/utils/ui_utils.dart';
import 'package:slides_sync/data/models/course_model/course.dart';
import 'package:slides_sync/features/course_navigation/presentation/providers/course_provider.dart';
import 'package:slides_sync/features/course_navigation/presentation/views/course_details/course_details_collection_section.dart';
import 'package:slides_sync/features/course_navigation/presentation/views/course_details/course_details_header.dart';
import 'package:slides_sync/shared/helpers/extension_helper.dart';
import 'package:slides_sync/shared/styles/colors.dart';

class CourseDetailsView extends ConsumerStatefulWidget {
  final Course course;
  const CourseDetailsView({super.key, required this.course});

  @override
  ConsumerState<ConsumerStatefulWidget> createState() => _CourseDetailsViewState();
}

class _CourseDetailsViewState extends ConsumerState<CourseDetailsView> {
  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      final modifyCourseNotifier = ref.read(CourseProviders.courseProvider.notifier);
      if (modifyCourseNotifier.value.lastUpdated != widget.course.lastUpdated) {
        modifyCourseNotifier.update(widget.course);
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    final topGradColor = AppColors.bgBlendColor(context, .8, .2);
    final firstStop = 1 - ((kToolbarHeight * 2 + context.topPadding) / context.deviceHeight);

    return AnnotatedRegion(
      value: UiUtils.getSystemUiOverlayStyle(context.scaffoldBackgroundColor, context.isDarkMode, statusBarColor: Colors.transparent),
      child: Scaffold(
        extendBody: true,
        body: Container(
          decoration: BoxDecoration(
            gradient: LinearGradient(
              begin: Alignment.bottomCenter,
              end: Alignment.topCenter,
              stops: [double.parse(firstStop.toStringAsFixed(2)), 1],
              colors: [AppColors.backgroundColor(context), topGradColor],
            ),
          ),
          child: CourseDetailsOuterSection(),
        ),
      ),
    );
  }
}

class CourseDetailsOuterSection extends ConsumerWidget {
  const CourseDetailsOuterSection({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final Course course = ref.watch(CourseProviders.courseProvider);
    return Stack(
      clipBehavior: Clip.hardEdge,
      children: [
        CustomScrollView(
          slivers: [
            CourseDetailsHeader(course: course),

            CourseDetailsCollectionSection(course: course),

            SliverToBoxAdapter(child: ConstantSizing.columnSpacingMedium),
          ],
        ),

        Positioned(
          bottom: context.bottomPadding + 8,
          left: 10,
          child: Row(
            spacing: 12,
            children: [
              CustomElevatedButton(
                borderRadius: 16,
                contentPadding: EdgeInsets.symmetric(horizontal: 16, vertical: 12),
                backgroundColor: context.theme.colorScheme.onTertiary,
                child: CustomText("Continue Reading", fontSize: 13, color: context.theme.scaffoldBackgroundColor),
              ),

              CustomElevatedButton(
                pixelHeight: 48,
                pixelWidth: 48,
                borderRadius: 16,
                backgroundColor: context.theme.colorScheme.onSurface.withValues(alpha: 0.8),
                child: Icon(Iconsax.note, color: context.theme.colorScheme.onTertiary),
              ),
            ],
          ),
        ),
      ],
    );
  }
}
