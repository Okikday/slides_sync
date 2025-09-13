import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:isar/isar.dart';
import 'package:slides_sync/core/storage/isar_data/isar_data.dart';
import 'package:slides_sync/domain/models/progress_track_model.dart';

class HomeDashboardProviders {
  static final StreamProvider<List<ProgressTrackModel>> recentProgressTrackProvider = StreamProvider((cb) async* {
    yield* (await IsarData.isarFuture).progressTrackModels.where().sortByLastRead().limit(10).watch(fireImmediately: true);
  });
}
