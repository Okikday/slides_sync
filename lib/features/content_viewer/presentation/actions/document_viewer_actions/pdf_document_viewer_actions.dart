import 'dart:async';
import 'dart:convert';
import 'dart:developer';

import 'package:flutter/widgets.dart';
import 'package:isar/isar.dart';
import 'package:pdfrx/pdfrx.dart';
import 'package:slides_sync/core/storage/hive_data/app_hive_data.dart';
import 'package:slides_sync/core/storage/hive_data/hive_data_paths.dart';
import 'package:slides_sync/core/storage/isar_data/isar_data.dart';
import 'package:slides_sync/core/utils/result.dart';
import 'package:slides_sync/domain/models/course_model/sub/course_content.dart';
import 'package:slides_sync/domain/models/file_details.dart';
import 'package:slides_sync/domain/models/progress_track_model.dart';
import 'package:slides_sync/features/manage_all/manage_contents/usecases/create_contents_uc/create_content_preview_image.dart';
import 'package:slides_sync/shared/helpers/extension_helper.dart';

class PdfDocumentViewerActions {
  final CourseContent content;
  final PdfViewerController pdfViewerController;
  late final Timer? progressTrackTimer;
  int trackCount = 0;
  bool isUpdatingProgressTrack = false;
  static const _trackInterval = Duration(seconds: 10);
  PdfDocumentViewerActions._(
    this.content,
    this.pdfViewerController,
    ValueNotifier<ProgressTrackModel?> progressTrackNotifier,
  ) {
    progressTrackTimer = Timer.periodic(_trackInterval, (timer) => pageNumberTracker(timer, progressTrackNotifier));
  }
  static PdfDocumentViewerActions of(
    CourseContent content, {
    required PdfViewerController pdfViewerController,
    required ValueNotifier<ProgressTrackModel?> progressTrackNotifier,
  }) => PdfDocumentViewerActions._(content, pdfViewerController, progressTrackNotifier);

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
        title: content.title,
        description: content.description.substring(0, content.description.length.clamp(0, 1024)),
        contentHash: content.contentHash,
        progress: 0.0,
      );
      return (await _isarData.getById(await _isarData.store(newPtm)));
    });
    return result.data;
  }

  static Future<ProgressTrackModel> _updateProgressTrack(ProgressTrackModel ptm) async =>
      await _isarData.getById(await _isarData.store(ptm)) ?? ptm;

  void pageNumberTracker(Timer? timer, ValueNotifier<ProgressTrackModel?> progressTrackNotifier) async {
    log("This shows up every ${_trackInterval.inSeconds} seconds");

    if (isUpdatingProgressTrack) return;
    final progressTrack = progressTrackNotifier.value;
    if (progressTrack == null) return;
    final pageNumber = pdfViewerController.pageNumber;
    if (progressTrack.lastPosition == pageNumber) return;
    if (pageNumber == null) return;
    isUpdatingProgressTrack = true;
    final oldPages = progressTrack.pages.toSet();
    log("data: ${(content.metadataJson.decodeJson)['previewPath']}");
    if (oldPages.contains(pageNumber.toString())) {
      await PdfDocumentViewerActions._updateProgressTrack(
        trackCount > 0
            ? progressTrack.copyWith(lastPosition: pageNumber, lastRead: DateTime.now())
            : progressTrack.copyWith(
              title: content.title,
              description: content.description,
              lastPosition: pageNumber,
              lastRead: DateTime.now(),
              metadataJson: jsonEncode({
                ...progressTrack.metadataJson.decodeJson,
                'previewPath':
                    CreateContentPreviewImage.genPreviewImagePathRecord(filePath: content.path.filePath).previewPath,
              }),
            ),
      ).then(((onValue) => isUpdatingProgressTrack = false), onError: (onValue) => isUpdatingProgressTrack = false);
    } else {
      final progress = ((oldPages.length + 1) / pdfViewerController.pageCount).clamp(0.0, 1.0);
      final newPages = {...progressTrack.pages.toSet(), pageNumber.toString()}.toList();
      await PdfDocumentViewerActions._updateProgressTrack(
        trackCount > 0
            ? progressTrack.copyWith(
              lastPosition: pageNumber,
              pages: newPages,
              progress: progress,
              lastRead: DateTime.now(),
            )
            : progressTrack.copyWith(
              title: content.title,
              description: content.description,
              lastPosition: pageNumber,
              pages: newPages,
              progress: progress,
              lastRead: DateTime.now(),
              metadataJson: jsonEncode({
                ...progressTrack.metadataJson.decodeJson,
                'previewPath':
                    CreateContentPreviewImage.genPreviewImagePathRecord(filePath: content.path.filePath).previewPath,
              }),
            ),
      ).then(((onValue) => isUpdatingProgressTrack = false), onError: (onValue) => isUpdatingProgressTrack = false);
    }

    trackCount++;
  }

  void dispose() {
    progressTrackTimer?.cancel();
    Future.microtask(() => Result.tryRunAsync(() async => await _addToRecentContents(content.contentId)));
  }
}

Future<void> _addToRecentContents(String contentId) async {
  final hiveInstance = AppHiveData.instance;
  final rawOldRecents = (await hiveInstance.getData(key: HiveDataPaths.recentContentsIds)) as List<String>?;
  if (rawOldRecents == null) {
    await hiveInstance.setData(key: HiveDataPaths.recentContentsIds, value: [contentId]);
  } else {
    List<String> recents = List.from(rawOldRecents);
    if (recents.contains(contentId)) {
      recents.remove(contentId);
    }
    recents.add(contentId);
    await hiveInstance.setData(key: HiveDataPaths.recentContentsIds, value: recents);
  }
  log("Adding pdf to recents");
  return;
}
