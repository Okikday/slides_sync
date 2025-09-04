import 'package:custom_widgets_toolkit/custom_widgets_toolkit.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:iconsax_flutter/iconsax_flutter.dart';
import 'package:slides_sync/domain/models/course_model/course.dart';
import 'package:slides_sync/domain/models/file_details.dart';
import 'package:slides_sync/features/course_navigation/presentation/views/course_materials/course_material_card.dart';
import 'package:slides_sync/features/manage_all/manage_contents/usecases/create_contents_uc/create_content_preview_image.dart';
import 'package:slides_sync/shared/helpers/extension_helper.dart';
import 'package:slides_sync/shared/helpers/formatter.dart';
import 'package:slides_sync/shared/helpers/widget_helper.dart';
import 'package:slides_sync/shared/styles/colors.dart';
import 'package:slides_sync/shared/widgets/build_image_path_widget.dart';

class CourseMaterialsOuterSection extends ConsumerStatefulWidget {
  final CourseCollection collection;
  const CourseMaterialsOuterSection({super.key, required this.collection});

  @override
  ConsumerState<ConsumerStatefulWidget> createState() => _CourseMaterialsOuterSectionState();
}

class _CourseMaterialsOuterSectionState extends ConsumerState<CourseMaterialsOuterSection> {
  late final AutoDisposeStateProviderFamily<bool, int> isCourseMaterialCardExpandedFamily;

  final List<CourseMaterialCardActionModel> simList = [
    CourseMaterialCardActionModel(label: 'Open', icon: Iconsax.document, onTap: () {}),
    CourseMaterialCardActionModel(label: 'Share', icon: Iconsax.share, onTap: () {}),
    CourseMaterialCardActionModel(label: 'Details', icon: Iconsax.info_circle, onTap: () {}),
    CourseMaterialCardActionModel(label: 'Add to favorites', icon: Iconsax.star, onTap: () {}),
  ];

  @override
  void initState() {
    super.initState();
    isCourseMaterialCardExpandedFamily = AutoDisposeStateProviderFamily((ref, index) => false);
  }

  @override
  Widget build(BuildContext context) {
    final courseContents = widget.collection.contents.toList();

    if (courseContents.isEmpty) return Center(child: CustomText("No content found", color: AppColors.primaryText(context),));
    return GridView.builder(
      gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
        crossAxisCount: context.deviceWidth ~/ 150,
        crossAxisSpacing: 12,
        mainAxisSpacing: 16,
      ),
      itemCount: courseContents.length,
      padding: EdgeInsets.symmetric(horizontal: 16, vertical: 16),
      itemBuilder: (context, index) {
        return Container(
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
                        filePath: courseContents[index].path.filePath,
                      ),
                    ),
                    fit: BoxFit.cover,
                    fallbackWidget: Icon(
                      WidgetHelper.resolveIconData(courseContents[index].courseContentType, false),
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
                            courseContents[index].title,
                            color: ref.theme.primaryText,
                            fontWeight: FontWeight.w600,
                            overflow: TextOverflow.ellipsis,
                          ),
                        ),
                        CustomText(
                          Formatter.formatEnumName(courseContents[index].courseContentType.name),
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
        );
      },
    );
    // return ListView.builder(
    //   padding: EdgeInsets.only(top: 8),
    //   physics: BouncingScrollPhysics(),
    //   itemCount: courseContents.length,
    //   itemBuilder: (context, index) {
    //     return CourseMaterialCard(
    //       courseContent: courseContents[index],
    //       courseMaterialCardActionModels: simList,
    //       isCourseMaterialCardExpandedProvider: isCourseMaterialCardExpandedFamily(index),
    //       onTapCard: () {
    //         for (int i = 0; i < 10; i++) {
    //           final isExpandedNotifier = ref.read(isCourseMaterialCardExpandedFamily(i).notifier);
    //           if (i == index) {
    //             isExpandedNotifier.update((cb) => !isExpandedNotifier.state);
    //           } else {
    //             if (isExpandedNotifier.state) {
    //               isExpandedNotifier.update((cb) => false);
    //             }
    //           }
    //           // log("$i. ${isExpandedNotifier.state}");
    //         }
    //       },
    //       onLongPressed: () {},
    //     );
    //   },
    // );
  }
}
