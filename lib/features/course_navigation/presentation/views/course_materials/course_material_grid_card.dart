import 'package:custom_widgets_toolkit/custom_widgets_toolkit.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:heroine/heroine.dart';
import 'package:slides_sync/core/utils/app_navigator.dart';
import 'package:slides_sync/core/utils/ui_utils.dart';
import 'package:slides_sync/domain/models/course_model/course.dart';
import 'package:slides_sync/domain/models/file_details.dart';
import 'package:slides_sync/features/content_viewer/presentation/views/content_view_gate.dart';
import 'package:slides_sync/features/manage_all/manage_contents/usecases/create_contents_uc/create_content_preview_image.dart';
import 'package:slides_sync/shared/helpers/extension_helper.dart';
import 'package:slides_sync/shared/helpers/formatter.dart';
import 'package:slides_sync/shared/helpers/widget_helper.dart';
import 'package:slides_sync/shared/styles/colors.dart';
import 'package:slides_sync/shared/widgets/build_image_path_widget.dart';

class CourseMaterialGridCard extends ConsumerWidget {
  const CourseMaterialGridCard({super.key, required this.courseContent});

  final CourseContent courseContent;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    return Heroine(
      tag: "CourseMaterialGridCard=>ContentViewGate=>${courseContent.contentId}",
      adjustToRouteTransitionDuration: true,
      child: Material(
        type: MaterialType.transparency,
        child: InkWell(
          borderRadius: BorderRadius.circular(16),
          onTap: () {
            AppNavigator.to(context).contentViewGateRoute(courseContent);
            
          },
          child: Container(
            clipBehavior: Clip.antiAlias,
            decoration: BoxDecoration(
              color: AppColors.bgBlendColor(context),
              borderRadius: BorderRadius.circular(16),
              border: Border.fromBorderSide(BorderSide(color: ref.theme.altBackgroundSecondary.withAlpha(100))),
            ),
            child: Column(
              children: [
                Expanded(
                  child: SizedBox.expand(
                    child: BuildImagePathWidget(
                      fileDetails: FileDetails(
                        filePath: CreateContentPreviewImage.genPreviewImagePath(
                          filePath: courseContent.path.filePath),
                      ),
                      fit: BoxFit.cover,
                      fallbackWidget: Icon(
                        WidgetHelper.resolveIconData(courseContent.courseContentType, false), size: 36),
                    ),
                  ),
                ),
                Column(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    LinearProgressIndicator(
                      value: 0.4,
                      color: ref.theme.primaryColor.withAlpha(60),
                      backgroundColor: AppColors.bgBlendColor(context, 0.85, 0.15).withAlpha(200),
                    ),
          
                    Container(
                      width: double.infinity,
                      color: AppColors.bgBlendColor(context, 0.85, 0.15).withAlpha(200),
                      padding: EdgeInsets.symmetric(horizontal: 12, vertical: 8),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          Flexible(
                            child: CustomText(
                              courseContent.title,
                              color: ref.theme.primaryText,
                              fontWeight: FontWeight.w600,
                              overflow: TextOverflow.ellipsis,
                            ),
                          ),
                          CustomText(
                            Formatter.formatEnumName(courseContent.courseContentType.name),
                            fontSize: 11,
                            color: ref.theme.secondaryText,
                          ),
                        ],
                      ),
                    ),
                  ],
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
