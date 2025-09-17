import 'dart:developer';

import 'package:custom_widgets_toolkit/custom_widgets_toolkit.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:iconsax_flutter/iconsax_flutter.dart';
import 'package:isar/isar.dart';
import 'package:slides_sync/domain/models/course_model/course.dart';
import 'package:slides_sync/domain/repos/course_repo/course_content_repo.dart';
import 'package:slides_sync/features/all_tabs/tab_library/presentation/views/library_tab_view/library_tab_view_app_bar/build_button.dart';
import 'package:slides_sync/features/manage_all/manage_contents/presentation/views/modify_contents/mod_content_card_tile.dart';
import 'package:slides_sync/shared/helpers/extension_helper.dart';

class ModContentSearchViewButton extends ConsumerWidget {
  final Color? backgroundColor;
  final void Function()? doBeforeTap;
  const ModContentSearchViewButton({super.key, this.backgroundColor, this.doBeforeTap});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final theme = ref.theme;
    return SearchAnchor(
      viewBackgroundColor: theme.background,
      dividerColor: theme.supportingText.withAlpha(40),
      
      builder:
          (context, controller) => BuildButton(
            onTap: () {
              if(doBeforeTap != null) doBeforeTap!();
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
                    "Input a course title to search...",
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
          for (int i = 0; i < searchResults.length; i++)
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 16),
              child: ModContentCardTile(
                content: searchResults[i],
                onTap: () {
                  controller.closeView("");
                },
              ),
            ),
        ];
      },
    );
  }
}
