import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:slides_sync/domain/models/course_model/course.dart';
import 'package:slides_sync/domain/repos/course_repo/course_repo.dart';

final defaultCourse = Course.create(courseTitle: "_");
final StateProvider<int?> _activeCourseDbIdProvider = StateProvider<int?>((ref) => null);
final AutoDisposeStreamProviderFamily<Course?, int> _syncCourseStreamProvider = AutoDisposeStreamProviderFamily<Course?, int>(
  (ref, arg) {
    // ref.onDispose(() => log("Disposed StreamProvider ${arg}"));
    // can improve by putting ref.keepAlive()
    return CourseRepo.watchCourseByDbId(arg);
  },
);
final AsyncNotifierProvider<CourseNotifier, Course> _courseProvider = AsyncNotifierProvider(CourseNotifier.new);

class CourseProviders {
  static AsyncNotifierProvider<CourseNotifier, Course> get courseProvider => _courseProvider;
}

class CourseNotifier extends AsyncNotifier<Course> {
  @override
  Future<Course> build() async {
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

  void updateCourse(Course value) async {
    ref.read(_activeCourseDbIdProvider.notifier).update((cb) => value.id);
  }

  void updateByDate(Course value) async {
    if (state.value?.lastUpdated != value.lastUpdated) {
      ref.read(_activeCourseDbIdProvider.notifier).update((cb) => value.id);
    }
  }
}
