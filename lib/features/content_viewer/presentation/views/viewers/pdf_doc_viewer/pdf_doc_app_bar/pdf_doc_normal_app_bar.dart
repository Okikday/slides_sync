import 'dart:developer';
import 'dart:io';

import 'package:custom_widgets_toolkit/custom_widgets_toolkit.dart';
import 'package:flutter/material.dart';
import 'package:flutter_animate/flutter_animate.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:iconsax_flutter/iconsax_flutter.dart';
import 'package:slides_sync/domain/models/file_details.dart';
import 'package:slides_sync/features/all_tabs/tab_library/presentation/views/library_tab_view/library_tab_view_app_bar/build_button.dart';
import 'package:slides_sync/features/content_viewer/presentation/controllers/doc_viewer_controllers/pdf_doc_viewer_controller.dart';
import 'package:slides_sync/features/content_viewer/presentation/providers/pdf_doc_viewer_providers.dart';
import 'package:slides_sync/features/share_contents/domain/usecases/share_content_uc.dart';
import 'package:slides_sync/shared/common_widgets/app_popup_menu_button.dart';
import 'package:slides_sync/shared/components/app_bar_container.dart';
import 'package:slides_sync/shared/helpers/extension_helper.dart';

class PdfDocNormalAppBar extends ConsumerWidget {
  const PdfDocNormalAppBar({super.key, required this.title, required this.pdva, required this.isSearchingNotifier});

  final String title;
  final PdfDocViewerController pdva;
  final ValueNotifier<bool> isSearchingNotifier;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final theme = ref.theme;
    return ValueListenableBuilder(
      valueListenable: isSearchingNotifier,
      builder: (context, value, child) {
        return AppBarContainerChild(
              theme.isDarkTheme,
              title: title,
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
                      actions: [
                        PopupMenuAction(
                          title: "Go to last page",
                          iconData: Iconsax.play,
                          onTap: () {
                            pdva.pdfViewerController.goToPage(pageNumber: pdva.initialPage);
                          },
                        ),
                        PopupMenuAction(
                          title: "Share",
                          iconData: Icons.share_rounded,
                          onTap: () {
                            ShareContentUc().shareFile(
                              context,
                              File(pdva.content.path.filePath),
                              filename: pdva.content.title,
                            );
                          },
                        ),
                        PopupMenuAction(title: "Horizontal layout", iconData: Iconsax.book_1, onTap: () {}),
                        () {
                          final isDarkMode =
                              (ref.watch(PdfDocViewerProviders.ispdfViewerInDarkModeNotifier).value ?? false);
                          return PopupMenuAction(
                            title: isDarkMode ? "Normal mode(Light)" : "Inverted mode(Dark)",
                            iconData: isDarkMode ? Iconsax.sun_1 : Iconsax.moon,
                            onTap: () {
                              ref.read(PdfDocViewerProviders.ispdfViewerInDarkModeNotifier.notifier).toggle();
                            },
                          );
                        }(),
                      ],
                    ),

                    // Printing, Share, Save to Google drive
                  ],
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
