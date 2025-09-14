import 'package:isar/isar.dart';
import 'package:slides_sync/core/storage/isar_data/isar_data.dart';
import 'package:slides_sync/domain/models/progress_track_model.dart';

class ProgressTrackRepo {
  static final IsarData<ProgressTrackModel> _isarData = IsarData.instance<ProgressTrackModel>();
  static Future<Isar> get _isar async => await IsarData.isarFuture;
  static Future<Isar> get isar async => await _isar;
  static IsarData<ProgressTrackModel> get isarData => _isarData;

  static Future<QueryBuilder<ProgressTrackModel, ProgressTrackModel, QFilterCondition>> get filter async =>
      (await _isar).progressTrackModels.filter();

  static Future<QueryBuilder<ProgressTrackModel, ProgressTrackModel, QAfterFilterCondition>> _queryByContentId(
    String contentId,
  ) async {
    return (await _isarData.query<ProgressTrackModel>((q) => q.idGreaterThan(0))).filter().contentIdEqualTo(contentId);
  }

  static Future<ProgressTrackModel?> getByContentId(String contentId) async {
    return await (await _isar).progressTrackModels.filter().contentIdEqualTo(contentId).findFirst();
  }

  static Future<void> deleteByDbId(int dbId) async => await _isarData.deleteById(dbId);

  static Future<ProgressTrackModel?> deleteByContentId(String contentId) async {
    final isar = await _isar;
    final ProgressTrackModel? course = await getByContentId(contentId);
    return await isar.writeTxn<ProgressTrackModel?>(() async {
      if (course != null) {
        final idQuery = await _queryByContentId(contentId);
        await idQuery.deleteFirst();
      }
      return course;
    });
  }
}
