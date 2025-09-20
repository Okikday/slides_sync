import 'package:custom_widgets_toolkit/custom_widgets_toolkit.dart';
import 'package:flutter/material.dart';
import 'package:flutter_animate/flutter_animate.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:slides_sync/features/content_viewer/presentation/controllers/doc_viewer_controllers/pdf_doc_search_controller.dart';
import 'package:slides_sync/features/content_viewer/presentation/controllers/doc_viewer_controllers/pdf_doc_viewer_controller.dart';
import 'package:slides_sync/features/content_viewer/presentation/views/viewers/pdf_doc_viewer/pdf_doc_app_bar/pdf_doc_normal_app_bar.dart';
import 'package:slides_sync/features/content_viewer/presentation/views/viewers/pdf_doc_viewer/pdf_doc_app_bar/pdf_doc_search_app_bar.dart';
import 'package:slides_sync/shared/helpers/extension_helper.dart';

class PdfDocViewerAppBar extends ConsumerWidget {
  final PdfDocViewerController pdva;
  final PdfDocSearchController pdsa;
  final String title;
  const PdfDocViewerAppBar({super.key, required this.pdva, required this.pdsa, required this.title});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    return ValueListenableBuilder(
      valueListenable: pdva.isAppBarVisibleNotifier,
      builder: (context, value, child) {
        return AnimatedContainer(
          curve: CustomCurves.defaultIosSpring,
          duration: Durations.extralong1,
          margin: EdgeInsets.only(top: value ? context.topPadding : 0),
          height: value ? kToolbarHeight + 12 : 0,
          child: Stack(
            alignment: Alignment.center,
            children: [
              PdfDocSearchAppBar(pdfViewerController: pdva.pdfViewerController, pdsa: pdsa),
              PdfDocNormalAppBar(title: title, isSearchingNotifier: pdsa.isSearchingNotifier),
            ],
          ),
        );
      },
    );
  }
}
