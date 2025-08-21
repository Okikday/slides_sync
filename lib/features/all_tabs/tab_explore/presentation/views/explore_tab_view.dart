import 'dart:developer';

import 'package:custom_widgets_toolkit/custom_widgets_toolkit.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:slides_sync/core/utils/app_navigator.dart';
import 'package:slides_sync/domain/models/course_model/course.dart';
import 'package:slides_sync/shared/helpers/extension_helper.dart';
import 'package:slides_sync/shared/styles/colors.dart';
import 'package:slides_sync/test/file_manager_page.dart';

class ExploreTabView extends ConsumerStatefulWidget {
  const ExploreTabView({super.key});

  @override
  ConsumerState<ExploreTabView> createState() => _ExploreTabViewState();
}

class _ExploreTabViewState extends ConsumerState<ExploreTabView> {
  late final StateProviderFamily<bool, int> scaleClickProviderFamily;
  late final StateProvider<bool> isCourseClickedProvider;

  void onTap(Course course) async {
    final isCourseClickedNotifier = ref.read(isCourseClickedProvider.notifier);
    if (isCourseClickedNotifier.state) return;
    isCourseClickedNotifier.update((cb) => true);

    await Future.delayed(Durations.short4);
    if (mounted) AppNavigator.to(context).courseDetailsRoute(course);
    if (mounted) isCourseClickedNotifier.update((cb) => false);
  }

  @override
  Widget build(BuildContext context) {
    log("Explore tab view build");

    return Center(
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          CustomElevatedButton(
            backgroundColor: AppColors.lightenColor(context.theme.colorScheme.secondary, context.isDarkMode ? 0.5 : 0.5),
            onClick: () {
              AppNavigator.to(context).createCourseRoute();
            },
            child: CustomText('Offline Mode(Create Course)', color: AppColors.primaryText(context)),
          ),

         if(kDebugMode) Padding(
           padding: const EdgeInsets.all(8.0),
           child: CustomElevatedButton(
              backgroundColor: AppColors.lightenColor(context.theme.colorScheme.secondary, context.isDarkMode ? 0.5 : 0.5),
              onClick: () {
                Navigator.push(context, PageAnimation.pageRouteBuilder(FileManagerPage()));
              },
              child: CustomText('File Manager page', color: AppColors.primaryText(context)),
            ),
         ),
        ],
      ),
    );
  }
}
