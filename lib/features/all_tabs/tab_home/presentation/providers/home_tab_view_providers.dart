import 'dart:async';
import 'dart:developer';

import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:isar/isar.dart';
import 'package:slides_sync/core/storage/hive_data/app_hive_data.dart';
import 'package:slides_sync/core/storage/hive_data/hive_data_paths.dart';
import 'package:slides_sync/core/storage/isar_data/isar_data.dart';
import 'package:slides_sync/domain/models/progress_track_model.dart';

class HomeTabViewProviders {
  static final recentProgressTrackProvider =
      StreamProvider<List<ProgressTrackModel>>((ref) async* {
    final controller = StreamController<List<ProgressTrackModel>>.broadcast();
    StreamSubscription? hiveSub;
    StreamSubscription<List<ProgressTrackModel>>? isarSub;

    List<String> lastTen(List<String> s) =>
        s.length > 10 ? s.sublist(s.length - 10) : s;

    Future<void> switchIsar(List<String> ids) async {
      try {
        await isarSub?.cancel();
        final isar = await IsarData.isarFuture;

        final Stream<List<ProgressTrackModel>> stream = isar.progressTrackModels
                .filter()
                .anyOf(ids, (q, id) => q.contentIdEqualTo(id))
                .sortByLastReadDesc()
                .limit(10)
                .watch(fireImmediately: true)
                .map((list) {
                  final m = {for (var p in list) p.contentId: p};
                  final ordered = ids
                      .map((id) => m[id])
                      .whereType<ProgressTrackModel>()
                      .toList();
                  return ordered.length > 10 ? ordered.sublist(0, 10).reversed.toList() : ordered.reversed.toList();
            });

        isarSub = stream.listen(
          (data) {
            controller.add(data);
          },
          onError: (e, st) {
            log('Isar stream error: $e\n$st');
            controller.addError(e, st);
          },
        );
      } catch (e, st) {
        log('switchIsar failed: $e\n$st');
        controller.addError(e, st);
      }
    }

    try {
      final hive = AppHiveData.instance;
      final initial = (await hive.getData(key: HiveDataPaths.recentContentsIds))
              as List<String>? ??
          <String>[];
      
      await switchIsar(lastTen(initial));

      hiveSub = hive.watchChanges(key: HiveDataPaths.recentContentsIds).listen(
        (_) async {
          final updated = (await hive.getData(key: HiveDataPaths.recentContentsIds))
                  as List<String>? ??
              <String>[];
          await switchIsar(lastTen(updated));
        },
        onError: (e, st) {
          log('Hive watch error: $e\n$st');
          controller.addError(e, st);
        },
      );
    } catch (e, st) {
      log('Provider init failed: $e\n$st');
      controller.addError(e, st);
    }

    ref.onDispose(() async {
      log("Disposed recents provider");
      await hiveSub?.cancel();
      await isarSub?.cancel();
      await controller.close();
    });

    yield* controller.stream;
  });
}