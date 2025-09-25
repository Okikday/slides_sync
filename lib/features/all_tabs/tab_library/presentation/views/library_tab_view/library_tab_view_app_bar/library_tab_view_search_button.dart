
import 'package:custom_widgets_toolkit/custom_widgets_toolkit.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:iconsax_flutter/iconsax_flutter.dart';
import 'package:isar/isar.dart';
import 'package:slides_sync/domain/models/course_model/course.dart';
import 'package:slides_sync/domain/repos/course_repo/course_repo.dart';
import 'package:slides_sync/features/all_tabs/tab_library/presentation/actions/course_card_actions.dart';
import 'package:slides_sync/features/all_tabs/tab_library/presentation/views/library_tab_view/courses_view/course_card.dart';
import 'package:slides_sync/features/all_tabs/tab_library/presentation/views/library_tab_view/library_tab_view_app_bar/build_button.dart';
import 'package:slides_sync/shared/common_widgets/app_popup_menu_button.dart';
import 'package:slides_sync/shared/helpers/extension_helper.dart';

class LibraryTabViewSearchButton extends ConsumerWidget {
  final Color? backgroundColor;
  const LibraryTabViewSearchButton({super.key, this.backgroundColor});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final theme = ref.theme;
    return SearchAnchor(
      viewBackgroundColor: theme.background,
      dividerColor: theme.supportingText.withAlpha(40),
      viewTrailing: [
        AppPopupMenuButton(
          actions: [
            PopupMenuAction(title: "Courses", iconData: Icons.check_rounded, onTap: () {}),
            PopupMenuAction(
              title: "Collections",
              iconData: Icons.check_box_outline_blank,
              icon: const SizedBox(),
              onTap: () {},
            ),
            PopupMenuAction(
              title: "Materials",
              iconData: Icons.check_box_outline_blank,
              icon: const SizedBox(),
              onTap: () {},
            ),
          ],
        ),
      ],
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
                    "Input a course title to search...",
                    color: theme.backgroundSupportingText.withAlpha(150),
                  ),
                ),
              ),
            ),
          ];
        }
        final List<Course> searchResults =
            await (await CourseRepo.filter).courseTitleContains(controller.text, caseSensitive: false).findAll();
        return [
          const SizedBox(height: 12),
          for (int i = 0; i < searchResults.length; i++)
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 16),
              child: CourseCard(
                searchResults[i],
                false,
                onTap: (course) {
                  controller.closeView("");
                  CourseCardActions.of(ref).onTapCourseCard(course);
                },
              ),
            ),
        ];
      },
    );
  }
}
