import 'package:custom_widgets_toolkit/custom_widgets_toolkit.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:iconsax_flutter/iconsax_flutter.dart';
import 'package:slides_sync/domain/models/course_model/course.dart';
import 'package:slides_sync/domain/models/file_details.dart';
import 'package:slides_sync/features/course_navigation/presentation/views/course_materials/course_material_list_card.dart';
import 'package:slides_sync/features/course_navigation/presentation/views/course_materials/course_material_grid_card.dart';
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

  final List<CourseMaterialListCardActionModel> simList = [
    CourseMaterialListCardActionModel(label: 'Open', icon: Iconsax.document, onTap: () {}),
    CourseMaterialListCardActionModel(label: 'Share', icon: Iconsax.share, onTap: () {}),
    CourseMaterialListCardActionModel(label: 'Details', icon: Iconsax.info_circle, onTap: () {}),
    CourseMaterialListCardActionModel(label: 'Add to favorites', icon: Iconsax.star, onTap: () {}),
  ];

  @override
  void initState() {
    super.initState();
    isCourseMaterialCardExpandedFamily = AutoDisposeStateProviderFamily((ref, index) => false);
  }

  @override
  Widget build(BuildContext context) {
    final courseContents = widget.collection.contents.toList();

    if (courseContents.isEmpty) {
      return Center(child: CustomText("No content found", color: AppColors.primaryText(context)));
    }
    return GridView.builder(
      gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
        crossAxisCount: context.deviceWidth ~/ 150,
        crossAxisSpacing: 12,
        mainAxisSpacing: 16,
      ),
      itemCount: courseContents.length,
      padding: EdgeInsets.symmetric(horizontal: 16, vertical: 16),
      itemBuilder: (context, index) {
        return CourseMaterialGridCard(courseContent: courseContents[index]);
      },
    );
    // return ListView.builder(
    //   padding: EdgeInsets.only(top: 8),
    //   physics: BouncingScrollPhysics(),
    //   itemCount: courseContents.length,
    //   itemBuilder: (context, index) {
    //     return CourseMaterialListCard(
    //       courseContent: courseContents[index],
    //       courseMaterialListCardActionModels: simList,
    //       isCourseMaterialListCardExpandedProvider: isCourseMaterialCardExpandedFamily(index),
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
