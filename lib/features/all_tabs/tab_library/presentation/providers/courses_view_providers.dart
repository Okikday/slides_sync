import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:infinite_scroll_pagination/infinite_scroll_pagination.dart';
import 'package:slides_sync/domain/models/course_model/course.dart';
import 'package:slides_sync/domain/repos/course_repo/course_repo.dart';
import 'package:slides_sync/features/all_tabs/tab_library/presentation/actions/courses_view_actions.dart';

const int limit = 10;

class CoursesViewProviders {
  static final AutoDisposeStateProvider<CourseSortOption> coursesFilterOptions = AutoDisposeStateProvider(
    (ref) => CourseSortOption.none,
  );
  static final AutoDisposeStreamProvider<void> watchChanges = AutoDisposeStreamProvider<void>((ref) async* {
    final stream = await CourseRepo.isarData.watchForChanges(fireImmediately: false);
    yield* stream;
  });

  static final PagingState<int, Course> pagingState = PagingState();
}
