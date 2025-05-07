import 'package:custom_widgets_toolkit/custom_widgets_toolkit.dart';
import 'package:flutter/material.dart';
import 'package:flutter_animate/flutter_animate.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:iconsax_flutter/iconsax_flutter.dart';
import 'package:slides_sync/app/models/app_ui_model.dart';
import 'package:slides_sync/app/states/app_ui_state.dart';
import 'package:slides_sync/components/widgets/app_bar_container.dart';
import 'package:slides_sync/components/widgets/component_widgets.dart';
import 'package:slides_sync/dummy/course_material_card_test_data.dart';
import 'package:slides_sync/use_cases/library/library_ui_funcs.dart';

import 'course_materials/course_material_card.dart';

class IsCourseMaterialCardExpanded extends FamilyNotifier<bool, int> {
  @override
  build(value) => false;
  update(bool value) {
    if (state == value) return;
    state = value;
  }
}

class CourseMaterialsView extends ConsumerStatefulWidget {
  final NotifierProvider<AppUiState, AppUiModel> appUiStateProvider;

  const CourseMaterialsView(this.appUiStateProvider, {super.key});

  @override
  ConsumerState<CourseMaterialsView> createState() => _CourseMaterialsViewState();
}

class _CourseMaterialsViewState extends ConsumerState<CourseMaterialsView> {
  late final NotifierProviderFamily<IsCourseMaterialCardExpanded, bool, int> isCourseMaterialCardExpandedFamily;

  @override
  void initState() {
    super.initState();
    isCourseMaterialCardExpandedFamily = NotifierProviderFamily<IsCourseMaterialCardExpanded, bool, int>(IsCourseMaterialCardExpanded.new);
  }

  @override
  Widget build(BuildContext context) {
    final AppUiModel appUiModel = ref.watch(appUiStateProvider);

    return Scaffold(
      appBar: AppBarContainer(
        appBarHeight: kToolbarHeight + 12,
        padding: EdgeInsets.zero,
        child: Material(
          type: MaterialType.transparency,
          shape: LinearBorder(bottom: LinearBorderEdge(), side: BorderSide(color: appUiModel.isDarkMode ? Colors.lightBlueAccent.withAlpha(60) : Colors.grey.withAlpha(40))),
          child: Padding(
            padding: EdgeInsets.symmetric(horizontal: 12),
            child: Row(
              children: [
                ComponentWidgets.backButton(context),
                ConstantSizing.rowSpacingMedium,
                Expanded(child: CustomText("Textbooks", fontSize: 18, fontWeight: FontWeight.bold)),
              ],
            ),
          ),
        ),
      ),
      body: ListView.builder(
        padding: EdgeInsets.only(top: 8),
        physics: BouncingScrollPhysics(),
        itemCount: CourseMaterialCardTestData.dummyCourseMaterials.length,
        itemBuilder: (context, index) {
          return CourseMaterialCard(
            appUiModel,
            courseMaterialCardModel: CourseMaterialCardTestData.dummyCourseMaterials[index],
            index: index,
            isCourseMaterialCardExpandedFamily: isCourseMaterialCardExpandedFamily,
            listLength: CourseMaterialCardTestData.dummyCourseMaterials.length,
          ).animate().slideX(
            begin:
                0.2 *
                (index +
                    (CourseMaterialCardTestData.dummyCourseMaterials.length * 0.1) /
                        CourseMaterialCardTestData.dummyCourseMaterials.length),
            end: 0,
            curve: CustomCurves.bouncySpring,
            duration: Durations.extralong4,
          );
        },
      ),
    );
  }
}
