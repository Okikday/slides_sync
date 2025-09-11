import 'package:isar/isar.dart';
import 'package:slides_sync/core/storage/isar_data/isar_data.dart';
import 'package:slides_sync/core/utils/result.dart';
import 'package:slides_sync/domain/models/course_model/sub/course_content.dart';
import 'package:slides_sync/domain/models/progress_track_model.dart';

class PdfDocumentViewerActions {
  static final Future<Isar> _isar = IsarData.isarFuture;
  static final IsarData<ProgressTrackModel> _isarData = IsarData.instance();
  static Future<ProgressTrackModel?> getLastProgressTrack(CourseContent content) async {
    final ptm = (await (await _isar).progressTrackModels.where().contentIdEqualTo(content.contentId).findFirst());
    if (ptm == null) {
      final result = await _createProgressTrackModel(content);
      if (result == null) return null; // A critical error occured!
      return result;
    }
    return ptm;
  }

  static Future<ProgressTrackModel?> _createProgressTrackModel(CourseContent content) async {
    final result = await Result.tryRunAsync(() async {
      final ProgressTrackModel newPtm = ProgressTrackModel.create(
        contentId: content.contentId,
        contentHash: content.contentHash,
        progress: 0.0,
      );
      return (await _isarData.getById(await _isarData.store(newPtm)));
    });
    return result.data;
  }

  static Future<ProgressTrackModel> updateProgressTrack(ProgressTrackModel ptm) async => await _isarData.getById(await _isarData.store(ptm)) ?? ptm;
}
