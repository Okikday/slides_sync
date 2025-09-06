import 'package:infinite_scroll_pagination/infinite_scroll_pagination.dart';
import 'package:isar/isar.dart';
import 'package:slides_sync/domain/models/course_model/course.dart';
import 'package:slides_sync/domain/repos/course_repo/course_repo.dart';

class CoursesViewActions {
  static Future<List<Course>> fetchPage(int pageKey, int limit) async {
    final list = await (await CourseRepo.filter).idGreaterThan((pageKey - 1) * limit).limit(limit).findAll();
    // log("pageKey: $pageKey");
    // log("Got: ${list}");
    return list;
  }

  static int? getNextPageKey(PagingState<int, Course> state) {
    // log("${state.nextIntPageKey}");
    return state.lastPageIsEmpty ? null : state.nextIntPageKey;
  }
}
