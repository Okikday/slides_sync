import 'dart:async';
import 'dart:developer';
import 'dart:io';
import 'package:custom_widgets_toolkit/custom_widgets_toolkit.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:iconsax_flutter/iconsax_flutter.dart';
import 'package:slides_sync/core/storage/isar_data/isar_data.dart';
import 'package:slides_sync/core/utils/result.dart';
import 'package:slides_sync/core/utils/ui_utils.dart';
import 'package:slides_sync/domain/models/course_model/sub/course_content.dart';
import 'package:slides_sync/domain/models/file_details.dart';
import 'package:slides_sync/domain/models/progress_track_model.dart';
import 'package:slides_sync/features/all_tabs/tab_library/presentation/views/library_tab_view/library_tab_view_app_bar/build_button.dart';
import 'package:slides_sync/features/all_tabs/tab_library/presentation/views/library_tab_view/library_tab_view_app_bar/library_tab_view_search_button.dart';
import 'package:slides_sync/features/content_viewer/presentation/actions/document_viewer_actions/pdf_document_viewer_actions.dart';
import 'package:slides_sync/features/content_viewer/presentation/views/viewers/document_viewer/document_search_app_bar.dart';
import 'package:slides_sync/shared/common_widgets/app_popup_menu_button.dart';
import 'package:slides_sync/shared/components/app_bar_container.dart';
import 'package:slides_sync/shared/helpers/extension_helper.dart';
import 'package:syncfusion_flutter_pdfviewer/pdfviewer.dart';

class PdfDocumentViewer extends ConsumerStatefulWidget {
  final CourseContent content;
  const PdfDocumentViewer({super.key, required this.content});

  @override
  ConsumerState<PdfDocumentViewer> createState() => _PdfDocumentViewerState();
}

class _PdfDocumentViewerState extends ConsumerState<PdfDocumentViewer> {
  Timer? progressTrackTimer;
  int trackCount = 0;
  late final PdfViewerController pdfViewerController;
  late final ValueNotifier<bool> isSearchingNotifier;
  late final ValueNotifier<bool> isAppBarVisibleNotifier;
  late final ValueNotifier<bool> isOptionsVisibleNotifier;
  bool isUpdatingProgressTrack = false;
  late final ValueNotifier<ProgressTrackModel?> progressTrackNotifier;

  static const _trackInterval = Duration(seconds: 5);

  @override
  void initState() {
    super.initState();
    pdfViewerController = PdfViewerController();
    isSearchingNotifier = ValueNotifier(false);
    isAppBarVisibleNotifier = ValueNotifier(true);
    isOptionsVisibleNotifier = ValueNotifier(false);
    progressTrackNotifier = ValueNotifier(null);
    progressTrackTimer = Timer.periodic(_trackInterval, pageNumberTracker);
    WidgetsBinding.instance.addPostFrameCallback((_) async {
      if (progressTrackNotifier.value != null) return;
      final ProgressTrackModel? progressTrack = await PdfDocumentViewerActions.getLastProgressTrack(widget.content);
      progressTrackNotifier.value = progressTrack;
      if (progressTrack != null) {
        pdfViewerController.jumpToPage(progressTrack.count);
      }
    });
  }

  void pageNumberTracker(Timer timer) async {
    log("This shows up every 5 seconds");
    // if (progressTrackTimer != null && progressTrackTimer!.isActive) return;
    if (isUpdatingProgressTrack) return;
    final progressTrack = progressTrackNotifier.value;
    if (progressTrack == null) return;
    final pageNumber = pdfViewerController.pageNumber;
    if (progressTrack.count == pageNumber) return;
    isUpdatingProgressTrack = true;
    await PdfDocumentViewerActions.updateProgressTrack(
      trackCount > 0
          ? progressTrack.copyWith(
            count: pageNumber,
            progress: (pageNumber / pdfViewerController.pageCount).clamp(0.0, 1.0),
            lastRead: DateTime.now(),
          )
          : progressTrack.copyWith(
            title: widget.content.title,
            description: widget.content.description,
            count: pageNumber,
            progress: (pageNumber / pdfViewerController.pageCount).clamp(0.0, 1.0),
            lastRead: DateTime.now(),
          ),
    ).then(((onValue) => isUpdatingProgressTrack = false), onError: (onValue) => isUpdatingProgressTrack = false);
    trackCount++;
  }

