import 'dart:developer';

import 'package:custom_widgets_toolkit/custom_widgets_toolkit.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:iconsax_flutter/iconsax_flutter.dart';
import 'package:pdfx/pdfx.dart';
import 'package:slides_sync/core/utils/ui_utils.dart';
import 'package:slides_sync/domain/models/course_model/sub/course_content.dart';
import 'package:slides_sync/domain/models/file_details.dart';
import 'package:slides_sync/shared/components/app_bar_container.dart';
import 'package:slides_sync/shared/helpers/extension_helper.dart';
import 'package:slides_sync/shared/styles/colors.dart';

class DocumentViewer extends ConsumerStatefulWidget {
  final CourseContent content;
  const DocumentViewer({super.key, required this.content});

  @override
  ConsumerState<DocumentViewer> createState() => _DocumentViewerState();
}

class _DocumentViewerState extends ConsumerState<DocumentViewer> {
  PdfController? pdfController;
  int currentPage = 1;
  int totalPages = 0;
  bool isLoading = true;

  @override
  void initState() {
    super.initState();
    _initializePdf();
  }

  void _initializePdf() async {
    try {
      final String pathToDoc = widget.content.path.fileDetails.filePath;
      pdfController = PdfController(document: PdfDocument.openFile(pathToDoc), initialPage: 1);

      // Get total pages
      final doc = await PdfDocument.openFile(pathToDoc);
      totalPages = doc.pagesCount;
      await doc.close();

      setState(() {
        isLoading = false;
      });
    } catch (e) {
      log('Error loading PDF: $e');
      setState(() {
        isLoading = false;
      });
    }
  }

  @override
  void dispose() {
    pdfController?.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return AnnotatedRegion(
      value: UiUtils.getSystemUiOverlayStyle(context.scaffoldBackgroundColor, context.isDarkMode),
      child: Scaffold(
        appBar: AppBarContainer(
          appBarHeight: kToolbarHeight + 12,
          padding: EdgeInsets.zero,
          scaffoldBgColor: ref.theme.altBackgroundPrimary.withValues(alpha: 0.4),
          child: Stack(
            children: [
              Positioned.fill(
                child: LinearProgressIndicator(
                  color: ref.theme.primary.withAlpha(20),
                  value: totalPages > 0 ? currentPage / totalPages : 0.0,
                  backgroundColor: Colors.transparent,
                ),
              ),
              Positioned.fill(
                child: AppBarContainerChild(
                  context.isDarkMode,
                  title: "${widget.content.title} ($currentPage/$totalPages)",
                ),
              ),
            ],
          ),
        ),
    
        floatingActionButton: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            FloatingActionButton(
              heroTag: "menu",
              onPressed: () {
                _showPageNavigator(context);
              },
              shape: const CircleBorder(),
              child: Icon(Iconsax.menu, color: ref.theme.onBackground),
            ),
            const SizedBox(height: 8),
            FloatingActionButton(
              heroTag: "zoom",
              onPressed: () {},
              shape: const CircleBorder(),
              mini: true,
              child: Icon(Iconsax.maximize_4, color: ref.theme.onBackground),
            ),
          ],
        ),

        body:
            isLoading
                ? Center(
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      CircularProgressIndicator(color: ref.theme.primary),
                      const SizedBox(height: 16),
                      CustomText("Loading document...", color: ref.theme.onBackground),
                    ],
                  ),
                )
                : pdfController == null
                ? Center(
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Icon(Iconsax.document, size: 64, color: ref.theme.onBackground.withValues(alpha: 0.3)),
                      const SizedBox(height: 16),
                      CustomText("Failed to load document", color: ref.theme.onBackground),
                    ],
                  ),
                )
                : PdfView(
                  controller: pdfController!,
                  onPageChanged: (page) {
                    setState(() {
                      currentPage = page;
                    });
                  },
                  onDocumentLoaded: (document) {
                    setState(() {
                      totalPages = document.pagesCount;
                    });
                  },
                  scrollDirection: Axis.vertical,
                  physics: const BouncingScrollPhysics(),
                ),
      ),
    );
  }

  void _showPageNavigator(BuildContext context) {
    showModalBottomSheet(
      context: context,
      backgroundColor: ref.theme.altBackgroundPrimary,
      shape: const RoundedRectangleBorder(borderRadius: BorderRadius.vertical(top: Radius.circular(20))),
      builder:
          (context) => Container(
            padding: const EdgeInsets.all(20),
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                Container(
                  width: 40,
                  height: 4,
                  decoration: BoxDecoration(
                    color: ref.theme.onBackground.withValues(alpha: 0.3),
                    borderRadius: BorderRadius.circular(2),
                  ),
                ),
                const SizedBox(height: 20),
                CustomText("Navigate to Page", color: ref.theme.onBackground),
                const SizedBox(height: 20),
                Row(
                  children: [
                    Expanded(
                      child: TextField(
                        keyboardType: TextInputType.number,
                        decoration: InputDecoration(
                          hintText: "Page number (1-$totalPages)",
                          border: OutlineInputBorder(borderRadius: BorderRadius.circular(12)),
                        ),
                        onSubmitted: (value) {
                          final page = int.tryParse(value);
                          if (page != null && page >= 1 && page <= totalPages) {
                            pdfController?.animateToPage(
                              page,
                              duration: const Duration(milliseconds: 300),
                              curve: Curves.easeInOut,
                            );
                            Navigator.pop(context);
                          }
                        },
                      ),
                    ),
                    const SizedBox(width: 12),
                    ElevatedButton(
                      onPressed: () => Navigator.pop(context),
                      style: ElevatedButton.styleFrom(
                        backgroundColor: ref.theme.primary,
                        foregroundColor: Colors.white,
                        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
                      ),
                      child: const Text("Go"),
                    ),
                  ],
                ),
                const SizedBox(height: 20),
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                  children: [
                    _NavigationButton(
                      icon: Iconsax.arrow_left_2,
                      label: "Previous",
                      onPressed:
                          currentPage > 1
                              ? () {
                                pdfController?.previousPage(
                                  duration: const Duration(milliseconds: 300),
                                  curve: Curves.easeInOut,
                                );
                                Navigator.pop(context);
                              }
                              : null,
                    ),
                    _NavigationButton(
                      icon: Iconsax.arrow_right_3,
                      label: "Next",
                      onPressed:
                          currentPage < totalPages
                              ? () {
                                pdfController?.nextPage(
                                  duration: const Duration(milliseconds: 300),
                                  curve: Curves.easeInOut,
                                );
                                Navigator.pop(context);
                              }
                              : null,
                    ),
                  ],
                ),
              ],
            ),
          ),
    );
  }
}

class _NavigationButton extends ConsumerWidget {
  final IconData icon;
  final String label;
  final VoidCallback? onPressed;

  const _NavigationButton({required this.icon, required this.label, this.onPressed});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final theme = ref.theme;
    return ElevatedButton.icon(
      onPressed: onPressed,
      icon: Icon(icon, size: 18),
      label: Text(label),
      style: ElevatedButton.styleFrom(
        backgroundColor: theme.primary.withValues(alpha: 0.1),
        foregroundColor: theme.primary,
        elevation: 0,
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12),
        ),
      ),
    );
  }
}