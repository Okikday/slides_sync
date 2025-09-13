import 'dart:async';
import 'dart:developer';

import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:infinite_scroll_pagination/infinite_scroll_pagination.dart';
import 'package:isar/isar.dart';
import 'package:slides_sync/core/storage/isar_data/isar_data.dart';
import 'package:slides_sync/domain/models/course_model/course.dart';
import 'package:slides_sync/domain/models/progress_track_model.dart';
import 'package:slides_sync/domain/repos/course_repo/course_collection_repo.dart';
import 'package:slides_sync/domain/repos/course_repo/course_content_repo.dart';
import 'package:slides_sync/features/all_tabs/tab_library/presentation/providers/custom_notifiers/is_list_view_notifier.dart';

final AutoDisposeStreamProviderFamily<List<ContentWithProgress>, String> watchContentsFamily =
    AutoDisposeStreamProviderFamily((ref, collectionId) {
      final controller = StreamController<List<ContentWithProgress>>();

      StreamSubscription<List<CourseContent>>? contentsSub;
      StreamSubscription<List<ProgressTrackModel>>? progressSub;

      List<CourseContent> latestContents = [];
      Map<String, ProgressTrackModel> latestProgressMap = {};

      // Helper to emit combined list
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

          final contentsStream = (await CourseContentRepo.filter)
              .parentIdEqualTo(collectionId)
              .sortByLastModifiedDesc()
              .watch(fireImmediately: true);

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
  final String collectionId;
  CourseMaterialsProviders(this.collectionId);
  static CourseMaterialsProviders of(String collectionId) => CourseMaterialsProviders(collectionId);

  static final AutoDisposeAsyncNotifierProvider<IsListViewNotifier, bool> isListLayout =
      AutoDisposeAsyncNotifierProvider<IsListViewNotifier, bool>(
        () => IsListViewNotifier("course_material/isListView"),
      );

  late final AutoDisposeStreamProvider<List<ContentWithProgress>> watchContents = watchContentsFamily(collectionId);

  static final PagingState<int, CourseContent> pagingState = PagingState();
  static final StateProvider<double> scrollOffsetProvider = StateProvider((cb) => 0.0);
}

class ContentWithProgress {
  final CourseContent content;
  final ProgressTrackModel? progress; // may be null if no progress yet

  ContentWithProgress({required this.content, this.progress});
}
