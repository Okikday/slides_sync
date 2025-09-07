
import 'package:custom_widgets_toolkit/custom_widgets_toolkit.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:heroine/heroine.dart';
import 'package:path/path.dart' as p;
import 'package:slides_sync/core/routes/app_route_navigator.dart';
import 'package:slides_sync/domain/models/course_model/course.dart';
import 'package:slides_sync/domain/models/file_details.dart';
import 'package:slides_sync/features/manage_all/manage_contents/usecases/create_contents_uc/create_content_preview_image.dart';
import 'package:slides_sync/shared/helpers/extension_helper.dart';
import 'package:slides_sync/shared/helpers/widget_helper.dart';
import 'package:slides_sync/shared/styles/colors.dart';
import 'package:slides_sync/shared/widgets/build_image_path_widget.dart';

class CourseMaterialGridCard extends ConsumerWidget {
  const CourseMaterialGridCard({super.key, required this.content});

  final CourseContent content;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final theme = ref.theme;
    return Heroine(
      tag: "CourseMaterialGridCard=>ContentViewGate=>${content.contentId}",
      adjustToRouteTransitionDuration: true,
      child: Material(
        type: MaterialType.transparency,
        child: InkWell(
          borderRadius: BorderRadius.circular(16),
          onTap: () {
            AppRouteNavigator.to(context).contentViewGateRoute(content);
          },
          child: Stack(
            children: [
              Container(
                clipBehavior: Clip.antiAlias,
                decoration: BoxDecoration(
                  color: AppColors.bgBlendColor(context),
                  borderRadius: BorderRadius.circular(16),
                  border: Border.fromBorderSide(BorderSide(color: theme.altBackgroundSecondary.withAlpha(100))),
                ),
                child: Column(
                  children: [
                    Expanded(
                      child: SizedBox.expand(
                        child: BuildImagePathWidget(
                          fileDetails: FileDetails(
                            filePath: CreateContentPreviewImage.genPreviewImagePath(filePath: content.path.filePath),
                          ),
                          fit: BoxFit.cover,
                          fallbackWidget: Icon(
                            WidgetHelper.resolveIconData(content.courseContentType, false),
                            size: 36,
                          ),
                        ),
                      ),
                    ),
                    Column(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        LinearProgressIndicator(
                          value: 0.4,
                          color: theme.primaryColor.withAlpha(60),
                          backgroundColor: AppColors.bgBlendColor(context, 0.85, 0.15).withAlpha(200),
                        ),

                        Container(
                          width: double.infinity,
                          color: AppColors.bgBlendColor(context, 0.85, 0.15).withAlpha(200),
                          padding: EdgeInsets.symmetric(horizontal: 12, vertical: 8),
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            mainAxisSize: MainAxisSize.min,
                            spacing: 2.5,
                            children: [
                              Flexible(
                                child: CustomText(
                                  content.title,
                                  color: theme.onBackground,
                                  fontWeight: FontWeight.w600,
                                  overflow: TextOverflow.ellipsis,
                                ),
                              ),
                              CustomText("75% read", fontSize: 10, color: theme.supportingText),
                            ],
                          ),
                        ),
                      ],
                    ),
                  ],
                ),
              ),
              Builder(
                builder: (context) {
                  final res = resolveExtension(content);
                  if (res.isEmpty) return const SizedBox();
                  return Positioned(
                    top: 8,
                    right: 8,
                    child: Container(
                      padding: EdgeInsets.symmetric(horizontal: 8, vertical: 2),
                      clipBehavior: Clip.hardEdge,
                      decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(20),
                        color: theme.altBackgroundPrimary,
                      ),
                      child: CustomText(res, color: theme.primaryColor, fontSize: 11, fontWeight: FontWeight.bold),
                    ),
                  );
                },
              ),
            ],
          ),
        ),
      ),
    );
  }
}

String resolveExtension(CourseContent content) {
  final res = p.extension(content.path.filePath).replaceAll('.', '');
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
