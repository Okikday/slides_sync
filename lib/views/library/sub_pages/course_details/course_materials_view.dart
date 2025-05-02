import 'package:custom_widgets_toolkit/custom_widgets_toolkit.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:iconsax_flutter/iconsax_flutter.dart';
import 'package:slides_sync/app/models/app_ui_model.dart';
import 'package:slides_sync/app/states/app_ui_state.dart';
import 'package:slides_sync/dummy/course_material_card_test_data.dart';
import 'package:slides_sync/use_cases/library/library_ui_funcs.dart';

import 'course_materials/course_material_card.dart';

class CourseMaterialsView extends ConsumerWidget {
  final NotifierProvider<AppUiState, AppUiModel> appUiStateProvider;
  const CourseMaterialsView(this.appUiStateProvider, {super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final AppUiModel appUiModel = ref.watch(appUiStateProvider);
    
    return Scaffold(
      appBar: AppBar(leading: BackButton(), title: CustomText("Textbooks", fontSize: 20), automaticallyImplyLeading: false),
      body: ListView.builder(
          itemCount: CourseMaterialCardTestData.dummyCourseMaterials.length,
          itemBuilder: (context, index){
            return CourseMaterialCard(appUiStateProvider, courseMaterialCardModel: CourseMaterialCardTestData.dummyCourseMaterials[index],);
          }),
    );
  }
}

