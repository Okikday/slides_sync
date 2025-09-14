import 'dart:developer';

import 'package:custom_widgets_toolkit/custom_widgets_toolkit.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:pdfrx/pdfrx.dart';

class PdfDocSearchActions {
  late final FocusNode focusNode;
  late final TextEditingController searchController;
  late final ValueNotifier<bool> isSearchInProgressNotifier;

  final ValueNotifier<bool> isSearchingNotifier;
  final PdfViewerController pdfViewerController;

  final void Function() onStateChanged;

  PdfTextSearcher? textSearcher;
  BuildContext? _context;

  PdfDocSearchActions({
    required BuildContext context,
    required this.isSearchingNotifier,
    required this.pdfViewerController,
    required this.onStateChanged,
  }) {
    _context = context;
    focusNode = FocusNode();
    searchController = TextEditingController();
    isSearchInProgressNotifier = ValueNotifier<bool>(false);

    isSearchingNotifier.addListener(_onSearchModeChanged);
  }


  void updateTextSearcher(PdfTextSearcher? searcher) {
    textSearcher = searcher;
  }

  void _onSearchModeChanged() {
    if (isSearchingNotifier.value) {
      focusNode.requestFocus();
    } else {
      clearSearch();
    }
  }

  void _onSearcherChanged() {
    final s = textSearcher;
    if (_context == null || !(_context as Element).mounted || s == null) return;

    isSearchInProgressNotifier.value = s.isSearching;

    if (!s.isSearching && !s.hasMatches) {
      _showNoResultsMessage();
    }

    onStateChanged();
  }

  void performSearch(String searchText) {
    final text = searchText.trim();
    if (text.isEmpty) return;

    if (searchText == textSearcher?.pattern.toString()) {
      Future.microtask(() async {
        await navigateToInstance(true);
      });
      return;
    }

    final old = textSearcher;
    if (old != null) {
      old.removeListener(_onSearcherChanged);
      old.dispose();
    }

    final searcher = PdfTextSearcher(pdfViewerController);
    textSearcher = searcher;
    textSearcher = searcher;

    searcher.addListener(_onSearcherChanged);

    searcher.startTextSearch(text, caseInsensitive: true, goToFirstMatch: true, searchImmediately: kIsWeb);

    isSearchInProgressNotifier.value = searcher.isSearching;

    if (kIsWeb && !searcher.isSearching && !searcher.hasMatches) {
      _showNoResultsMessage();
    }

    onStateChanged();
  }

  void clearSearch() {
    searchController.clear();

    final s = textSearcher;
    if (s != null) {
      s.removeListener(_onSearcherChanged);
      s.dispose();
      textSearcher = null;
    }

    isSearchInProgressNotifier.value = false;
    onStateChanged();
  }

  void _showNoResultsMessage() {
    if (_context == null || !(_context as Element).mounted) return;
    ScaffoldMessenger.of(_context!).showSnackBar(
      SnackBar(
        content: Text('No results found for "${searchController.text}"'),
        duration: const Duration(seconds: 2),
        behavior: SnackBarBehavior.floating,
      ),
    );
  }

  Future<void> navigateToInstance(bool isNext) async {
    final s = textSearcher;
    if (s == null || !s.hasMatches) return;

    final currentIndex = s.currentIndex ?? 0;
    final total = s.matches.length;

    if (isNext && currentIndex == total - 1 && !s.isSearching) {
      _showSearchFromBeginningDialog();
      return;
    }

    if (isNext) {
      await s.goToNextMatch();
    } else {
      await s.goToPrevMatch();
    }

    onStateChanged();
  }

  void _showSearchFromBeginningDialog() {
    if (_context == null) return;
    showDialog(
      context: _context!,
      builder:
          (context) => AlertDialog(
            title: const Text('Search Result'),
            content: const Text('No more occurrences found. Would you like to continue searching from the beginning?'),
            actions: [
              TextButton(
                onPressed: () async {
                  Navigator.of(context).pop();
                  final s = textSearcher;
                  if (s == null) return;
                  await s.goToMatchOfIndex(0);
                  onStateChanged();
                },
                child: const Text('YES'),
              ),
              TextButton(onPressed: () => Navigator.of(context).pop(), child: const Text('NO')),
            ],
          ),
    );
  }

  void dispose() {
    focusNode.dispose();
    searchController.dispose();
    final s = textSearcher;
    if (s != null) {
      s.removeListener(_onSearcherChanged);
      s.dispose();
    }
    isSearchInProgressNotifier.dispose();
    isSearchingNotifier.removeListener(_onSearchModeChanged);
    log("Disposed pdf search actions ");
  }
}
