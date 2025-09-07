import 'package:custom_widgets_toolkit/custom_widgets_toolkit.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:slides_sync/domain/models/file_details.dart';
import 'package:slides_sync/domain/models/course_model/sub/course_content.dart';
import 'package:slides_sync/features/all_tabs/tab_home/presentation/views/home_tab_view/home_body/more_section.dart';
import 'package:slides_sync/features/all_tabs/tab_home/presentation/views/home_tab_view/home_body/recents_section/recents_section_body.dart';
import 'package:slides_sync/features/all_tabs/tab_home/presentation/views/home_tab_view/home_body/recents_section/recents_section_header.dart';
import 'package:slides_sync/features/all_tabs/tab_home/presentation/views/home_tab_view/home_body/build_dashboard_carousel_section.dart';
import 'package:slides_sync/shared/helpers/extension_helper.dart';

class HomeBody extends ConsumerWidget {
  final ScrollController? scrollController;
  final CarouselController? carouselController;
  const HomeBody({super.key, this.scrollController, this.carouselController});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    return CustomScrollView(
      physics: const BouncingScrollPhysics(),
      // physics: const BouncingScrollPhysics(),
      controller: scrollController,
      slivers: [
        SliverToBoxAdapter(child: ConstantSizing.columnSpacingMedium),

        // DASHBOARD SECTION
        if (carouselController != null)
          SliverToBoxAdapter(
            child: ScrollbarTheme(
              data: ScrollbarThemeData(crossAxisMargin: -80, mainAxisMargin: 20),
              child: Scrollbar(
                controller: carouselController,
                scrollbarOrientation: ScrollbarOrientation.bottom,
                thumbVisibility: true,
                interactive: true,
                child: BuildDashboardCarouselSection(carouselController: carouselController),
              ),
            ),
          )
        else
          SliverToBoxAdapter(child: BuildDashboardCarouselSection()),

        SliverToBoxAdapter(child: ConstantSizing.columnSpacingLarge),
        SliverToBoxAdapter(child: MoreSection()),

        SliverToBoxAdapter(child: ConstantSizing.columnSpacingLarge),

        // Recents Section Header
        // Won't show up if the recent courses is empty
        RecentsSectionHeader(
          onClickSeeAll: () {
            Navigator.push(
              context,
              PageAnimation.pageRouteBuilder(
                Scaffold(
                  body: Center(
                    child: CustomText(
                      "No recent reads",
                      color: ref.theme.onBackground,
                    ),
                  ),
                ),
                type: TransitionType.rightToLeft,
                duration: Durations.extralong1,
                curve: CustomCurves.defaultIosSpring,
              ),
            );
          },
        ),

        // SliverToBoxAdapter(child: ConstantSizing.columnSpacingSmall),

        // Recents Section Body
        RecentsSectionBody(
          recentCourses: [
            CourseContent.create(
              contentHash: "Hello",
              parentId: 'lol',
              title: "Context Free Grammar",
              path: FileDetails(),
              courseContentType: CourseContentType.image,
            ),
          ],
        ),
      ],
    );
  }
}

