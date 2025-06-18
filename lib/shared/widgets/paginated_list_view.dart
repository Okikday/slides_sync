// ignore_for_file: unintended_html_in_doc_comment

import 'dart:async';
import 'dart:collection';
import 'package:flutter/material.dart';

/// A “page response” from your API (or local DB).
/// - `items` is the list of fetched items.
/// - `nextPageKey` is the key to fetch the next page (null if no more pages).
class PageResponse<KeyType, ItemType> {
  final List<ItemType> items;
  final KeyType? nextPageKey;

  PageResponse({required this.items, required this.nextPageKey});
}

/// Controller that holds the state of pagination:
///   • loadedItems: UnmodifiableListView<ItemType>
///   • isLoading, hasError, isLastPage
///   • Exposes: addPageRequestListener, appendPage, appendLastPage, setError, refresh, loadNext, dispose.
///
/// Usage:
///   final controller = PaginatorController<int, MyModel>(firstPageKey: 0, pageSize: 20);
///
///   controller.addPageRequestListener((pageKey) async {
///     try {
///       final response = await fetchPageFromApi(pageKey, controller.pageSize);
///       if (response.nextPageKey != null) {
///         controller.appendPage(response.items, response.nextPageKey);
///       } else {
///         controller.appendLastPage(response.items);
///       }
///     } catch (e) {
///       controller.setError(e);
///     }
///   });
///
///   // In your widget:
///   PagedListView<int, MyModel>(
///     controller: controller,
///     enablePullToRefresh: true,
///     builderDelegate: PagedChildBuilderDelegate<MyModel>(
///       itemBuilder: (ctx, item, idx) => ListTile(title: Text(item.title)),
///       firstPageErrorIndicatorBuilder: (_) => Center(child: Text("Error loading first page")),
///       noItemsFoundIndicatorBuilder: (_) => Center(child: Text("No items found")),
///       newPageProgressIndicatorBuilder: (_) => Padding(
///         padding: const EdgeInsets.all(16),
///         child: Center(child: CircularProgressIndicator()),
///       ),
///       newPageErrorIndicatorBuilder: (ctx, retry) => Padding(
///         padding: const EdgeInsets.all(16),
///         child: Column(
///           mainAxisSize: MainAxisSize.min,
///           children: [
///             const Text("Failed to load more items."),
///             const SizedBox(height: 8),
///             ElevatedButton(onPressed: retry, child: const Text("Retry")),
///           ],
///         ),
///       ),
///     ),
///   );
///
///   // To refresh:
///   await controller.refresh(); // returns when first page is done (success or error)
///
///   // To manually load next:
///   await controller.loadNext();
///
///   // Dispose when done (e.g. in State.dispose()):
///   controller.dispose();
///
class PaginatorController<KeyType, ItemType> extends ChangeNotifier {
  final KeyType firstPageKey;
  int pageSize;

  final List<ItemType> _rawItems = [];
  late UnmodifiableListView<ItemType> _itemsView;

  bool _isLoading = false;
  Object? _error;
  KeyType? _nextPageKey;

  Future<void> Function(KeyType pageKey)? _pageRequestListener;

  bool _disposed = false;
  Completer<void>? _ongoingLoadCompleter;

  /// Construct with an initial page key (e.g. 0 or “cursor_…”)
  /// and a default pageSize (20 if not provided).
  PaginatorController({required this.firstPageKey, this.pageSize = 20}) {
    _nextPageKey = firstPageKey;
    _itemsView = UnmodifiableListView(_rawItems);
  }

  /// An unmodifiable view of all items fetched so far.
  UnmodifiableListView<ItemType> get loadedItems => _itemsView;

  /// True if a page request is in progress.
  bool get isLoading => _isLoading;

  /// True if the last page request resulted in an error.
  bool get hasError => _error != null;

  /// If `hasError == true`, this is the thrown error.
  Object? get error => _error;

  /// True if there are no more pages left (i.e. nextPageKey == null).
  bool get isLastPage => _nextPageKey == null && !_isLoading;

  /// Whether to show a “load more” footer in the UI.
  bool get shouldShowFooter {
    return _rawItems.isNotEmpty && !_isLoading && !hasError && !isLastPage;
  }

  /// Total number of items fetched so far.
  int get itemCount => _rawItems.length;

  /// Register your async listener that will be called when we need a new page.
  /// The function you supply must be `Future<void> Function(KeyType)`.
  /// Inside it, call `appendPage(...)`, `appendLastPage(...)`, or `setError(...)`.
  void addPageRequestListener(Future<void> Function(KeyType pageKey) listener) {
    if (_disposed) return;
    _pageRequestListener = listener;
  }

