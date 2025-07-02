import 'dart:developer';
import 'dart:io';

import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:iconsax_flutter/iconsax_flutter.dart';
import 'package:path/path.dart' as p;
import 'package:slides_sync/core/models/file_details.dart';
import 'package:slides_sync/core/utils/smart_isolate.dart';
import 'package:slides_sync/data/models/course_model/course_model.dart';
import 'package:slides_sync/features/modify_contents/domain/usecases/content_helper_uc.dart';
import 'package:slides_sync/shared/common_widgets/modifying_list_tile.dart';
import 'package:slides_sync/shared/helpers/extension_helper.dart';
import 'package:slides_sync/shared/helpers/widget_helper.dart';
import 'package:slides_sync/shared/widgets/build_image_path_widget.dart';

class ModContentCardTile extends ConsumerWidget {
  final CourseContent content;

  /// This entails on click the icon or on long press
  final void Function()? onSelected;
  final void Function()? onTap;
  const ModContentCardTile({super.key, required this.content, this.onSelected, this.onTap});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    
    return ModifyingListTile(
      leadingIcon: BuildImagePathWidget(
        fileDetails: FileDetails(filePath: ContentHelperUc.getImagePreviewPath(content)),
        fallbackWidget: Icon(
          WidgetHelper.resolveIconData(content.courseContentType),
          size: 22,
          color: context.isDarkMode ? Colors.deepPurpleAccent : Colors.deepPurple,
        ),
      ),
      trailingIcon: Icon(Iconsax.more_copy, size: 20, color: Colors.lightBlueAccent.withAlpha(150)),
      title: content.title,
      subtitle: content.courseContentType.name.substring(0, 1).toUpperCase() + content.courseContentType.name.substring(1),
    );
  }
}
