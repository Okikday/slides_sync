
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:slides_sync/domain/models/course_model/course.dart';
import 'package:slides_sync/domain/repos/course_repo/course_repo.dart';

final defaultCourse = Course.create(courseTitle: "_");
final StateProvider<int?> _activeCourseDbIdProvider = StateProvider<int?>((ref) => null);
final AutoDisposeStreamProviderFamily<Course?, int> _syncCourseStreamProvider = AutoDisposeStreamProviderFamily<Course?, int>(
  (ref, arg) => CourseRepo.watchCourseByDbId(arg),
);
final NotifierProvider<ModifyCourseNotifier, Course> _modifyCourseProvider = NotifierProvider(ModifyCourseNotifier.new);

class ModifyCourseProviders {
  static NotifierProvider<ModifyCourseNotifier, Course> get modifyCourseProvider => _modifyCourseProvider;
}

class ModifyCourseNotifier extends Notifier<Course> {
  @override
  Course build() {
    final int? courseId = ref.watch(_activeCourseDbIdProvider);
    if (courseId == null) {
      return defaultCourse;
    } else {
      final asyncCourse = ref.watch(_syncCourseStreamProvider(courseId));

      return asyncCourse.when(
        data: (data) => data ?? defaultCourse,
        error: (e, st) => defaultCourse,
        loading: () => defaultCourse,
      );
    }
  }

  Course get value => state;
  void update(Course value) {
    if (state == value) return;
    ref.read(_activeCourseDbIdProvider.notifier).state = value.id;
  }
}
