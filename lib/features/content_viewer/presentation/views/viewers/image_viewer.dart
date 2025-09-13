import 'dart:io';

import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:slides_sync/core/storage/isar_data/isar_data.dart';
import 'package:slides_sync/core/utils/result.dart';
import 'package:slides_sync/core/utils/ui_utils.dart';
import 'package:slides_sync/domain/models/course_model/sub/course_content.dart';
import 'package:photo_view/photo_view.dart';
import 'package:slides_sync/domain/models/file_details.dart';
import 'package:slides_sync/domain/models/progress_track_model.dart';
import 'package:slides_sync/shared/components/app_bar_container.dart';
import 'package:slides_sync/shared/helpers/extension_helper.dart';

class ImageViewer extends ConsumerStatefulWidget {
  final CourseContent content;
  const ImageViewer({super.key, required this.content});

  @override
  ConsumerState<ImageViewer> createState() => _ImageViewerState();
}

class _ImageViewerState extends ConsumerState<ImageViewer> {
  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) async {
      if (context.mounted) {
        await Future.delayed(Duration(seconds: 15), () {
          _createProgressTrackModel(widget.content);
        });
      }
    });
  }

  static Future<ProgressTrackModel?> _createProgressTrackModel(CourseContent content) async {
    final isarData = IsarData.instance<ProgressTrackModel>();
    final result = await Result.tryRunAsync(() async {
      final ProgressTrackModel newPtm = ProgressTrackModel.create(
        contentId: content.contentId,
        title: content.title,
        description: content.description.substring(0, content.description.length.clamp(0, 1024)),
        contentHash: content.contentHash,
        progress: 0.0,
      );
      return (await isarData.getById(await isarData.store(newPtm)));
    });
    return result.data;
  }

  @override
  void dispose() {
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final theme = ref.theme;
    return AnnotatedRegion(
      value: UiUtils.getSystemUiOverlayStyle(theme.background, theme.isDarkTheme),
      child: Scaffold(
        appBar: AppBarContainer(
          padding: EdgeInsets.zero,
          child: AppBarContainerChild(theme.isDarkTheme, title: widget.content.title),
        ),
        body: PhotoView(
          imageProvider: FileImage(File(widget.content.path.filePath)),
          minScale: PhotoViewComputedScale.contained,
          maxScale: PhotoViewComputedScale.covered,
        ),
      ),
    );
  }
}
