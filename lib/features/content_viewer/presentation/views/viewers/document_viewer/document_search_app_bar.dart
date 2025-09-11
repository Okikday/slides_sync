import 'package:custom_widgets_toolkit/custom_widgets_toolkit.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:slides_sync/shared/components/app_bar_container.dart';
import 'package:slides_sync/shared/helpers/extension_helper.dart';
import 'package:slides_sync/shared/styles/theme/app_theme_model.dart';
import 'package:syncfusion_flutter_pdfviewer/pdfviewer.dart';

// AI GENERATED -TO EDIT
class DocumentSearchAppBar extends ConsumerStatefulWidget {
  const DocumentSearchAppBar({super.key, required this.isSearchingNotifier, required this.pdfViewerController});

  final ValueNotifier<bool> isSearchingNotifier;
  final PdfViewerController pdfViewerController;

  @override
  ConsumerState<DocumentSearchAppBar> createState() => _DocumentSearchAppBarState();
}

class _DocumentSearchAppBarState extends ConsumerState<DocumentSearchAppBar> {
  late final FocusNode focusNode;
  late final TextEditingController searchController;
  late final ValueNotifier<PdfTextSearchResult?> searchResultNotifier;
  late final ValueNotifier<bool> isSearchInProgressNotifier;

  @override
  void initState() {
    super.initState();
    focusNode = FocusNode();
    searchController = TextEditingController();
    searchResultNotifier = ValueNotifier<PdfTextSearchResult?>(null);
    isSearchInProgressNotifier = ValueNotifier<bool>(false);

    widget.isSearchingNotifier.addListener(_onSearchModeChanged);
  }

  void _onSearchModeChanged() {
    if (widget.isSearchingNotifier.value) {
      focusNode.requestFocus();
    } else {
      _clearSearch();
    }
  }

  void _onSearchResultChanged() {
    final result = searchResultNotifier.value;
    if (!mounted || result == null) return;

    isSearchInProgressNotifier.value = !result.isSearchCompleted;

    if (result.isSearchCompleted && !result.hasResult && result.totalInstanceCount == 0) {
      _showNoResultsMessage();
    }
  }

  void _performSearch(String searchText) {
    final text = searchText.trim();
    if (text.isEmpty) return;

    isSearchInProgressNotifier.value = true;

    // Clear previous search
    final oldResult = searchResultNotifier.value;
    oldResult?.removeListener(_onSearchResultChanged);
    oldResult?.clear();

    // Start new search
    final newResult = widget.pdfViewerController.searchText(text);
    searchResultNotifier.value = newResult;

    if (kIsWeb) {
      isSearchInProgressNotifier.value = false;
      if (newResult.totalInstanceCount == 0) {
        _showNoResultsMessage();
      }
    } else {
      newResult.addListener(_onSearchResultChanged);
    }
  }

  void _clearSearch() {
    searchController.clear();
    final result = searchResultNotifier.value;
    result?.removeListener(_onSearchResultChanged);
    result?.clear();
    searchResultNotifier.value = null;
    isSearchInProgressNotifier.value = false;
  }

