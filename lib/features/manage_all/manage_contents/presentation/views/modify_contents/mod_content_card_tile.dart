import 'package:custom_widgets_toolkit/custom_widgets_toolkit.dart';
import 'package:flutter/material.dart';
import 'package:flutter_animate/flutter_animate.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:iconsax_flutter/iconsax_flutter.dart';
import 'package:slides_sync/domain/models/file_details.dart';
import 'package:slides_sync/core/utils/ui_utils.dart';
import 'package:slides_sync/domain/models/course_model/course.dart';
import 'package:slides_sync/domain/repos/course_repo/course_content_repo.dart';
import 'package:slides_sync/features/manage_all/manage_contents/usecases/actions/modify_contents_action.dart';
import 'package:slides_sync/features/manage_all/manage_contents/usecases/create_contents_uc/create_content_preview_image.dart';
import 'package:slides_sync/shared/common_widgets/input_text_bottom_sheet.dart';
import 'package:slides_sync/shared/common_widgets/modifying_list_tile.dart';
import 'package:slides_sync/shared/helpers/extension_helper.dart';
import 'package:slides_sync/shared/helpers/widget_helper.dart';
import 'package:slides_sync/shared/widgets/build_image_path_widget.dart';

typedef ModContentCardTileAction<Record> = ({String title, IconData iconData, void Function() onTap});



class ModContentCardTile extends ConsumerStatefulWidget {
  final CourseContent content;

  /// This entails on click the icon or on long press
  final void Function()? onSelected;
  final void Function()? onTap;
  const ModContentCardTile({super.key, required this.content, this.onSelected, this.onTap});

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
    final CourseContent? currContent = ref.watch(contentProvider).value;
    final actions = getActions(context, currContent: currContent ?? widget.content);
    return Padding(
      padding: EdgeInsets.only(bottom: context.hPadding7),
      child: ModifyingListTile(
        leading: BuildImagePathWidget(
          fileDetails: FileDetails(filePath: CreateContentPreviewImage.genPreviewImagePath(filePath: widget.content.path.filePath)),
          fallbackWidget: Icon(
            WidgetHelper.resolveIconData(widget.content.courseContentType),
            size: 22,
            color: ref.theme.primaryColor,
          ),
        ),
        trailing: PopupMenuTheme(
          data: PopupMenuThemeData(
            color: ref.theme.background.withValues(alpha: 0.95),
            shape: RoundedRectangleBorder(borderRadius: BorderRadiusGeometry.circular(16)),
            shadowColor: Colors.white.withAlpha(10),
          ),
          child: CircleAvatar(
            backgroundColor: ref.theme.altBackgroundPrimary,
            child: PopupMenuButton<int>(
              tooltip: "Show options",
              clipBehavior: Clip.hardEdge,
              menuPadding: EdgeInsets.zero,
              icon: Icon(Iconsax.more_copy, color: ref.theme.secondaryText),
              onSelected: (value) => actions[value].onTap(),
              itemBuilder: (context) {
                return List<PopupMenuItem<int>>.generate(actions.length, (index) {
                  final a = actions[index];
                  return PopupMenuItem(value: index, child: PopupMenuItemChild(title: a.title, iconData: a.iconData));
                });
              },
            ),
          ),
        ),
        title: currContent?.title ?? widget.content.title,
        subtitle: widget.content.courseContentType.name.substring(0, 1).toUpperCase() + widget.content.courseContentType.name.substring(1),
      ),
    );
  }
}

class PopupMenuItemChild extends ConsumerWidget {
  final IconData iconData;
  final String title;
  const PopupMenuItemChild({super.key, required this.title, required this.iconData});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    return Row(
      mainAxisSize: MainAxisSize.min,
      spacing: 8,
      children: [
        Icon(iconData, color: ref.theme.secondaryText),
        CustomText(title, color: ref.theme.primaryText),
        ConstantSizing.rowSpacingSmall,
      ],
    );
  }
}


/// Available actions you can take to modify a content
List<ModContentCardTileAction> getActions(BuildContext context, {required CourseContent currContent}) {
  final mca = ModifyContentsAction();
  final actions = <ModContentCardTileAction>[
    (title: "Select", iconData: Iconsax.tick_circle, onTap: () {}),
    (
      title: "Rename",
      iconData: Iconsax.edit,
      onTap: () {
        UiUtils.showCustomDialog(
          context,
          child: InputTextBottomSheet(
            title: "Rename content",
            hintText: "Input a title different from previous one",
            defaultText: currContent.title,
            onSubmitted: (String text) async {
              await mca.onRenameContent(currContent, newTitle: text.trim());
              if (context.mounted) CustomDialog.hide(context);
            },
          ).animate().fadeIn().scaleY(
            begin: 0.1,
            end: 1.0,
            curve: CustomCurves.bouncySpring,
            duration: Durations.extralong1,
            alignment: Alignment.bottomCenter,
          ),
        );
      },
    ),
    (
      title: "Delete",
      iconData: Iconsax.trash,
      onTap: () async {
        final outcome = await mca.onDeleteContent(currContent);
        if (context.mounted) {
          if (outcome == null) {
            UiUtils.showFlushBar(context, msg: "Successfully removed content!", vibe: FlushbarVibe.success);
          } else if (outcome.toLowerCase().contains("error")) {
            UiUtils.showFlushBar(context, msg: outcome, vibe: FlushbarVibe.error);
          } else {
            UiUtils.showFlushBar(context, msg: outcome, vibe: FlushbarVibe.warning);
          }
        }
      },
    ),
  ];
  return actions;
}