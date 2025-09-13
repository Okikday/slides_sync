import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:slides_sync/domain/models/progress_track_model.dart';
import 'package:slides_sync/features/all_tabs/tab_home/presentation/providers/home_dashboard_providers.dart';
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
            HomeDashboard(
              courseName: 'Foundation of Sequential Programming',
              detail: 'CSC 213',
              progressValue: 0.45,
              completed: false,
              isFirst: true,
            ),
          ],
        ),
      ),
    );
  }
}
