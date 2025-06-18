import 'package:flutter/widgets.dart';
import 'package:iconsax_flutter/iconsax_flutter.dart';
import 'package:slides_sync/data/models/course_model/sub/course_content_type.dart';

class WidgetHelper {
  static IconData resolveIconData(CourseContentType type) {
    switch (type) {
      case CourseContentType.audio:
        return Iconsax.audio_square;
      case CourseContentType.document:
        return Iconsax.document;
      case CourseContentType.image:
        return Iconsax.image;
      case CourseContentType.link:
        return Iconsax.link;
      case CourseContentType.unknown:
        return Iconsax.book;
      case CourseContentType.video:
        return Iconsax.video;
    }
  }
}
