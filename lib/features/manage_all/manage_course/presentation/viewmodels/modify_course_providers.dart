import 'dart:developer';

import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:slides_sync/data/models/course_model/course_model.dart';
import 'package:slides_sync/data/repos/course_repo.dart';

final defaultCourseModel = CourseModel.create(courseTitle: "_");
final StateProvider<int?> _activeCourseDbIdProvider = StateProvider<int?>((ref) => null);
final AutoDisposeStreamProviderFamily<CourseModel?, int> _syncCourseStreamProvider = AutoDisposeStreamProviderFamily<CourseModel?, int>(
  (ref, arg) => CourseRepo.watchCourseByDbId(arg),
);
final NotifierProvider<ModifyCourseNotifier, CourseModel> _modifyCourseProvider = NotifierProvider(ModifyCourseNotifier.new);

class ModifyCourseProviders {
  static NotifierProvider<ModifyCourseNotifier, CourseModel> get modifyCourseProvider => _modifyCourseProvider;
}

class ModifyCourseNotifier extends Notifier<CourseModel> {
  @override
  CourseModel build() {
    final int? courseId = ref.watch(_activeCourseDbIdProvider);
    if (courseId == null) {
      return defaultCourseModel;
    } else {
      final asyncCourse = ref.watch(_syncCourseStreamProvider(courseId));

      return asyncCourse.when(
        data: (data) => data ?? defaultCourseModel,
        error: (e, st) => defaultCourseModel,
        loading: () => defaultCourseModel,
      );
    }
  }

  CourseModel get value => state;
  void update(CourseModel value) {
    if (state == value) return;
    ref.read(_activeCourseDbIdProvider.notifier).state = value.id;
  }
}
