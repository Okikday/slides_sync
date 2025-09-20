import 'dart:async';
import 'dart:developer';

import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:infinite_scroll_pagination/infinite_scroll_pagination.dart';
import 'package:isar/isar.dart';
import 'package:slides_sync/core/storage/hive_data/hive_data_paths.dart';
import 'package:slides_sync/core/storage/isar_data/isar_data.dart';
import 'package:slides_sync/domain/models/course_model/course.dart';
import 'package:slides_sync/domain/models/file_details.dart';
import 'package:slides_sync/domain/models/progress_track_model.dart';
import 'package:slides_sync/domain/repos/course_repo/course_content_repo.dart';
import 'package:slides_sync/features/all_tabs/tab_library/presentation/actions/courses_view_actions.dart';
import 'package:slides_sync/features/all_tabs/tab_library/presentation/providers/custom_notifiers/is_list_view_notifier.dart';

final defaultContent = CourseContent.create(
  contentHash: '_',
  parentId: '_',
  title: '_',
  path: const FileDetails(),
  courseContentType: CourseContentType.unknown,
);

Future<QueryBuilder<CourseContent, CourseContent, QAfterSortBy>> _resolveQueryBuilder(
  String collectionId,
  CourseSortOption sortOption,
) async {
  final base = (await CourseContentRepo.filter).parentIdEqualTo(collectionId);

  switch (sortOption) {
    case CourseSortOption.nameAsc:
      return base.sortByTitle();
    case CourseSortOption.nameDesc:
      return base.sortByTitleDesc();
    case CourseSortOption.dateCreatedAsc:
      return base.sortByCreatedAt();
    case CourseSortOption.dateCreatedDesc:
      return base.sortByCreatedAtDesc();
    case CourseSortOption.dateModifiedAsc:
      return base.sortByLastModified();
    case CourseSortOption.dateModifiedDesc:
      return base.sortByLastModifiedDesc();
    case CourseSortOption.none:
      return base.sortByLastModifiedDesc();
  }
}

final _contentsFilterOptionsFamily = AutoDisposeStateProvider.family<CourseSortOption, String>(
  (ref, collectionId) => CourseSortOption.none,
);

final AutoDisposeStreamProviderFamily<List<ContentWithProgress>, String> _watchContentsFamily =
    AutoDisposeStreamProviderFamily((ref, collectionId) {
      final sortOption = ref.watch(_contentsFilterOptionsFamily(collectionId));
      final controller = StreamController<List<ContentWithProgress>>();

      StreamSubscription<List<CourseContent>>? contentsSub;
      StreamSubscription<List<ProgressTrackModel>>? progressSub;

      List<CourseContent> latestContents = [];
      Map<String, ProgressTrackModel> latestProgressMap = {};

      void emitCombined() {
        if (controller.isClosed) return;
        final combined =
            latestContents
                .map((c) => ContentWithProgress(content: c, progress: latestProgressMap[c.contentId]))
                .toList();
        controller.add(combined);
      }

      () async {
        try {
          final isar = await IsarData.isarFuture;
          final query = await _resolveQueryBuilder(collectionId, sortOption);
          final contentsStream = query.watch(fireImmediately: true);

          contentsSub = contentsStream.listen(
            (contents) {
              latestContents = contents;
              final ids = contents.map((c) => c.contentId).toList();

              progressSub?.cancel();
              progressSub = null;

              if (ids.isEmpty) {
                latestProgressMap = {};
                emitCombined();
                return;
              }

              progressSub = isar.progressTrackModels
                  .filter()
                  .anyOf(ids, (q, id) => q.contentIdEqualTo(id))
                  .watch(fireImmediately: true)
                  .listen(
                    (progressList) {
                      final m = <String, ProgressTrackModel>{for (final p in progressList) p.contentId: p};
                      latestProgressMap = m;
                      emitCombined();
                    },
                    onError: (e, st) {
                      if (!controller.isClosed) controller.addError(e, st);
                    },
                  );
            },
            onError: (e, st) {
              if (!controller.isClosed) controller.addError(e, st);
            },
          );
        } catch (e, st) {
          if (!controller.isClosed) controller.addError(e, st);
        }
      }();

      // Cleanup on provider dispose
      ref.onDispose(() {
        contentsSub?.cancel();
        progressSub?.cancel();
        controller.close();
      });

      return controller.stream;
    });

class CourseMaterialsProviders {
  /// 0 for Grid, 1 for List, 2 for otherwise
  static final AutoDisposeAsyncNotifierProvider<CardViewTypeNotifier, int> cardViewType =
      AutoDisposeAsyncNotifierProvider<CardViewTypeNotifier, int>(
        () => CardViewTypeNotifier(HiveDataPaths.courseMaterialscardViewType, 2),
      );

  static AutoDisposeStateProvider<CourseSortOption> contentsFilterOption(String collectionId) =>
      _contentsFilterOptionsFamily(collectionId);

  static AutoDisposeStreamProvider<List<ContentWithProgress>> watchContents(String collectionId) =>
      _watchContentsFamily(collectionId);

  static final PagingState<int, CourseContent> pagingState = PagingState();
  static final AutoDisposeStateProvider<double> scrollOffsetProvider = AutoDisposeStateProvider((cb) => 0.0);
}

class ContentWithProgress {
  final CourseContent content;
  final ProgressTrackModel? progress; // may be null if no progress yet

  ContentWithProgress({required this.content, this.progress});
}