  /// Append one more page when there IS another page after this.
  /// Never call this if there is no next page.
  /// - `newItems` can be empty or non-empty.
  /// - `nextKey` is the key for the following page (null ⇒ last page).
  void appendPage(List<ItemType> newItems, KeyType? nextKey) {
    if (_disposed || !_isLoading) return;

    _rawItems.addAll(newItems);
    _itemsView = UnmodifiableListView(_rawItems);
    _nextPageKey = nextKey;
    _error = null;
    _isLoading = false;
    _completeOngoingLoad();
    _safeNotify();
  }

  /// Append the final page (no more pages afterwards).
  void appendLastPage(List<ItemType> newItems) {
    if (_disposed || !_isLoading) return;

    _rawItems.addAll(newItems);
    _itemsView = UnmodifiableListView(_rawItems);
    _nextPageKey = null; // no more pages
    _error = null;
    _isLoading = false;
    _completeOngoingLoad();
    _safeNotify();
  }

  /// If fetching failed, call this to set the error state.
  void setError(Object error) {
    if (_disposed || !_isLoading) return;

    _error = error;
    _isLoading = false;
    _completeOngoingLoad();
    _safeNotify();
  }

  /// Public: Request loading the next page. Returns a Future that completes
  /// when that page either succeeds or fails. If already loading or we’re on
  /// the last page, it returns the existing `_ongoingLoadCompleter` (or a
  /// completed future if no load is in flight).
  Future<void> loadNext() {
    if (_disposed) {
      return Future.value();
    }
    if (_isLoading) {
      return _ongoingLoadCompleter?.future ?? Future.value();
    }
    if (_nextPageKey == null) {
      // no more pages ⇒ complete immediately
      return Future.value();
    }
    // Begin a new load cycle
    _isLoading = true;
    _error = null;
    _ongoingLoadCompleter = Completer<void>();
    _safeNotify();

    final listener = _pageRequestListener;
    if (listener == null) {
      setError(Exception("PaginatorController: no listener registered."));
      return _ongoingLoadCompleter!.future;
    }

    // Attempt to call listener; catch synchronous errors:
    Future<void> listenerFuture;
    try {
      listenerFuture = listener(_nextPageKey as KeyType);
    } catch (e) {
      setError(e);
      return _ongoingLoadCompleter!.future;
    }

    // If the listener returned a Future, catch any async errors:
    listenerFuture.catchError((e) {
      setError(e);
    });
    // We don't await it here; appendPage / setError will complete the Completer
    return _ongoingLoadCompleter!.future;
  }

  /// Public: Refresh from scratch. Clears existing items and reloads first page.
  /// Returns a Future that completes once the first‐page load finishes.
  Future<void> refresh() {
    if (_disposed) return Future.value();

    if (_isLoading) {
      // If already loading, just return that future
      return _ongoingLoadCompleter?.future ?? Future.value();
    }

    // Reset everything
    _rawItems.clear();
    _itemsView = UnmodifiableListView(_rawItems);
    _nextPageKey = firstPageKey;
    _error = null;
    _isLoading = false;
    _safeNotify();

    // Now load the first page
    return loadNext();
  }

  void _completeOngoingLoad() {
    if (_ongoingLoadCompleter != null && !_ongoingLoadCompleter!.isCompleted) {
      _ongoingLoadCompleter!.complete();
      _ongoingLoadCompleter = null;
    }
  }

  void _safeNotify() {
    if (!_disposed && hasListeners) {
      notifyListeners();
    }
  }

  @override
  void dispose() {
    _disposed = true;
    _pageRequestListener = null;
    _ongoingLoadCompleter?.complete();
    super.dispose();
  }
}

/// Builder callbacks for PagedListView:
///
/// • itemBuilder: builds each item widget.
/// • firstPageErrorIndicatorBuilder: if the very first page failed (and no items yet), build this.
/// • noItemsFoundIndicatorBuilder: if first page returned zero items, build this.
/// • newPageProgressIndicatorBuilder: footer while loading subsequent pages.
/// • newPageErrorIndicatorBuilder: footer when a subsequent page fails, with a retry callback.
class PagedChildBuilderDelegate<ItemType> {
  final Widget Function(BuildContext, ItemType, int) itemBuilder;
  final Widget Function(BuildContext)? firstPageErrorIndicatorBuilder;
  final Widget Function(BuildContext)? noItemsFoundIndicatorBuilder;
  final Widget Function(BuildContext)? newPageProgressIndicatorBuilder;
  final Widget Function(BuildContext, VoidCallback retry)? newPageErrorIndicatorBuilder;