  @override
  void dispose() {
    progressTrackTimer?.cancel();
    pdfViewerController.dispose();
    isSearchingNotifier.dispose();
    isAppBarVisibleNotifier.dispose();
    isOptionsVisibleNotifier.dispose();
    progressTrackNotifier.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final theme = ref.theme;
    final content = widget.content;
    return ValueListenableBuilder(
      valueListenable: isSearchingNotifier,
      builder: (context, value, child) {
        return PopScope(
          canPop: !value,
          onPopInvokedWithResult: (didPop, result) {
            if (value) isSearchingNotifier.value = false;
            SystemChrome.setEnabledSystemUIMode(SystemUiMode.edgeToEdge);
          },
          child: AnnotatedRegion(
            value: UiUtils.getSystemUiOverlayStyle(context.scaffoldBackgroundColor, context.isDarkMode),
            child: Scaffold(
              // extendBodyBehindAppBar: true,
              floatingActionButton: ValueListenableBuilder(
                valueListenable: isAppBarVisibleNotifier,
                builder: (context, value, child) {
                  if (!value) return const SizedBox();
                  return PdfToolsMenu(isOptionsVisibleNotifier: isOptionsVisibleNotifier, isVisible: true);
                },
              ),

              body: NestedScrollView(
                physics: NeverScrollableScrollPhysics(),
                headerSliverBuilder: (context, innerBoxIsScrolled) {
                  return [
                    PinnedHeaderSliver(
                      child: ValueListenableBuilder(
                        valueListenable: isAppBarVisibleNotifier,
                        builder: (context, value, child) {
                          return AnimatedPadding(
                            duration: Durations.extralong1,
                            curve: CustomCurves.defaultIosSpring,
                            padding: EdgeInsets.only(top: value ? context.topPadding : 0),
                            child: AnimatedSize(
                              duration: Durations.extralong1,
                              curve: CustomCurves.defaultIosSpring,
                              child: SizedBox(
                                height: value ? kToolbarHeight + 12 : 0,
                                child: ColoredBox(
                                  color: theme.background,
                                  child: Stack(
                                    alignment: Alignment.center,
                                    children: [
                                      Positioned.fill(
                                        child: AppBarContainerChild(
                                          theme.isDarkTheme,
                                          title: widget.content.title,
                                          padding: EdgeInsets.only(left: 12, right: 8),
                                          trailing: Padding(
                                            padding: const EdgeInsets.only(left: 8.0),
                                            child: Row(
                                              children: [
                                                LibraryTabViewSearchButton(
                                                  backgroundColor: Colors.transparent,
                                                  onTap: () {
                                                    isSearchingNotifier.value = true;
                                                  },
                                                ),
                                                AppPopupMenuButton(
                                                  tooltip: "More options",
                                                  menuPadding: EdgeInsets.only(right: 16),
                                                  actions: [
                                                    PopupMenuAction(
                                                      title: "Share",
                                                      iconData: Icons.share_rounded,
                                                      onTap: () {},
                                                    ),
                                                    PopupMenuAction(
                                                      title: "Print",
                                                      iconData: Iconsax.printer_copy,
                                                      onTap: () {},
                                                    ),
                                                    PopupMenuAction(
                                                      title: "Save",
                                                      iconData: Iconsax.book_saved_copy,
                                                      onTap: () {},
                                                    ),
                                                  ],
                                                ),

                                                // Printing, Share, Save to Google drive
                                              ],
                                            ),
                                          ),
                                        ),
                                      ),

                                      DocumentSearchAppBar(
                                        isSearchingNotifier: isSearchingNotifier,
                                        pdfViewerController: pdfViewerController,
                                      ),
                                    ],
                                  ),
                                ),
                              ),
                            ),
                          );
                        },
                      ),
                    ),
                  ];
                },
                body:
                    content.path.filePath.isNotEmpty
                        ? SfPdfViewer.file(
                          File(content.path.filePath),
                          onTap: (details) async {
                            final bool isSearching = isSearchingNotifier.value;
                            if (isSearching) return;
                            final bool isAppBarVisible = isAppBarVisibleNotifier.value;
                            // isSearchingNotifier.value = false;
                            isAppBarVisibleNotifier.value = !isAppBarVisible;
                            if (isAppBarVisible) {
                              await Future.delayed(Durations.medium1, () {
                                SystemChrome.setEnabledSystemUIMode(SystemUiMode.immersive);
                              });
                            } else {
                              SystemChrome.setEnabledSystemUIMode(SystemUiMode.edgeToEdge);
                            }
                          },
                          controller: pdfViewerController,
                          // scrollDirection: PdfScrollDirection.vertical,
                          // pageLayoutMode: PdfPageLayoutMode.single,
                        )
                        : SfPdfViewer.network(content.path.urlPath),
              ),
            ),
          ),
        );
      },
    );
  }
}

class PdfToolsMenu extends ConsumerWidget {
  final ValueNotifier<bool> isOptionsVisibleNotifier;
  final bool isVisible;
  const PdfToolsMenu({super.key, required this.isOptionsVisibleNotifier, required this.isVisible});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    return AnimatedContainer(
      duration: Durations.extralong1,
      curve: CustomCurves.defaultIosSpring,
      height: 72,
      padding: EdgeInsets.symmetric(horizontal: 16),
      // constraints: BoxConstraints(maxWidth: context.deviceWidth - 40),
      decoration: BoxDecoration(color: ref.theme.background, borderRadius: BorderRadius.circular(100)),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          ValueListenableBuilder(
            valueListenable: isOptionsVisibleNotifier,
            builder: (context, value, child) {
              return AnimatedSize(
                duration: Durations.extralong1,
                curve: CustomCurves.defaultIosSpring,
                child: SizedBox(
                  width: value ? null : 0,
                  child: ListView(
                    shrinkWrap: true,
                    scrollDirection: Axis.horizontal,
                    children:
                        [
                          BuildButton(onTap: () {}, iconData: Iconsax.setting_copy),
                          BuildButton(onTap: () {}, iconData: Iconsax.edit_copy),
                          BuildButton(onTap: () {}, iconData: Iconsax.search_normal_copy),
                        ].map((e) => Padding(padding: EdgeInsets.only(right: 16), child: e)).toList(),
                  ),
                ),
              );
            },
          ),
          InkWell(
            customBorder: CircleBorder(),
            onTap: () {
              final bool isOptionsVisible = isOptionsVisibleNotifier.value;
              isOptionsVisibleNotifier.value = !isOptionsVisible;
            },
            child: SizedBox(width: 72 - 32, child: Icon(Iconsax.menu_copy)),
          ),
        ],
      ),
    );
  }
}
