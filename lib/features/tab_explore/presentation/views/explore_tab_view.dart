import 'dart:developer';

import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:slides_sync/core/utils/app_navigator.dart';
import 'package:slides_sync/data/models/course_model/course_model.dart';

class ExploreTabView extends ConsumerStatefulWidget {
  const ExploreTabView({super.key});

  @override
  ConsumerState<ExploreTabView> createState() => _ExploreTabViewState();
}

class _ExploreTabViewState extends ConsumerState<ExploreTabView> {
  late final StateProviderFamily<bool, int> scaleClickProviderFamily;
  late final StateProvider<bool> isCourseClickedProvider;

  void onTap(CourseModel course) async {
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

    return Center();
  }
}
