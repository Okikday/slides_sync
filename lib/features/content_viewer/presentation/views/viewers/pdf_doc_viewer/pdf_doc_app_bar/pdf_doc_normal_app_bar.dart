import 'package:custom_widgets_toolkit/custom_widgets_toolkit.dart';
import 'package:flutter/material.dart';
import 'package:flutter_animate/flutter_animate.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:iconsax_flutter/iconsax_flutter.dart';
import 'package:slides_sync/features/all_tabs/tab_library/presentation/views/library_tab_view/library_tab_view_app_bar/build_button.dart';
import 'package:slides_sync/shared/common_widgets/app_popup_menu_button.dart';
import 'package:slides_sync/shared/components/app_bar_container.dart';
import 'package:slides_sync/shared/helpers/extension_helper.dart';

class PdfDocNormalAppBar extends ConsumerWidget {
  const PdfDocNormalAppBar({super.key, required this.title, required this.isSearchingNotifier});

  final String title;
  final ValueNotifier<bool> isSearchingNotifier;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final theme = ref.theme;
    return ValueListenableBuilder(
      valueListenable: isSearchingNotifier,
      builder: (context, value, child) {
        return ColoredBox(
              color: theme.background,
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
                          PopupMenuAction(title: "Go to page", iconData: Icons.share_rounded, onTap: () {}),
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
            )
            .animate(target: value ? 0 : 1)
            .scale(
              begin: Offset(0, 0),
              end: Offset(1, 1),
              alignment: Alignment.bottomRight,
              curve: CustomCurves.defaultIosSpring,
              duration: Durations.medium4,
            )
            .fadeIn();
      },
    );
  }
}
