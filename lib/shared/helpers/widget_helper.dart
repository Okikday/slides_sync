import 'package:flutter/widgets.dart';
import 'package:iconsax_flutter/iconsax_flutter.dart';
import 'package:slides_sync/domain/models/course_model/sub/course_content_type.dart';

class WidgetHelper {
  static IconData resolveIconData(CourseContentType type, [bool isOutlined = false]) {
    switch (type) {
      case CourseContentType.audio:
        return isOutlined ? Iconsax.audio_square_copy : Iconsax.audio_square;
      case CourseContentType.document:
        return isOutlined ? Iconsax.document_copy : Iconsax.document;
      case CourseContentType.image:
        return isOutlined ? Iconsax.image_copy : Iconsax.image;
      case CourseContentType.link:
        return isOutlined ? Iconsax.link_copy : Iconsax.link;
      case CourseContentType.unknown:
        return isOutlined ? Iconsax.info_circle_copy : Iconsax.info_circle;
      case CourseContentType.video:
        return isOutlined ? Iconsax.video_copy : Iconsax.video;
      case CourseContentType.note:
        return isOutlined ? Iconsax.note_copy : Iconsax.note;
    }
  }
}
