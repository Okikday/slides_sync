import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:slides_sync/features/course_mgmt/data/models/course_model/course_model.dart';
import 'package:slides_sync/features/course_mgmt/data/repos/course_repo.dart';

class GetCoursesAsyncNotifier extends AsyncNotifier<List<CourseModel>> {
  @override
  Future<List<CourseModel>> build() async => await CourseRepo.getAllCourses();
}

class WatchAllCoursesStreamNotifier extends StreamNotifier<List<CourseModel>> {
  @override
  Stream<List<CourseModel>> build() async* {
    yield* await CourseRepo.watchAllCoursesLazily();
  }
}
