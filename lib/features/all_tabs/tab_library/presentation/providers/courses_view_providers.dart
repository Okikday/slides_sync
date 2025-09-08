import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:infinite_scroll_pagination/infinite_scroll_pagination.dart';
import 'package:slides_sync/domain/models/course_model/course.dart';
import 'package:slides_sync/domain/repos/course_repo/course_repo.dart';

const int limit = 10;

class CoursesViewProviders {
  static final AutoDisposeStreamProvider<void> watchChanges = AutoDisposeStreamProvider<void>((ref) async* {
    final stream = await CourseRepo.isarData.watchForChanges(fireImmediately: false);
    yield* stream; // forward the inner Stream<void> events
  });

  static final PagingState<int, Course> pagingState = PagingState();
}
