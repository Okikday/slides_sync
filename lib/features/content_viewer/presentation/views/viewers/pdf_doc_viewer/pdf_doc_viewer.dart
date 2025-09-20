import 'dart:async';
import 'dart:developer';
import 'package:custom_widgets_toolkit/custom_widgets_toolkit.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:slides_sync/core/utils/ui_utils.dart';
import 'package:slides_sync/domain/models/course_model/sub/course_content.dart';
import 'package:slides_sync/domain/models/file_details.dart';
import 'package:slides_sync/features/content_viewer/presentation/controllers/doc_viewer_controllers/pdf_doc_search_controller.dart';
import 'package:slides_sync/features/content_viewer/presentation/controllers/doc_viewer_controllers/pdf_doc_viewer_controller.dart';
import 'package:slides_sync/features/content_viewer/presentation/views/viewers/pdf_doc_viewer/pdf_doc_app_bar/pdf_doc_viewer_app_bar.dart';
import 'package:slides_sync/features/content_viewer/presentation/views/viewers/pdf_doc_viewer/pdf_overlay_widgets/pdf_scrollbar_overlay.dart';
import 'package:slides_sync/features/content_viewer/presentation/views/viewers/pdf_doc_viewer/pdf_overlay_widgets/pdf_tools_menu.dart';
import 'package:slides_sync/features/main/presentation/providers/main_providers.dart';
import 'package:slides_sync/shared/helpers/extension_helper.dart';
import 'package:pdfrx/pdfrx.dart';

class PdfDocViewer extends ConsumerStatefulWidget {
  final CourseContent content;
  const PdfDocViewer({super.key, required this.content});

  @override
  ConsumerState<PdfDocViewer> createState() => _PdfDocViewerState();
}

class _PdfDocViewerState extends ConsumerState<PdfDocViewer> {
  late final PdfDocViewerController pdva;
  late final PdfDocSearchController pdsa;
  late final PdfViewerController pdfViewerController;


  @override
  void initState() {
    super.initState();
    pdfViewerController = PdfViewerController();

    pdva = PdfDocViewerController.of(widget.content, pdfViewerController: pdfViewerController);
    pdsa = PdfDocSearchController(
      context: context,
      pdfViewerController: pdfViewerController,
      onStateChanged: () {
        setState(() {});
      },
    );
    pdva.initialize().then((data) {
      if (data == true) {
        WidgetsBinding.instance.addPostFrameCallback(
          (_) => setState(() {
            pdva.initialPage;
          }),
        );
      }
    });
  }

