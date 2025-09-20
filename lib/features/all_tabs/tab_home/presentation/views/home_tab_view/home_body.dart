import 'package:custom_widgets_toolkit/custom_widgets_toolkit.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:slides_sync/core/routes/app_route_navigator.dart';
import 'package:slides_sync/core/utils/ui_utils.dart';
import 'package:slides_sync/domain/repos/course_repo/course_content_repo.dart';
import 'package:slides_sync/features/all_tabs/tab_home/presentation/providers/home_tab_view_providers.dart';
import 'package:slides_sync/features/all_tabs/tab_home/presentation/views/home_tab_view/home_body/home_dashboard.dart';
import 'package:slides_sync/features/all_tabs/tab_home/presentation/views/home_tab_view/home_body/more_section.dart';
import 'package:slides_sync/features/all_tabs/tab_home/presentation/views/home_tab_view/home_body/recents_section/recents_section_body.dart';
import 'package:slides_sync/features/all_tabs/tab_home/presentation/views/home_tab_view/home_body/recents_section/recents_section_header.dart';
import 'package:slides_sync/shared/helpers/extension_helper.dart';

class HomeBody extends ConsumerWidget {
  const HomeBody({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final asyncRecentsLast = ref.watch(HomeTabViewProviders.recentProgressTrackProvider);
    return CustomScrollView(
      physics: const BouncingScrollPhysics(),
      // physics: const BouncingScrollPhysics(),
      // controller: scrollController,
      slivers: [
        SliverToBoxAdapter(child: ConstantSizing.columnSpacingMedium),

        SliverToBoxAdapter(
          child: asyncRecentsLast.when(
            data: (data) {
              final recentsLast = data.isNotEmpty ? data.first : null;
              if (recentsLast != null) {
                return HomeDashboard(
                  courseName: recentsLast.title ?? "Unknown material",
                  detail: '',
                  progressValue: recentsLast.progress ?? 0.0,
                  completed: recentsLast.progress == 1.0,
                  isFirst: true,
                  onReadingBtnTapped: () async {
                    final content = await CourseContentRepo.getByContentId(recentsLast.contentId);
                    if (content == null) {
                      if (context.mounted) {
                        UiUtils.showFlushBar(context, msg: "Unable to open material");
                      }
                      return;
                    }
                    if (context.mounted) AppRouteNavigator.to(context).contentViewGateRoute(content);
                  },
                );
              }
              return HomeDashboard(
                courseName: "Add a course material",
                detail: '',
                progressValue: 0.0,
                isFirst: true,
                onReadingBtnTapped: () async {
                  AppRouteNavigator.to(context).createCourseRoute();
                },
              );
            },
            loading: () {
              return const SizedBox();
            },
            error: (e, st) {
              return const Center(child: Icon(Icons.error));
            },
          ),
        ),

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
                Scaffold(body: Center(child: CustomText("No recent reads", color: ref.theme.onBackground))),
                type: TransitionType.rightToLeft,
                duration: Durations.extralong1,
                curve: CustomCurves.defaultIosSpring,
              ),
            );
          },
        ),

        SliverToBoxAdapter(child: ConstantSizing.columnSpacingSmall),

        // Recents Section Body
        RecentsSectionBody(),
      ],
    );
  }
}
