import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:slides_sync/data/models/course_model/course_model.dart';
import 'package:slides_sync/data/repos/course_repo.dart';

class ModifyCourseProviders {
  static final StateProvider<CourseModel> _modifyCourseProvider = StateProvider((ref) => CourseModel.create(courseTitle: "Default Course"));
  static StateProvider<CourseModel> get modifyCourseProvider => _modifyCourseProvider;

  static StreamProvider<CourseModel?> _syncCourseProvider = StreamProvider(
    (ref) => CourseRepo.watchCourseByDbId(ref.read(_modifyCourseProvider.notifier).state.id),
  );
  static StreamProvider<CourseModel?> get syncCourseProvider => _syncCourseProvider;
  static void setSyncCourseProvider(StreamProvider<CourseModel?> newSyncVaue) => _syncCourseProvider = newSyncVaue;
}
