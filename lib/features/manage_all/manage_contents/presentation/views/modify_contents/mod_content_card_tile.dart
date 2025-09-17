import 'package:custom_widgets_toolkit/custom_widgets_toolkit.dart';
import 'package:flutter/material.dart';
import 'package:flutter_animate/flutter_animate.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:iconsax_flutter/iconsax_flutter.dart';
import 'package:slides_sync/domain/models/file_details.dart';
import 'package:slides_sync/core/utils/ui_utils.dart';
import 'package:slides_sync/domain/models/course_model/course.dart';
import 'package:slides_sync/domain/repos/course_repo/course_content_repo.dart';
import 'package:slides_sync/features/course_navigation/presentation/actions/content_card_actions.dart';
import 'package:slides_sync/features/manage_all/manage_contents/presentation/actions/modify_content_card_actions.dart';
import 'package:slides_sync/features/manage_all/manage_contents/presentation/actions/modify_contents_action.dart';
import 'package:slides_sync/features/manage_all/manage_contents/usecases/create_contents_uc/create_content_preview_image.dart';
import 'package:slides_sync/shared/common_widgets/app_popup_menu_button.dart';
import 'package:slides_sync/shared/common_widgets/input_text_bottom_sheet.dart';
import 'package:slides_sync/shared/common_widgets/modifying_list_tile.dart';
import 'package:slides_sync/shared/helpers/extension_helper.dart';
import 'package:slides_sync/shared/helpers/widget_helper.dart';
import 'package:slides_sync/shared/widgets/build_image_path_widget.dart';

class ModContentCardTile extends ConsumerStatefulWidget {
  final CourseContent content;
  final bool? isSelected;

  /// This entails on click the icon or on long press
  final void Function()? onSelected;
  final void Function()? onTap;
  const ModContentCardTile({super.key, required this.content, this.isSelected, this.onSelected, this.onTap});

  @override
  ConsumerState<ModContentCardTile> createState() => _ModContentCardTileState();
}

class _ModContentCardTileState extends ConsumerState<ModContentCardTile> {
  late final AutoDisposeStreamProvider<CourseContent?> contentProvider;
  @override
  void initState() {
    super.initState();
    contentProvider = AutoDisposeStreamProvider((ref) async* {
      yield* CourseContentRepo.watchByDbId(widget.content.id);
    });
  }

  @override
  Widget build(BuildContext context) {
    final CourseContent content = ref.watch(contentProvider).value ?? widget.content;
    return Padding(
      padding: EdgeInsets.only(bottom: context.hPadding7),
      child: ModifyingListTile(
        onTapTile: widget.onTap,
        leading: FutureBuilder(
          future: ContentCardActions.resolvePreviewPath(content),
          builder: (context, asyncSnapshot) {
            if (asyncSnapshot.hasData && asyncSnapshot.data != null) {
              return BuildImagePathWidget(
                fileDetails: asyncSnapshot.data!,
                fit: BoxFit.cover,
                fallbackWidget: Icon(WidgetHelper.resolveIconData(content.courseContentType, false), size: 36),
              );
            }
            return BuildImagePathWidget(
              fileDetails: FileDetails(),
              fallbackWidget: Icon(WidgetHelper.resolveIconData(content.courseContentType, false), size: 36),
            );
          },
        ),
        trailing:
            widget.isSelected == null
                ? AppPopupMenuButton(
                  actions: [
                    PopupMenuAction(
                      title: "Select",
                      iconData: Iconsax.check,
                      onTap: () {
                        if (widget.onSelected != null) widget.onSelected!();
                      },
                    ),
                    PopupMenuAction(
                      title: "Rename",
                      iconData: Iconsax.edit,
                      onTap: () => ModifyContentCardActions.onRenameContent(context, content),
                    ),
                    PopupMenuAction(
                      title: "Delete",
                      iconData: Iconsax.trash,
                      onTap: () => ModifyContentCardActions.onDeleteContent(context, content),
                    ),
                  ],
                )
                : (widget.isSelected!
                    ? Icon(Icons.check_circle_rounded, size: 32, color: ref.theme.primary)
                    : Icon(Icons.circle, size: 32, color: ref.theme.onSurface.withAlpha(150))),
        title: content.title,
        subtitle:
            widget.content.courseContentType.name.substring(0, 1).toUpperCase() +
            widget.content.courseContentType.name.substring(1),
      ),
    );
  }
}
