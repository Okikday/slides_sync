import 'dart:developer';

import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:infinite_scroll_pagination/infinite_scroll_pagination.dart';
import 'package:isar/isar.dart';
import 'package:slides_sync/domain/models/course_model/course.dart';
import 'package:slides_sync/domain/repos/course_repo/course_collection_repo.dart';
import 'package:slides_sync/domain/repos/course_repo/course_content_repo.dart';
import 'package:slides_sync/features/all_tabs/tab_library/presentation/providers/custom_notifiers/is_list_view_notifier.dart';

final AutoDisposeStreamProviderFamily<List<CourseContent>, String> watchForChangesFamily =
    AutoDisposeStreamProviderFamily((ref, collectionId) async* {
      yield* ((await CourseContentRepo.filter).parentIdEqualTo(collectionId).watch(fireImmediately: true));
    });
getsome() {
  
}
class CourseMaterialsProviders {
  final String collectionId;
  CourseMaterialsProviders(this.collectionId);
  static CourseMaterialsProviders of(String collectionId) => CourseMaterialsProviders(collectionId);

  static final AutoDisposeAsyncNotifierProvider<IsListViewNotifier, bool> isListLayout =
      AutoDisposeAsyncNotifierProvider<IsListViewNotifier, bool>(
        () => IsListViewNotifier("course_material/isListView"),
      );

  late final AutoDisposeStreamProvider<List<CourseContent>> watchChanges = watchForChangesFamily(collectionId);

  static final PagingState<int, CourseContent> pagingState = PagingState();
  static final StateProvider<double> scrollOffsetProvider = StateProvider((cb) => 0.0);
}
