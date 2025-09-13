import 'package:custom_widgets_toolkit/custom_widgets_toolkit.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:slides_sync/features/content_viewer/presentation/actions/document_viewer_actions/pdf_doc_search_actions.dart';
import 'package:slides_sync/shared/components/app_bar_container.dart';
import 'package:slides_sync/shared/helpers/extension_helper.dart';
import 'package:slides_sync/shared/styles/theme/app_theme_model.dart';
import 'package:pdfrx/pdfrx.dart';

class PdfDocSearchAppBar extends ConsumerStatefulWidget {
  const PdfDocSearchAppBar({super.key, required this.pdfViewerController, required this.pdsa});

  final PdfViewerController pdfViewerController;
  final PdfDocSearchActions pdsa;

  @override
  ConsumerState<PdfDocSearchAppBar> createState() => _PdfDocSearchAppBarState();
}

class _PdfDocSearchAppBarState extends ConsumerState<PdfDocSearchAppBar> {
  @override
  Widget build(BuildContext context) {
    final AppThemeModel theme = ref.theme;
    final pdsa = widget.pdsa;

    return ValueListenableBuilder(
      valueListenable: pdsa.isSearchingNotifier,
      builder: (context, isSearching, _) {
        return AnimatedSize(
          duration: Durations.extralong1,
          curve: CustomCurves.defaultIosSpring,
          child: ClipRRect(
            child: SizedBox(
              height: isSearching ? null : 0,
              child: ColoredBox(
                color: theme.background,
                child: Padding(
                  padding: const EdgeInsets.only(left: 12, right: 8),
                  child: Row(
                    children: [
                      AppBackButton(
                        onPressed: () {
                          pdsa.focusNode.unfocus();
                          pdsa.isSearchingNotifier.value = false;
                        },
                      ),
                      ConstantSizing.rowSpacing(4),
                      Expanded(child: _SearchField(pdsa: pdsa)),
                      ConstantSizing.rowSpacing(8),
                      ValueListenableBuilder(
                        valueListenable: pdsa.isSearchInProgressNotifier,
                        builder: (context, isInProgress, _) {
                          if (!isInProgress) return const SizedBox.shrink();
                          return SizedBox(
                            width: 16,
                            height: 16,
                            child: CircularProgressIndicator(strokeWidth: 2, color: theme.primaryColor),
                          );
                        },
                      ),
                      
                    ],
                  ),
                ),
              ),
            ),
          ),
        );
      },
    );
  }
}

class _SearchField extends ConsumerWidget {
  const _SearchField({required this.pdsa});

  final PdfDocSearchActions pdsa;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final theme = ref.theme;
    return ClipRSuperellipse(
      borderRadius: BorderRadius.circular(10.0),
      child: CustomTextfield(
        autoDispose: false,
        controller: pdsa.searchController,
        focusNode: pdsa.focusNode,
        hint: "Search in document...",
        textInputAction: pdsa.textSearcher == null ? TextInputAction.search : TextInputAction.next,
        onTapOutside: () {},
        onSubmitted: pdsa.performSearch,
        onchanged: (text) {
          if (text.isEmpty) pdsa.clearSearch();
        },
        suffixIcon: ValueListenableBuilder(
          valueListenable: pdsa.searchController,
          builder: (context, controller, _) {
            if (controller.text.isEmpty) return const SizedBox.shrink();
            return InkWell(
              customBorder: CircleBorder(),
              onTap: pdsa.clearSearch,
              child: CircleAvatar(
                radius: 13,
                backgroundColor: theme.supportingText.withAlpha(20),
                child: Icon(Icons.cancel_rounded),
              ),
            );
          },
        ),
        alwaysShowSuffixIcon: true,
        inputContentPadding: const EdgeInsets.symmetric(horizontal: 12.0, vertical: 0),
        inputTextStyle: TextStyle(fontSize: 15, color: theme.onBackground),
        cursorColor: theme.primaryColor,
        selectionHandleColor: theme.primaryColor,
        backgroundColor: Colors.transparent,
        border: UnderlineInputBorder(borderSide: BorderSide(color: theme.primaryColor)),
      ),
    );
  }
}

