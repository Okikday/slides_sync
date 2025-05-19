import 'dart:ui';

import 'package:custom_widgets_toolkit/custom_widgets_toolkit.dart';
import 'package:flutter/material.dart';
import 'package:flutter_animate/flutter_animate.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:hive/hive.dart';
import 'package:iconsax_flutter/iconsax_flutter.dart';
import 'package:slides_sync/core/utils/app_ui_state.dart';
import 'package:slides_sync/features/course_mgmt/data/models/course_model/course_model.dart';
import 'package:slides_sync/features/course_navigation/presentation/views/course_navigation/collection_card_tile.dart';
import 'package:slides_sync/shared/styles/app_ui_context.dart';
import 'package:slides_sync/test/dummy_slides.dart';

import '../../../../core/utils/ui_utils.dart';
import '../../../../shared/components/app_bar_container.dart';
import '../../../../shared/components/app_bar_container_child.dart';
import 'course_navigation/path_indicator_header.dart';

class CourseNavigationView extends ConsumerStatefulWidget {
  final CourseModel courseModel;

  const CourseNavigationView({super.key, required this.courseModel});

  @override
  ConsumerState createState() => _CourseNavigationViewState();
}

class _CourseNavigationViewState extends ConsumerState<CourseNavigationView> {
  @override
  Widget build(BuildContext context) {
    
    

    return AnnotatedRegion(
      value: UiUtils.getSystemUiOverlayStyle(context.scaffoldBackgroundColor, context.isDarkMode),
      child: Scaffold(
        appBar: AppBarContainer(
          appBarHeight: kToolbarHeight + 12,
          padding: EdgeInsets.zero,
          child: AppBarContainerChild(context.isDarkMode, title: 'CSC 213'),
        ),

        body: CustomScrollView(
          slivers: [
            PinnedHeaderSliver(child: ColoredBox(color: context.scaffoldBackgroundColor, child: ConstantSizing.columnSpacingMedium)),

            PinnedHeaderSliver(
              child: ColoredBox(
                color: context.scaffoldBackgroundColor.withValues(alpha: 0.4),
                child: PathIndicatorHeader(isDarkMode: context.isDarkMode, paths: ["Collections"]),
              ),
            ),

            SliverToBoxAdapter(child: ConstantSizing.columnSpacingLarge),

            // _buildExample(),
            // _buildExample(),
            // _buildExample(),
            // _buildExample(),
            SliverList.builder(
              itemCount: DummySlides.dummySlides.length,
              itemBuilder: (context, index) {
                return CollectionCardTile(
                      context.isDarkMode,
                      title: DummySlides.dummySlides[index]['title'] as String? ?? "Unknown",
                      contentCount: 12,
                    )
                    .animate()
                    .slideY(
                      begin: 0.5 * (index / DummySlides.dummySlides.length + 1),
                      duration: Durations.extralong4,
                      curve: CustomCurves.bouncySpring,
                )
                    .fadeIn();
              },
            ),
            SliverToBoxAdapter(child: ConstantSizing.columnSpacingMedium),
            // ConstantSizing.columnSpacingMedium,
            // Padding(
            //   padding: const EdgeInsets.symmetric(horizontal: 12.0),
            //   child: _buildCollectionListTile(appUiModel, collectionTitle: "This is a collection", iconData: Iconsax.document),
            // ),
            // ConstantSizing.columnSpacingMedium,
            // Padding(
            //   padding: const EdgeInsets.symmetric(horizontal: 12.0),
            //   child: _buildCollectionListTile(appUiModel, collectionTitle: "This is a collection", iconData: Iconsax.document),
            // ),
          ],
        ),
      ),
    );
  }
}
