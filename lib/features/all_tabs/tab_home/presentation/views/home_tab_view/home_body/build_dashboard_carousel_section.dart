import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:slides_sync/core/routes/app_route_navigator.dart';
import 'package:slides_sync/core/utils/ui_utils.dart';
import 'package:slides_sync/domain/models/progress_track_model.dart';
import 'package:slides_sync/domain/repos/course_repo/course_content_repo.dart';
import 'package:slides_sync/features/all_tabs/tab_home/presentation/providers/home_tab_view_providers.dart';
import 'package:slides_sync/features/all_tabs/tab_home/presentation/views/home_tab_view/home_body/home_dashboard.dart';
import 'package:slides_sync/shared/helpers/device_helper.dart';
import 'package:slides_sync/shared/helpers/extension_helper.dart';

class BuildDashboardCarouselSection extends ConsumerWidget {
  const BuildDashboardCarouselSection({super.key, this.carouselController});

  final CarouselController? carouselController;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final deviceWidth = context.deviceWidth;
    final bool isDesktop = context.deviceType == DeviceType.desktop;
    final recentsLast = ref.watch(HomeTabViewProviders.recentProgressTrackProvider).value?.first;

    return ConstrainedBox(
      constraints: BoxConstraints(maxHeight: 160),
      child: AnimatedSize(
        duration: Durations.medium4,
        child: CarouselView(
          controller: carouselController,
          padding: EdgeInsets.zero,
          backgroundColor: Colors.transparent,
          enableSplash: false,
          itemSnapping: true,
          shrinkExtent: isDesktop ? deviceWidth * 0.6 : deviceWidth * 0.94,
          itemExtent: isDesktop ? deviceWidth * 0.7 : deviceWidth * 0.94,
          shape: BeveledRectangleBorder(),
          children: [
            if (recentsLast != null)
              HomeDashboard(
                courseName: recentsLast.title ?? "Unknown material",
                detail: 'Unavailable',
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
              ),
          ],
        ),
      ),
    );
  }
}
