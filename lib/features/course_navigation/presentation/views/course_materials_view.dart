import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:slides_sync/core/utils/ui_utils.dart';
import 'package:slides_sync/shared/components/app_bar_container.dart';
import 'package:slides_sync/shared/components/app_bar_container_child.dart';
import 'package:slides_sync/shared/helpers/extension_helper.dart';

import '../../../../test/course_material_card_test_data.dart';
import 'course_materials_view/course_material_card.dart';
class CourseMaterialsView extends ConsumerStatefulWidget {

  const CourseMaterialsView({super.key});

  @override
  ConsumerState<CourseMaterialsView> createState() => _CourseMaterialsViewState();
}

class _CourseMaterialsViewState extends ConsumerState<CourseMaterialsView> {
  late final AutoDisposeStateProviderFamily<bool, int> isCourseMaterialCardExpandedFamily;

  @override
  void initState() {
    super.initState();
    isCourseMaterialCardExpandedFamily = AutoDisposeStateProviderFamily((ref, index) => false);
  }

  @override
  void dispose() {
    super.dispose();
  }


  @override
  Widget build(BuildContext context) {

    return AnnotatedRegion(
      value: UiUtils.getSystemUiOverlayStyle(context.scaffoldBackgroundColor, context.isDarkMode),
      child: Scaffold(
        appBar: AppBarContainer(
          appBarHeight: kToolbarHeight + 12,
          padding: EdgeInsets.zero,
          child: AppBarContainerChild(context.isDarkMode, title: "Course Materials"),
        ),

        body: ListView.builder(
          padding: EdgeInsets.only(top: 8),
          physics: BouncingScrollPhysics(),
          itemCount: CourseMaterialCardTestData.dummyCourseMaterials.length,
          itemBuilder: (context, index) {
            return CourseMaterialCard(
              courseMaterialCardModel: CourseMaterialCardTestData.dummyCourseMaterials[index],
              index: index,
              isCourseMaterialCardExpandedFamily: isCourseMaterialCardExpandedFamily,
              listLength: CourseMaterialCardTestData.dummyCourseMaterials.length,
            );
          },
        ),
      ),
    );
  }
}
