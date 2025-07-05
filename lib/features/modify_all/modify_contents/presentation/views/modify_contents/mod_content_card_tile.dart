import 'dart:developer';

import 'package:custom_widgets_toolkit/custom_widgets_toolkit.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:iconsax_flutter/iconsax_flutter.dart';
import 'package:slides_sync/core/models/file_details.dart';
import 'package:slides_sync/data/models/course_model/course_model.dart';
import 'package:slides_sync/features/create_content/domain/usecases/add_contents_uc/create_content_preview_image.dart';
import 'package:slides_sync/shared/common_widgets/modifying_list_tile.dart';
import 'package:slides_sync/shared/helpers/extension_helper.dart';
import 'package:slides_sync/shared/helpers/widget_helper.dart';
import 'package:slides_sync/shared/widgets/build_image_path_widget.dart';

typedef ModContentCardTileAction<Record> = ({String title, IconData iconData, void Function() onTap});

class ModContentCardTile extends ConsumerWidget {
  final CourseContent content;
  final List<ModContentCardTileAction> actions;

  /// This entails on click the icon or on long press
  final void Function()? onSelected;
  final void Function()? onTap;
  const ModContentCardTile({
    super.key,
    required this.content,
    this.onSelected,
    this.onTap,
    this.actions = const <ModContentCardTileAction>[],
  });

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    return ModifyingListTile(
      leading: BuildImagePathWidget(
        fileDetails: FileDetails(
          filePath: CreateContentPreviewImage.genPreviewImagePath(filePath: content.path.filePath, contentId: content.id),
        ),
        fallbackWidget: Icon(
          WidgetHelper.resolveIconData(content.courseContentType),
          size: 22,
          color: context.isDarkMode ? Colors.deepPurpleAccent : Colors.deepPurple,
        ),
      ),
      trailing: PopupMenuTheme(
        data: PopupMenuThemeData(
          color: context.scaffoldBackgroundColor.withValues(alpha: 0.95),
          shape: RoundedRectangleBorder(borderRadius: BorderRadiusGeometry.circular(16)),
          shadowColor: Colors.white.withAlpha(10),
        ),
        child: PopupMenuButton<int>(
          clipBehavior: Clip.hardEdge,
          menuPadding: EdgeInsets.zero,
          icon: Icon(Iconsax.more_copy),
          onSelected: (value)  => actions[value].onTap(),
          itemBuilder: (context) {
            return List<PopupMenuItem<int>>.generate(actions.length, (index) {
              final a = actions[index];
              return PopupMenuItem(value: index, child: PopupMenuItemChild(title: a.title, iconData: a.iconData));
            });
          },
        ),
      ),
      title: content.title,
      subtitle: content.courseContentType.name.substring(0, 1).toUpperCase() + content.courseContentType.name.substring(1),
    );
  }
}

class PopupMenuItemChild extends StatelessWidget {
  final IconData iconData;
  final String title;
  const PopupMenuItemChild({super.key, required this.title, required this.iconData});

  @override
  Widget build(BuildContext context) {
    return Row(mainAxisSize: MainAxisSize.min, spacing: 8, children: [Icon(iconData), CustomText(title), ConstantSizing.rowSpacingSmall]);
  }
}
