import 'dart:io';

import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:iconsax_flutter/iconsax_flutter.dart';
import 'package:lottie/lottie.dart';
import 'package:slides_sync/shared/strings/icon_strings.dart';

class WidgetHelper {
  static Widget resolveImageWidget(String? imgPath, {Widget fallbackWidget = const Icon(Iconsax.document)}) {
    if (imgPath == null) return fallbackWidget;
    try {
      final Widget image;
      if (imgPath.startsWith("file:")) {
        image = Image.file(
          File(imgPath.substring(5).trim()),
          fit: BoxFit.cover,
          frameBuilder: (BuildContext context, Widget child, int? frame, bool wasSynchronouslyLoaded) {
            if (wasSynchronouslyLoaded || frame != null) {
              return child;
            } else {
              return Lottie.asset(IconStrings.instance.loadingSpinner);
            }
          },
        );
      } else if (imgPath.startsWith("url:")) {
        image = CachedNetworkImage(imageUrl: imgPath.substring(4, imgPath.length).trim(), fit: BoxFit.cover, progressIndicatorBuilder: (context, url, progress) {
          return Lottie.asset(IconStrings.instance.loadingSpinner);
        },);
      } else {
        image = fallbackWidget;
      }
      return image;
    } catch (e) {
      return fallbackWidget;
    }
  }
}