  void _showNoResultsMessage() {
    if (!mounted) return;
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text('No results found for "${searchController.text}"'),
        duration: const Duration(seconds: 2),
        behavior: SnackBarBehavior.floating,
      ),
    );
  }

  void _navigateToInstance(bool isNext) {
    final result = searchResultNotifier.value;
    if (result?.hasResult != true) return;

    if (isNext && result!.currentInstanceIndex == result.totalInstanceCount && result.isSearchCompleted) {
      _showSearchFromBeginningDialog();
    } else {
      isNext ? result!.nextInstance() : result!.previousInstance();
      setState(() {
        
      });
      // Trigger rebuild by reassigning the same value
      searchResultNotifier.value = searchResultNotifier.value;
    }
  }

  void _showSearchFromBeginningDialog() {
    showDialog(
      context: context,
      builder:
          (context) => AlertDialog(
            title: const Text('Search Result'),
            content: const Text('No more occurrences found. Would you like to continue searching from the beginning?'),
            actions: [
              TextButton(
                onPressed: () {
                  Navigator.of(context).pop();
                  final result = searchResultNotifier.value;
                  result?.nextInstance();
                  searchResultNotifier.value = searchResultNotifier.value;
                },
                child: const Text('YES'),
              ),
              TextButton(onPressed: () => Navigator.of(context).pop(), child: const Text('NO')),
            ],
          ),
    );
  }

  @override
  void dispose() {
    focusNode.dispose();
    searchController.dispose();
    final result = searchResultNotifier.value;
    result?.removeListener(_onSearchResultChanged);
    result?.clear();
    searchResultNotifier.dispose();
    isSearchInProgressNotifier.dispose();
    widget.isSearchingNotifier.removeListener(_onSearchModeChanged);
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final AppThemeModel theme = ref.theme;

    return ValueListenableBuilder(
      valueListenable: widget.isSearchingNotifier,
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
                          focusNode.unfocus();
                          widget.isSearchingNotifier.value = false;
                        },
                      ),
                      ConstantSizing.rowSpacing(4),
                      Expanded(child: _buildSearchField(theme)),
                      ConstantSizing.rowSpacing(8),

                      ValueListenableBuilder(
                        valueListenable: isSearchInProgressNotifier,
                        builder: (context, isInProgress, _) {
                          if (!isInProgress) return const SizedBox.shrink();
                          return SizedBox(
                            width: 16,
                            height: 16,
                            child: CircularProgressIndicator(strokeWidth: 2, color: theme.primaryColor),
                          );
                        },
                      ),

                      _buildNavigationControls(theme),
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

  Widget _buildSearchField(AppThemeModel theme) {
    return ClipRSuperellipse(
      borderRadius: BorderRadius.circular(10.0),
      child: CustomTextfield(
        autoDispose: false,
        controller: searchController,
        focusNode: focusNode,
        hint: "Search in document...",
        onTapOutside: () {},
        onSubmitted: _performSearch,
        onchanged: (text) {
          if (text.isEmpty) _clearSearch();
        },
        suffixIcon: ValueListenableBuilder(
          valueListenable: searchController,
          builder: (context, controller, _) {
            if (controller.text.isEmpty) return const SizedBox.shrink();
            return InkWell(
              customBorder: CircleBorder(),
              onTap: _clearSearch,
              child: CircleAvatar(radius: 13, backgroundColor: theme.supportingText.withAlpha(20), child: Icon(Icons.cancel_rounded)));
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

  Widget _buildNavigationControls(dynamic theme) {
    return ValueListenableBuilder(
      valueListenable: searchResultNotifier,
      builder: (context, result, _) {
        return ValueListenableBuilder(
          valueListenable: isSearchInProgressNotifier,
          builder: (context, isInProgress, _) {
            final canNavigate = result?.hasResult == true && !isInProgress;
            final resultText =
                result?.hasResult == true
                    ? "${result!.currentInstanceIndex} of ${result.totalInstanceCount}"
                    : "0 of 0";

            return Row(
              mainAxisSize: MainAxisSize.min,
              children: [
               if(resultText != "0 of 0") CustomText(
                  resultText,
                  overflow: TextOverflow.ellipsis,
                  style: TextStyle(
                    fontSize: 14,
                    color: canNavigate ? theme.onBackground : theme.onBackground.withOpacity(0.5),
                  ),
                ),
                ConstantSizing.rowSpacing(4),
                _buildNavigationButton(
                  onPressed: canNavigate ? () => _navigateToInstance(false) : null,
                  icon: Icons.arrow_back_ios_new_rounded,
                  tooltip: "Previous result",
                  theme: theme,
                  canNavigate: canNavigate,
                ),
                _buildNavigationButton(
                  onPressed: canNavigate ? () => _navigateToInstance(true) : null,
                  icon: Icons.arrow_forward_ios_rounded,
                  tooltip: "Next result",
                  theme: theme,
                  canNavigate: canNavigate,
                ),
              ],
            );
          },
        );
      },
    );
  }

  Widget _buildNavigationButton({
    required VoidCallback? onPressed,
    required IconData icon,
    required String tooltip,
    required dynamic theme,
    required bool canNavigate,
  }) {
    return IconButton(
      onPressed: onPressed,
      tooltip: tooltip,
      icon: Icon(icon, color: canNavigate ? theme.onBackground : theme.onBackground.withOpacity(0.3)),
      style: const ButtonStyle(tapTargetSize: MaterialTapTargetSize.shrinkWrap),
    );
  }
}