  PagedChildBuilderDelegate({
    required this.itemBuilder,
    this.firstPageErrorIndicatorBuilder,
    this.noItemsFoundIndicatorBuilder,
    this.newPageProgressIndicatorBuilder,
    this.newPageErrorIndicatorBuilder,
  });
}

/// A ListView that listens to a [PaginatorController] and automatically:
///  • Shows loading/error/empty states for the first page.
///  • Shows a “loading more” spinner or “retry” footer at bottom for subsequent pages.
///  • Triggers `controller.loadNext()` when scrolled within [scrollThreshold].
///  • Optionally wraps in a RefreshIndicator if [enablePullToRefresh] is true.
class PagedListView<KeyType, ItemType> extends StatefulWidget {
  final PaginatorController<KeyType, ItemType> controller;
  final PagedChildBuilderDelegate<ItemType> builderDelegate;
  final double scrollThreshold;
  final bool enablePullToRefresh;

  const PagedListView({
    super.key,
    required this.controller,
    required this.builderDelegate,
    this.scrollThreshold = 200.0,
    this.enablePullToRefresh = false,
  });

  @override
  State<PagedListView<KeyType, ItemType>> createState() => _PagedListViewState<KeyType, ItemType>();
}

class _PagedListViewState<KeyType, ItemType> extends State<PagedListView<KeyType, ItemType>> {
  late final ScrollController _scrollController;
  bool _initialTriggered = false;

  @override
  void initState() {
    super.initState();
    _scrollController = ScrollController();
    _scrollController.addListener(_onScroll);

    // Start loading the first page after the first frame, if needed.
    WidgetsBinding.instance.addPostFrameCallback((_) {
      if (!_initialTriggered) {
        _initialTriggered = true;
        if (widget.controller.loadedItems.isEmpty && !widget.controller.isLoading && !widget.controller.hasError) {
          widget.controller.loadNext();
        }
      }
    });

    widget.controller.addListener(_onControllerUpdate);
  }

  @override
  void dispose() {
    widget.controller.removeListener(_onControllerUpdate);
    _scrollController
      ..removeListener(_onScroll)
      ..dispose();
    super.dispose();
  }

  void _onControllerUpdate() {
    if (mounted) setState(() {});
  }

  void _onScroll() {
    if (_scrollController.position.extentAfter < widget.scrollThreshold) {
      widget.controller.loadNext();
    }
  }

  @override
  Widget build(BuildContext context) {
    final ctrl = widget.controller;
    final items = ctrl.loadedItems;
    final delegate = widget.builderDelegate;

    // CASE A: No items yet + first-page error
    if (items.isEmpty && ctrl.hasError && delegate.firstPageErrorIndicatorBuilder != null) {
      return delegate.firstPageErrorIndicatorBuilder!(context);
    }

    // CASE B: No items yet + not loading + not error ⇒ “no items found”
    if (items.isEmpty && !ctrl.isLoading && !ctrl.hasError && delegate.noItemsFoundIndicatorBuilder != null) {
      return delegate.noItemsFoundIndicatorBuilder!(context);
    }

    // Build the ListView with a conditional footer slot
    final showFooter = ctrl.shouldShowFooter || (ctrl.hasError && items.isNotEmpty);
    final totalCount = items.length + (showFooter ? 1 : 0);

    Widget listView = ListView.builder(
      controller: _scrollController,
      itemCount: totalCount,
      itemBuilder: (ctx, index) {
        // If index < items.length → normal item
        if (index < items.length) {
          return delegate.itemBuilder(ctx, items[index], index);
        }

        // Footer slot:
        // • If loading next page:
        if (ctrl.isLoading && items.isNotEmpty) {
          if (delegate.newPageProgressIndicatorBuilder != null) {
            return delegate.newPageProgressIndicatorBuilder!(ctx);
          } else {
            return const Padding(padding: EdgeInsets.all(16), child: Center(child: CircularProgressIndicator()));
          }
        }

        // • If error on a later page:
        if (ctrl.hasError && items.isNotEmpty) {
          if (delegate.newPageErrorIndicatorBuilder != null) {
            return delegate.newPageErrorIndicatorBuilder!(ctx, () {
              // Retry by calling the public API
              widget.controller.loadNext();
            });
          } else {
            return Padding(
              padding: const EdgeInsets.all(16),
              child: Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  const Text("Failed to load more items."),
                  const SizedBox(height: 8),
                  ElevatedButton(onPressed: () => widget.controller.loadNext(), child: const Text("Retry")),
                ],
              ),
            );
          }
        }

        // • Otherwise (last page reached) → empty
        return const SizedBox.shrink();
      },
    );

    if (widget.enablePullToRefresh) {
      return RefreshIndicator(onRefresh: () => widget.controller.refresh(), child: listView);
    } else {
      return listView;
    }
  }
}
