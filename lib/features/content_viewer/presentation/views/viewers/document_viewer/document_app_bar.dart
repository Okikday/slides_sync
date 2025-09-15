import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:iconsax_flutter/iconsax_flutter.dart';
import 'package:slides_sync/features/all_tabs/tab_library/presentation/views/library_tab_view/library_tab_view_app_bar/build_button.dart';
import 'package:slides_sync/features/all_tabs/tab_library/presentation/views/library_tab_view/library_tab_view_app_bar/library_tab_view_search_button.dart';
import 'package:slides_sync/shared/common_widgets/app_popup_menu_button.dart';
import 'package:slides_sync/shared/components/app_bar_container.dart';
import 'package:slides_sync/shared/helpers/extension_helper.dart';

class DocumentAppBar extends ConsumerWidget {
  const DocumentAppBar({super.key, required this.title, required this.isSearchingNotifier});

  final String title;
  final ValueNotifier<bool> isSearchingNotifier;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final theme = ref.theme;
    return Positioned.fill(
      child: AppBarContainerChild(
        theme.isDarkTheme,
        title: title,
        padding: EdgeInsets.only(left: 12, right: 8),
        trailing: Padding(
          padding: const EdgeInsets.only(left: 8.0),
          child: Row(
            children: [
              BuildButton(
                iconData: Iconsax.search_normal_copy,
                backgroundColor: Colors.transparent,
                onTap: () {
                  isSearchingNotifier.value = true;
                },
              ),
              AppPopupMenuButton(
                tooltip: "More options",
                menuPadding: EdgeInsets.only(right: 16),
                actions: [
                  PopupMenuAction(title: "Share", iconData: Icons.share_rounded, onTap: () {}),
                  PopupMenuAction(title: "Print", iconData: Iconsax.printer_copy, onTap: () {}),
                  PopupMenuAction(title: "Save", iconData: Iconsax.book_saved_copy, onTap: () {}),
                ],
              ),

              // Printing, Share, Save to Google drive
            ],
          ),
        ),
      ),
    );
  }
}