  @override
  void dispose() {
    pdsa.dispose();
    pdva.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final theme = ref.theme;
    final content = widget.content;
    return ValueListenableBuilder(
      valueListenable: pdsa.isSearchingNotifier,
      builder: (context, value, child) {
        return PopScope(
          canPop: !value,
          onPopInvokedWithResult: (didPop, result) {
            if (value) pdsa.isSearchingNotifier.value = false;
            SystemChrome.setEnabledSystemUIMode(SystemUiMode.edgeToEdge);
          },
          child: AnnotatedRegion(
            value: UiUtils.getSystemUiOverlayStyle(context.scaffoldBackgroundColor, context.isDarkMode),
            child: Scaffold(
              // extendBodyBehindAppBar: true,
              floatingActionButton: Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  if (pdsa.textSearcher != null)
                    Container(
                      padding: EdgeInsets.symmetric(horizontal: 16, vertical: 8),
                      decoration: BoxDecoration(color: theme.background, borderRadius: BorderRadius.circular(20)),
                      child: _NavigationControls(
                        textSearcher: pdsa.textSearcher,
                        onNavigateToInstance: pdsa.navigateToInstance,
                      ),
                    ),
                  ValueListenableBuilder(
                    valueListenable: pdva.isAppBarVisibleNotifier,
                    builder: (context, value, child) {
                      if (!value || pdsa.textSearcher != null) return const SizedBox();
                      return PdfToolsMenu(isOptionsVisibleNotifier: pdva.isToolsMenuVisible, isVisible: true);
                    },
                  ),
                ],
              ),

              body: NestedScrollView(
                physics: NeverScrollableScrollPhysics(),
                headerSliverBuilder: (context, innerBoxIsScrolled) {
                  return [
                    PinnedHeaderSliver(
                      child: PdfDocViewerAppBar(pdva: pdva, pdsa: pdsa, title: content.title),
                    ),
                  ];
                },
                body: content.path.filePath.isNotEmpty
                    ? PdfViewer.file(
                        content.path.filePath,
                        initialPageNumber: pdva.initialPage,
                        params: PdfViewerParams(
                          backgroundColor: theme.background,
                          activeMatchTextColor: theme.primary.withValues(alpha: 0.5),
                          viewerOverlayBuilder: (context, size, handleLinkTap) {
                            return [
                              PdfScrollbarOverlay(
                                controller: pdfViewerController,
                                animationDuration: Duration(milliseconds: 200),
                              ),
                            ];
                          },
                          onGeneralTap: (context, controller, details) {
                            log("Details: ${details.type}"); return true;
                            
                            // // Handle this part
                            // final currentRect = controller.visibleRect;
                            // final currentPageNum = controller.pageNumber;
                            // if (details.type != PdfViewerGeneralTapType.tap) return false;

                            // final bool isSearching = pdsa.isSearchingNotifier.value;
                            // if (isSearching) return false;
                            // final bool isAppBarVisible = pdva.isAppBarVisibleNotifier.value;
                            // // isSearchingNotifier.value = false;
                            // pdva.isAppBarVisibleNotifier.value = !isAppBarVisible;
                            // if (isAppBarVisible) {
                            //   SystemChrome.setEnabledSystemUIMode(SystemUiMode.immersive);
                            // } else {
                            //   final focusModeProvider = ref.read(MainProviders.isFocusModeProvider.notifier);
                            //   if (!focusModeProvider.state) {
                            //     SystemChrome.setEnabledSystemUIMode(SystemUiMode.edgeToEdge);
                            //   } else {
                            //     SystemChrome.setEnabledSystemUIMode(SystemUiMode.immersive);
                            //   }
                            // }
                            // return true;
                          },
                          pagePaintCallbacks: [
                            (canvas, pageRect, page) {
                              // forward to the active searcher, if any
                              pdsa.textSearcher?.pageTextMatchPaintCallback(canvas, pageRect, page);
                            },
                            // other page paint callbacks...
                          ],
                          textSelectionParams: PdfTextSelectionParams(
                            buildSelectionHandle: (context, anchor, state) {
                              TextSelectionHandleType type = state.index < 1
                                  ? TextSelectionHandleType.left
                                  : TextSelectionHandleType.right;

                              return CupertinoTextSelectionControls().buildHandle(context, type, 24.0, null);
                            },
                          ),
                        ),
                        controller: pdfViewerController,
                        // scrollDirection: PdfScrollDirection.vertical,
                        // pageLayoutMode: PdfPageLayoutMode.single,
                      )
                    : PdfViewer.uri(Uri.parse(content.path.urlPath), initialPageNumber: pdva.initialPage),
              ),
            ),
          ),
        );
      },
    );
  }
}

class _NavigationControls extends ConsumerWidget {
  const _NavigationControls({required this.textSearcher, required this.onNavigateToInstance});

  final PdfTextSearcher? textSearcher;
  final Future<void> Function(bool) onNavigateToInstance;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final theme = ref.theme;
    final s = textSearcher;
    final hasMatches = s?.hasMatches == true;
    final inProgress = s?.isSearching == true;

    final resultText = hasMatches
        ? "${(s!.currentIndex ?? 0) + 1} of ${s.matches.length}${inProgress ? '..' : ''}"
        : "0 of 0";

    final canNavigate = hasMatches;

    return Row(
      mainAxisSize: MainAxisSize.min,
      children: [
        if (resultText != "0 of 0")
          CustomText(
            resultText,
            overflow: TextOverflow.ellipsis,
            style: TextStyle(
              fontSize: 14,
              color: canNavigate ? theme.onBackground : theme.onBackground.withValues(alpha: 0.5),
            ),
          ),
        ConstantSizing.rowSpacing(4),
        _NavigationButton(
          onPressed: canNavigate ? () => onNavigateToInstance(false) : null,
          icon: Icons.arrow_back_ios_new_rounded,
          tooltip: "Previous result",
          iconColor: theme.onBackground,
          canNavigate: canNavigate,
        ),
        _NavigationButton(
          onPressed: canNavigate ? () => onNavigateToInstance(true) : null,
          icon: Icons.arrow_forward_ios_rounded,
          tooltip: "Next result",
          iconColor: theme.onBackground,
          canNavigate: canNavigate,
        ),
      ],
    );
  }
}

class _NavigationButton extends StatelessWidget {
  const _NavigationButton({
    required this.onPressed,
    required this.icon,
    required this.tooltip,
    required this.iconColor,
    required this.canNavigate,
  });

  final VoidCallback? onPressed;
  final IconData icon;
  final String tooltip;
  final Color iconColor;
  final bool canNavigate;

  @override
  Widget build(BuildContext context) {
    return IconButton(
      onPressed: onPressed,
      tooltip: tooltip,
      icon: Icon(icon, color: canNavigate ? iconColor : iconColor.withValues(alpha: 0.3)),
      style: const ButtonStyle(tapTargetSize: MaterialTapTargetSize.shrinkWrap),
    );
  }
}
