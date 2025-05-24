import 'dart:io';

import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:iconsax_flutter/iconsax_flutter.dart';

class WidgetHelper {
  static Widget resolveImageWidget(String? imgPath, {Widget fallbackWidget = const Icon(Iconsax.document)}) {
    if (imgPath == null) return fallbackWidget;
    try {
      final Widget image;
      if (imgPath.startsWith("file:")) {
        image = Image.file(File(imgPath.substring(5, imgPath.length).trim()), fit: BoxFit.cover);
      } else if (imgPath.startsWith("url:")) {
        image = CachedNetworkImage(imageUrl: imgPath.substring(4, imgPath.length).trim(), fit: BoxFit.cover);
      } else {
        image = fallbackWidget;
      }
      return image;
    } catch (e) {
      return fallbackWidget;
    }
  }
}
