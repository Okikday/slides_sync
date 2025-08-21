
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:iconsax_flutter/iconsax_flutter.dart';
import 'package:slides_sync/domain/models/file_details.dart';

import 'dart:io';
import 'dart:typed_data';

import 'package:cached_network_image/cached_network_image.dart';
import 'package:lottie/lottie.dart';
import 'package:slides_sync/core/utils/file_utils.dart';
import 'package:slides_sync/shared/assets/strings/icon_strings.dart';

class BuildImagePathWidget extends ConsumerStatefulWidget {
  final FileDetails fileDetails;
  final Widget fallbackWidget;
  final BoxFit fit;
  final double? width;
  final double? height;
  const BuildImagePathWidget({
    super.key,
    required this.fileDetails,
    this.fallbackWidget = const Icon(Iconsax.document),
    this.fit = BoxFit.cover,
    this.width,
    this.height,
  });

  @override
  ConsumerState<ConsumerStatefulWidget> createState() => _BuildImagePathWidgetState();
}

class _BuildImagePathWidgetState extends ConsumerState<BuildImagePathWidget> {
  Uint8List? imageBytes;
  DateTime? _lastModified;

  @override
  void initState() {
    super.initState();
    _loadImageBytes();
  }

  @override
  void didUpdateWidget(covariant BuildImagePathWidget oldWidget) {
    super.didUpdateWidget(oldWidget);

    final oldPath = oldWidget.fileDetails.filePath;
    final newPath = widget.fileDetails.filePath;

    if (newPath.isNotEmpty) {
      final file = File(newPath);
      if (file.existsSync()) {
        final newModified = file.lastModifiedSync();
        if (oldPath != newPath || _lastModified == null || newModified != _lastModified) {
          _loadImageBytes();
        }
      }
    }
  }

  void _loadImageBytes() {
    final filePath = widget.fileDetails.filePath;
    if (filePath.isNotEmpty && File(filePath).existsSync()) {
      final file = File(filePath);
      final bytes = file.readAsBytesSync();
      final modified = file.lastModifiedSync();

      if (_lastModified != modified) {
        setState(() {
          imageBytes = bytes;
          _lastModified = modified;
        });
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    final fileDetails = widget.fileDetails;
    final fallbackWidget = widget.fallbackWidget;
    final fit = widget.fit;
    final width = widget.width;
    final height = widget.height;

    if (!fileDetails.containsFilePath) return fallbackWidget;

    if (fileDetails.filePath.isNotEmpty && imageBytes != null) {
      return ImageFromMemory(imageBytes: imageBytes, fit: fit, width: width, height: height, fallbackWidget: fallbackWidget);
    } else if (fileDetails.urlPath.isNotEmpty) {
      return ImageFromNetwork(fileDetails: fileDetails, fit: fit, width: width, height: height, fallbackWidget: fallbackWidget);
    }

    return fallbackWidget;
  }
}

class ImageFromNetwork extends StatelessWidget {
  const ImageFromNetwork({
    super.key,
    required this.fileDetails,
    required this.fit,
    required this.width,
    required this.height,
    required this.fallbackWidget,
  });

  final FileDetails fileDetails;
  final BoxFit fit;
  final double? width;
  final double? height;
  final Widget fallbackWidget;

  @override
  Widget build(BuildContext context) {
    return CachedNetworkImage(
      imageUrl: fileDetails.urlPath,
      fit: fit,
      width: width,
      height: height,
      progressIndicatorBuilder: (context, url, progress) {
        return Lottie.asset(IconStrings.instance.loadingSpinner);
      },
      errorWidget: (context, error, stackTrace) => fallbackWidget,
    );
  }
}

class ImageFromMemory extends StatelessWidget {
  const ImageFromMemory({
    super.key,
    required this.imageBytes,
    required this.fit,
    required this.width,
    required this.height,
    required this.fallbackWidget,
  });

  final Uint8List? imageBytes;
  final BoxFit fit;
  final double? width;
  final double? height;
  final Widget fallbackWidget;

  @override
  Widget build(BuildContext context) {
    return Image.memory(
      imageBytes!,
      fit: fit,
      width: width,
      height: height,
      frameBuilder: (BuildContext context, Widget child, int? frame, bool wasSynchronouslyLoaded) {
        if (wasSynchronouslyLoaded || frame != null) {
          return child;
        } else {
          return Lottie.asset(IconStrings.instance.loadingSpinner);
        }
      },
      errorBuilder: (context, error, stackTrace) => fallbackWidget,
    );
  }
}
