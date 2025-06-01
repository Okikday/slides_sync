import 'dart:io';

import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:iconsax_flutter/iconsax_flutter.dart';
import 'package:lottie/lottie.dart';
import 'package:slides_sync/core/models/image_location.dart';
import 'package:slides_sync/core/utils/file_utils.dart';
import 'package:slides_sync/shared/strings/icon_strings.dart';

class WidgetHelper {
  static Widget resolveImageWidget(ImageLocation imageLocation, {Widget fallbackWidget = const Icon(Iconsax.document)}) {
    if (!imageLocation.containsImagePath) return fallbackWidget;
    try {
      final Widget image;
      if (imageLocation.filePath.isNotEmpty) {
        image = Image.file(
          File(imageLocation.filePath),
          fit: BoxFit.cover,
          frameBuilder: (BuildContext context, Widget child, int? frame, bool wasSynchronouslyLoaded) {
            if (wasSynchronouslyLoaded || frame != null) {
              return child;
            } else {
              return Lottie.asset(IconStrings.instance.loadingSpinner);
            }
          },
          errorBuilder: (context, error, stackTrace) => fallbackWidget,
        );
      } else if (imageLocation.urlPath.isNotEmpty) {
        image = CachedNetworkImage(
          imageUrl: imageLocation.urlPath,
          fit: BoxFit.cover,
          progressIndicatorBuilder: (context, url, progress) {
            return Lottie.asset(IconStrings.instance.loadingSpinner);
          },
          errorWidget: (context, error, stackTrace) => fallbackWidget,
        );
      } else {
        image = fallbackWidget;
      }
      return image;
    } catch (e) {
      return fallbackWidget;
    }
  }
}
