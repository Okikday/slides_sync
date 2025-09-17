import 'dart:async';
import 'dart:collection';
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

const Duration readValidityDuration = Duration(seconds: 10);

class PdfDocumentViewerActions {
  final CourseContent content;
  final PdfViewerController pdfViewerController;
  final ValueNotifier<ProgressTrackModel?> progressTrackNotifier = ValueNotifier(null);
  final Stopwatch pageStayStopWatch = Stopwatch();
  bool isUpdatingProgressTrack = false;
  int? currentPageNumber;
  int? lastUpdatedPage;
  PdfDocumentViewerActions._(this.content, this.pdfViewerController) {
    _initLastProgress();
  }

  static PdfDocumentViewerActions of(CourseContent content, {required PdfViewerController pdfViewerController}) =>
      PdfDocumentViewerActions._(content, pdfViewerController);

  static final Future<Isar> _isar = IsarData.isarFuture;
  static final IsarData<ProgressTrackModel> _isarData = IsarData.instance();

  void _initLastProgress() async {
    await Future.microtask(() async {
      if (progressTrackNotifier.value != null) return;
      final ProgressTrackModel? progressTrack = await getLastProgressTrack(content);
      if (progressTrack != null) {
        progressTrackNotifier.value = progressTrack;
        pdfViewerController.addListener(monitorPageListener);
        WidgetsBinding.instance.addPostFrameCallback(
          (_) => Result.tryRun(() => pdfViewerController.goToPage(pageNumber: progressTrack.lastPosition)),
        );
      }
    });
  }

  /// Gets the progress of the current document from last session
  static Future<ProgressTrackModel?> getLastProgressTrack(CourseContent content) async {
    final ptm = (await (await _isar).progressTrackModels.where().contentIdEqualTo(content.contentId).findFirst());
    if (ptm == null) {
      final result = await _createProgressTrackModel(content);
      if (result == null) return null; // A critical error occured!
      return result;
    } else {
      final updatedPtm = await _updateProgressTrack(ptm.copyWith(lastRead: DateTime.now()));
      return updatedPtm;
    }
  }

  /// Creates a new progress track model if it didn't exist
  static Future<ProgressTrackModel?> _createProgressTrackModel(CourseContent content) async {
    final result = await Result.tryRunAsync(() async {
      final ProgressTrackModel newPtm = ProgressTrackModel.create(
        contentId: content.contentId,
        title: content.title,
        description: content.description.substring(0, content.description.length.clamp(0, 1024)),
        contentHash: content.contentHash,
        progress: 0.0,
        metadataJson: jsonEncode({
          'previewPath':
              CreateContentPreviewImage.genPreviewImagePathRecord(filePath: content.path.filePath).previewPath,
        }),
      );
      return (await _isarData.getById(await _isarData.store(newPtm)));
    });
    return result.data;
  }

  /// Update progress track
  static Future<ProgressTrackModel> _updateProgressTrack(ProgressTrackModel ptm) async =>
      await _isarData.getById(await _isarData.store(ptm)) ?? ptm;

  void monitorPageListener() async {
    if (isUpdatingProgressTrack) return;
    final monitorResult = await Result.tryRunAsync(() async {
      if (!_isPdfCtrllerSettled()) return;
      final pageNumber = pdfViewerController.pageNumber;
      final currPageNumber = currentPageNumber;
      if (currPageNumber == null) {
        pageStayStopWatch.stop();
        currentPageNumber = pageNumber;
        pageStayStopWatch.reset();
        pageStayStopWatch.start();
        log("This page doesn't count!");
        return;
      } else {
        if (pageNumber == currPageNumber) {
          if (pageStayStopWatch.elapsed.inSeconds < readValidityDuration.inSeconds) {
            log("Page under-read!");
            return;
          } else {
            if (lastUpdatedPage != null && lastUpdatedPage == currPageNumber) return;
            log("Adding page to progress tracker!");
            pageStayStopWatch.stop();
            pageStayStopWatch.reset();
            isUpdatingProgressTrack = true;
            final progressTrack = progressTrackNotifier.value;
            if (progressTrack == null) {
              isUpdatingProgressTrack = false;
              pageStayStopWatch.start();
              return;
            }

            final newPages = LinkedHashSet<String>.from(progressTrack.pages);
            newPages.add(currPageNumber.toString());
            final totalPageCount = pdfViewerController.pageCount;
            await _updateProgressTrack(
              progressTrack.copyWith(
                pages: newPages.toList(),
                progress: newPages.length / totalPageCount,
                lastRead: DateTime.now(),
              ),
            );
            lastUpdatedPage = currPageNumber;
            isUpdatingProgressTrack = false;
            pageStayStopWatch.start();
            return;
          }
        } else {
          pageStayStopWatch.stop();
          pageStayStopWatch.reset();
          currentPageNumber = pageNumber;
          pageStayStopWatch.start();
          log("Just got to the page, nothing to update!");
          return;
        }
      }
    });
    monitorResult.onError((e, [st]) {
      isUpdatingProgressTrack = false;
      lastUpdatedPage = null;
      pageStayStopWatch.reset();
      pageStayStopWatch.start();
    });
  }

  bool _isPdfCtrllerSettled() {
    if (!pdfViewerController.isReady) return false;
    if (pdfViewerController.pageNumber == null) return false;
    return true;
  }

  void dispose() {
    pdfViewerController.removeListener(monitorPageListener);

    progressTrackNotifier.dispose();
    pageStayStopWatch
      ..reset()
      ..stop();
    Future.microtask(() => Result.tryRunAsync(() async => await _addToRecentContents(content.contentId)));
    log("Disposed pdf viewer actions ");
  }
}

Future<void> _addToRecentContents(String contentId) async {
  final hiveInstance = AppHiveData.instance;
  final rawOldRecents = (await hiveInstance.getData(key: HiveDataPaths.recentContentsIds)) as List<String>?;
  if (rawOldRecents == null) {
    await hiveInstance.setData(key: HiveDataPaths.recentContentsIds, value: [contentId]);
  } else {
    final recents = LinkedHashSet<String>.from(rawOldRecents);
    recents.add(contentId);
    await hiveInstance.setData(key: HiveDataPaths.recentContentsIds, value: recents.toList());
  }
  log("Adding pdf to recents");
  return;
}
