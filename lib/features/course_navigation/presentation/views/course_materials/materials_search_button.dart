
import 'package:custom_widgets_toolkit/custom_widgets_toolkit.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:iconsax_flutter/iconsax_flutter.dart';
import 'package:isar/isar.dart';
import 'package:slides_sync/domain/models/course_model/course.dart';
import 'package:slides_sync/domain/repos/course_repo/course_content_repo.dart';
import 'package:slides_sync/features/all_tabs/tab_library/presentation/views/library_tab_view/library_tab_view_app_bar/build_button.dart';
import 'package:slides_sync/features/course_navigation/presentation/views/course_materials/course_material_list_card.dart';
import 'package:slides_sync/shared/helpers/extension_helper.dart';

class MaterialsSearchButton extends ConsumerWidget {
  final Color? backgroundColor;
  const MaterialsSearchButton({super.key, this.backgroundColor});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final theme = ref.theme;
    return SearchAnchor(
      viewBackgroundColor: theme.background,
      dividerColor: theme.supportingText.withAlpha(40),
      
      builder:
          (context, controller) => BuildButton(
            onTap: () {
              controller.openView();
            },
            iconData: Iconsax.search_normal_copy,
            backgroundColor: backgroundColor,
          ),
      suggestionsBuilder: (context, controller) async {
        if (controller.text.isEmpty) {
          return [
            Padding(
              padding: const EdgeInsets.only(top: kToolbarHeight, left: 16, right: 16),
              child: SizedBox(
                child: Center(
                  child: CustomText(
                    "Input a title to search...",
                    color: theme.backgroundSupportingText.withAlpha(150),
                  ),
                ),
              ),
            ),
          ];
        }
        final List<CourseContent> searchResults =
            await (await CourseContentRepo.filter).titleContains(controller.text, caseSensitive: false).findAll();
        return [
          ConstantSizing.columnSpacing(8),
          for (int i = 0; i < searchResults.length; i++)
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 16),
              child: CourseMaterialListCard(courseContent: searchResults[i], onTapCard: (){},)
            ),

          ConstantSizing.columnSpacing(context.viewInsets.bottom)
        ];
      },
    );
  }
}
