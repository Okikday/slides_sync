import 'package:custom_widgets_toolkit/custom_widgets_toolkit.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:heroine/heroine.dart';
import 'package:iconsax_flutter/iconsax_flutter.dart';
import 'package:path/path.dart' as p;
import 'package:slides_sync/core/routes/app_route_navigator.dart';
import 'package:slides_sync/domain/models/course_model/course.dart';
import 'package:slides_sync/domain/models/file_details.dart';
import 'package:slides_sync/features/manage_all/manage_contents/usecases/create_contents_uc/create_content_preview_image.dart';
import 'package:slides_sync/shared/common_widgets/app_popup_menu_button.dart';
import 'package:slides_sync/shared/helpers/extension_helper.dart';
import 'package:slides_sync/shared/helpers/widget_helper.dart';
import 'package:slides_sync/shared/styles/colors.dart';
import 'package:slides_sync/shared/widgets/build_image_path_widget.dart';

class ContentCard extends ConsumerStatefulWidget {
  const ContentCard({super.key, required this.content, this.progress});

  final CourseContent content;
  final double? progress;

  @override
  ConsumerState<ContentCard> createState() => _ContentCardState();
}

class _ContentCardState extends ConsumerState<ContentCard> {
  @override
  Widget build(BuildContext context) {
    final theme = ref.theme;
    final content = widget.content;
    return Row(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        Flexible(
          child: ConstrainedBox(
            constraints: BoxConstraints.tightFor(width: 440, height: 200),
            child: Stack(
              clipBehavior: Clip.antiAlias,
              fit: StackFit.expand,
              children: [
                InkWell(
                  borderRadius: BorderRadius.circular(16),
                  onTap: () {
                    AppRouteNavigator.to(context).contentViewGateRoute(content);
                  },
                  child: Container(
                    // curve: CustomCurves.defaultIosSpring,
                    // duration: Durations.extralong1,
                    constraints: BoxConstraints(maxHeight: 200, maxWidth: 320),
                    clipBehavior: Clip.antiAlias,
                    decoration: BoxDecoration(
                      color: theme.bgLightenColor(),
                      borderRadius: BorderRadius.circular(16),
                      border: Border.fromBorderSide(BorderSide(color: theme.altBackgroundSecondary.withAlpha(100))),
                    ),
                    child: Column(
                      children: [
                        Expanded(
                          child: SizedBox.expand(
                            child: ClipRRect(
                              borderRadius: BorderRadius.only(
                                topLeft: Radius.circular(15),
                                topRight: Radius.circular(15),
                              ),
                              child: ImageFiltered(
                                imageFilter: ColorFilter.mode(Colors.black.withAlpha(10), BlendMode.color),
                                child: BuildImagePathWidget(
                                  fileDetails: FileDetails(
                                    filePath: CreateContentPreviewImage.genPreviewImagePath(
                                      filePath: content.path.filePath,
                                    ),
                                  ),
                                  fit: BoxFit.cover,
                                  fallbackWidget: Icon(
                                    WidgetHelper.resolveIconData(content.courseContentType, false),
                                    size: 36,
                                  ),
                                ),
                              ),
                            ),
                          ),
                        ),
                        LinearProgressIndicator(
                          value: (widget.progress?.clamp(0, 100) ?? 0.0),
                          color: theme.primaryColor,
                          backgroundColor: theme.bgLightenColor(0.85, 0.15).withAlpha(200),
                        ),

                        Container(
                          color: theme.bgLightenColor(0.85, 0.15).withAlpha(200),
                          padding: EdgeInsets.fromLTRB(12, 8, 4, 8),
                          child: Row(
                            children: [
                              Expanded(
                                child: Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  mainAxisSize: MainAxisSize.min,
                                  spacing: 2.5,
                                  children: [
                                    Flexible(
                                      child: Tooltip(
                                        message: content.title,
                                        triggerMode: TooltipTriggerMode.tap,
                                        child: CustomText(
                                          content.title,
                                          color: theme.onBackground,
                                          fontWeight: FontWeight.w600,
                                          overflow: TextOverflow.ellipsis,
                                        ),
                                      ),
                                    ),
                                    CustomText(
                                      widget.progress == null || widget.progress == 0
                                          ? "Start reading!"
                                          : widget.progress == 1
                                          ? "Completed!"
                                          : "${((widget.progress?.clamp(0, 100) ?? 0.0) * 100.0).toInt()}% read",
                                      fontSize: 10,
                                      color: widget.progress == 1 ? theme.primary : theme.supportingText,
                                    ),
                                  ],
                                ),
                              ),

                              AppPopupMenuButton(
                                iconSize: 16,
                                actions: [
                                  PopupMenuAction(
                                    title: "Pin",
                                    iconData: Icons.check_box_outline_blank_rounded,
                                    onTap: () {},
                                  ),
                                  PopupMenuAction(title: "Select", iconData: Iconsax.check, onTap: () {}),
                                  PopupMenuAction(title: "Add to Group", iconData: Iconsax.additem, onTap: () {}),
                                  PopupMenuAction(title: "Remove", iconData: Icons.delete, onTap: () {}),
                                ],
                              ),
                            ],
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
                Positioned(
                  top: 8,
                  right: 8,
                  child: Builder(
                    builder: (context) {
                      final res = resolveExtension(content);
                      if (res.isEmpty) return const SizedBox();
                      return Container(
                        padding: EdgeInsets.symmetric(horizontal: 8, vertical: 2),
                        clipBehavior: Clip.hardEdge,
                        decoration: BoxDecoration(
                          borderRadius: BorderRadius.circular(20),
                          color: theme.altBackgroundPrimary,
                        ),
                        child: CustomText(res, color: theme.primaryColor, fontSize: 11, fontWeight: FontWeight.bold),
                      );
                    },
                  ),
                ),
              ],
            ),
          ),
        ),
      ],
    );
  }
}

String resolveExtension(CourseContent content) {
  final res = p.extension(content.path.filePath).replaceAll('.', '').toUpperCase();
  switch (content.courseContentType) {
    case CourseContentType.image:
      return res;
    case CourseContentType.document:
      return res;
    case CourseContentType.link:
      return "link";
    default:
      return '';
  }
}
