// import 'dart:developer';
// import 'package:flutter/material.dart';

// // robust_pagination.dart
// // A production-ready pagination controller + widget (single-file).
// // Drop-in replacement inspired by infinite_scroll_pagination.

// import 'dart:async';
// import 'dart:developer' as dev;
// import 'package:flutter/material.dart';

// /// API response wrapper
// class PageResponse<T> {
//   final List<T> items;
//   final dynamic nextPageKey;
//   final bool isLastPage;
//   final int? totalCount;
//   const PageResponse({
//     required this.items,
//     this.nextPageKey,
//     bool? isLastPage,
//     this.totalCount,
//   }) : isLastPage = isLastPage ?? (nextPageKey == null);

//   const PageResponse.lastPage({required this.items, this.totalCount})
//       : nextPageKey = null,
//         isLastPage = true;

//   bool get hasNextPage => !isLastPage;
//   int get itemCount => items.length;

//   @override
//   String toString() =>
//       'PageResponse(items: ${items.length}, nextPageKey: $nextPageKey, isLastPage: $isLastPage)';
// }

// /// Configuration for pagination
// class PaginationConfig {
//   final int limit;
//   final dynamic firstPageKey;
//   final bool isPageBased;
//   /// number of items from the end to trigger prefetching
//   final int loadMoreThreshold;
//   /// 0 = unlimited (no trimming)
//   final int maxCacheSize;
//   /// max retry attempts (>=1 will attempt at least once)
//   final int maxRetryAttempts;
//   /// base retry delay (exponential backoff multiplies this)
//   final Duration retryDelay;
//   /// optional builder to compute next page key (useful for non-int page keys)
//   final dynamic Function(dynamic currentKey, int itemsReceived)?
//       nextPageKeyBuilder;

//   const PaginationConfig({
//     this.limit = 20,
//     this.firstPageKey = 0,
//     this.isPageBased = true,
//     this.loadMoreThreshold = 5,
//     this.maxCacheSize = 0,
//     this.maxRetryAttempts = 3,
//     this.retryDelay = const Duration(milliseconds: 700),
//     this.nextPageKeyBuilder,
//   })  : assert(limit > 0),
//         assert(loadMoreThreshold >= 0),
//         assert(maxCacheSize >= 0),
//         assert(maxRetryAttempts >= 0);

//   dynamic getNextPageKey(dynamic currentKey, int itemsReceived) {
//     if (!isPageBased) return null;
//     if (nextPageKeyBuilder != null) {
//       return nextPageKeyBuilder!(currentKey, itemsReceived);
//     }
//     if (currentKey is int) {
//       return itemsReceived > 0 ? currentKey + 1 : null;
//     }
//     return null;
//   }

//   bool shouldMarkAsLastPage(int itemsReceived) {
//     return itemsReceived < limit;
//   }
// }

// /// A stable pagination controller.
// /// Supports: refresh, loadNextPage, retry, add/update/remove, dedupe, cache trimming.
// class PaginationController<T> extends ChangeNotifier {
//   final List<T> _items = [];
//   final PaginationConfig config;

//   // state
//   bool _isInitialLoading = false;
//   bool _isLoadingMore = false;
//   bool _hasError = false; // represents last general error state
//   String? _errorMessage;
//   bool _hasReachedMax = false;

//   dynamic _currentPageKey;
//   dynamic _nextPageKey; // track server-provided next key if present
//   int? _totalCount;

//   // concurrency guard
//   bool _isFetching = false;

//   /// For deduplication: either idExtractor (preferred) or comparator
//   final String Function(T)? idExtractor;
//   final bool Function(T a, T b)? equality;

//   // last failed action (used by retry())
//   _LastAction? _lastFailedAction;

//   // fetch function to be provided by user
//   Future<PageResponse<T>> Function(dynamic pageKey, int limit)? _fetchFunction;

//   PaginationController({
//     PaginationConfig? config,
//     this.idExtractor,
//     this.equality,
//   }) : config = config ?? const PaginationConfig(),
//        _currentPageKey = (config ?? const PaginationConfig()).firstPageKey {
//     _currentPageKey = this.config.firstPageKey;
//     _nextPageKey = null;
//   }

//   // PUBLIC GETTERS
//   List<T> get items => List.unmodifiable(_items);
//   bool get isInitialLoading => _isInitialLoading;
//   bool get isLoadingMore => _isLoadingMore;
//   bool get hasError => _hasError;
//   String? get errorMessage => _errorMessage;
//   bool get hasReachedMax => _hasReachedMax;
//   dynamic get currentPageKey => _currentPageKey;
//   int? get totalCount => _totalCount;
//   bool get isEmpty => _items.isEmpty && !_isInitialLoading;
//   bool get isDisposed => false; // ChangeNotifier has its own dispose

//   /// Initialize with a fetch function
//   /// fetchFunction signature: Future<PageResponse<T>> Function(dynamic pageKey, int limit)
//   void initialize(
//       Future<PageResponse<T>> Function(dynamic pageKey, int limit)
//           fetchFunction) {
//     _fetchFunction = fetchFunction;
//     // if no items, auto-refresh
//     if (_items.isEmpty && !_isInitialLoading && !_hasError) {
//       refresh();
//     }
//   }

//   /// Refresh (load first page). Keeps existing items until new data arrives (better UX).
//   Future<void> refresh() async {
//     if (_fetchFunction == null) return;
//     if (_isFetching) return;
//     final previousItems = List<T>.from(_items); // keep fallback
//     _hasError = false;
//     _errorMessage = null;
//     _isInitialLoading = true;
//     _hasReachedMax = false;
//     _nextPageKey = null;
//     _currentPageKey = config.firstPageKey;
//     notifyListeners();

//     try {
//       final response = await _performFetchWithRetries(_currentPageKey);
//       if (response == null) {
//         // fetch failed and _lastFailedAction is set
//         _isInitialLoading = false;
//         notifyListeners();
//         return;
//       }
//       // Success: replace items (refresh semantics)
//       _replaceAll(response.items);
//       _totalCount = response.totalCount;
//       _nextPageKey = response.nextPageKey;
//       // compute next if not provided
//       if (_nextPageKey == null) {
//         _nextPageKey = config.getNextPageKey(_currentPageKey, response.items.length);
//       }
//       _hasReachedMax = response.isLastPage ||
//           (config.shouldMarkAsLastPage(response.items.length) &&
//               response.nextPageKey == null) ||
//           (_nextPageKey == null);
//     } finally {
//       _isInitialLoading = false;
//       notifyListeners();
//     }
//   }

//   /// Load next page
//   Future<void> loadNextPage() async {
//     if (_fetchFunction == null) return;
//     if (_isFetching) return;
//     if (_hasReachedMax) return;

//     // determine pageKey to fetch
//     final pageKeyToFetch = _nextPageKey ?? config.getNextPageKey(_currentPageKey, _items.length > 0 ? _items.length % config.limit : 0) ?? _currentPageKey;
//     if (pageKeyToFetch == null) {
//       _hasReachedMax = true;
//       notifyListeners();
//       return;
//     }

//     _isLoadingMore = true;
//     _hasError = false;
//     _errorMessage = null;
//     notifyListeners();

//     final response = await _performFetchWithRetries(pageKeyToFetch, isLoadMore: true);

//     if (response == null) {
//       // failed; state set by _performFetchWithRetries
//       _isLoadingMore = false;
//       notifyListeners();
//       return;
//     }

//     // success: append
//     final newItems = response.items;
//     _appendItemsDedup(newItems);
//     _totalCount = response.totalCount;
//     _currentPageKey = pageKeyToFetch;
//     _nextPageKey = response.nextPageKey ?? config.getNextPageKey(_currentPageKey, newItems.length);

//     _hasReachedMax = response.isLastPage ||
//         (config.shouldMarkAsLastPage(newItems.length) && response.nextPageKey == null) ||
//         (_nextPageKey == null);

//     // trim cache if needed
//     if (config.maxCacheSize > 0 && _items.length > config.maxCacheSize) {
//       final excess = _items.length - config.maxCacheSize;
//       if (excess > 0) {
//         _items.removeRange(0, excess);
//       }
//     }

//     _isLoadingMore = false;
//     notifyListeners();
//   }

//   /// Retry the last failed action (refresh or loadMore). If nothing failed, does nothing.
//   Future<void> retry() async {
//     if (_lastFailedAction == null || _fetchFunction == null) return;
//     final action = _lastFailedAction!;
//     _lastFailedAction = null;
//     if (action.type == _LastActionType.refresh) {
//       await refresh();
//     } else if (action.type == _LastActionType.loadMore) {
//       await loadNextPage();
//     }
//   }

//   /// Add/update/remove helpers
//   void addItem(T item, {int? index}) {
//     if (index != null && index >= 0 && index <= _items.length) {
//       _items.insert(index, item);
//     } else {
//       _items.add(item);
//     }
//     if (_totalCount != null) _totalCount = _totalCount! + 1;
//     notifyListeners();
//   }

//   bool removeItem(T item) {
//     final removed = _items.remove(item);
//     if (removed && _totalCount != null && _totalCount! > 0) {
//       _totalCount = _totalCount! - 1;
//     }
//     if (removed) notifyListeners();
//     return removed;
//   }

//   T? removeAt(int index) {
//     if (index < 0 || index >= _items.length) return null;
//     final v = _items.removeAt(index);
//     if (_totalCount != null && _totalCount! > 0) _totalCount = _totalCount! - 1;
//     notifyListeners();
//     return v;
//   }

//   bool updateItem(int index, T item) {
//     if (index < 0 || index >= _items.length) return false;
//     _items[index] = item;
//     notifyListeners();
//     return true;
//   }

//   bool updateItemWhere(bool Function(T) test, T newItem) {
//     final index = _items.indexWhere(test);
//     if (index == -1) return false;
//     _items[index] = newItem;
//     notifyListeners();
//     return true;
//   }

//   void insertItem(int index, T item) {
//     if (index < 0 || index > _items.length) return;
//     _items.insert(index, item);
//     if (_totalCount != null) _totalCount = _totalCount! + 1;
//     notifyListeners();
//   }

//   void clear() {
//     _items.clear();
//     _hasReachedMax = false;
//     _hasError = false;
//     _errorMessage = null;
//     _totalCount = null;
//     _currentPageKey = config.firstPageKey;
//     _nextPageKey = null;
//     _isInitialLoading = false;
//     _isLoadingMore = false;
//     notifyListeners();
//   }

//   @override
//   void dispose() {
//     super.dispose();
//   }

//   // ---------------------
//   // INTERNAL / HELPERS
//   // ---------------------

//   Future<PageResponse<T>?> _performFetchWithRetries(
//     dynamic pageKey, {
//     bool isLoadMore = false,
//   }) async {
//     if (_fetchFunction == null) return null;
//     if (_isFetching) return null;
//     _isFetching = true;
//     _lastFailedAction = null;

//     final maxAttempts = config.maxRetryAttempts <= 0 ? 1 : config.maxRetryAttempts;
//     for (int attempt = 0; attempt < maxAttempts; attempt++) {
//       try {
//         dev.log('Pagination fetch attempt ${attempt + 1} for key $pageKey',
//             name: 'PaginationController');
//         final response = await _fetchFunction!(pageKey, config.limit);
//         // on success clear lastFailedAction
//         _lastFailedAction = null;
//         _hasError = false;
//         _errorMessage = null;
//         _isFetching = false;
//         return response;
//       } catch (e, st) {
//         dev.log('Pagination fetch error: $e', error: e, stackTrace: st, name: 'PaginationController');
//         // if this was last attempt, set error state and remember last action
//         if (attempt + 1 >= maxAttempts) {
//           _hasError = true;
//           _errorMessage = e.toString();
//           _lastFailedAction = _LastAction(isLoadMore ? _LastActionType.loadMore : _LastActionType.refresh, pageKey);
//           _isFetching = false;
//           return null;
//         }
//         // otherwise wait with exponential backoff
//         final delayMs = config.retryDelay.inMilliseconds * (1 << attempt);
//         await Future.delayed(Duration(milliseconds: delayMs));
//       }
//     }

//     _isFetching = false;
//     return null;
//   }

//   void _replaceAll(List<T> newItems) {
//     _items
//       ..clear()
//       ..addAll(newItems);
//   }

//   void _appendItemsDedup(List<T> newItems) {
//     if (newItems.isEmpty) return;
//     if (idExtractor == null && equality == null) {
//       _items.addAll(newItems);
//       return;
//     }

//     if (idExtractor != null) {
//       final existingIds = <String>{};
//       for (final item in _items) {
//         try {
//           existingIds.add(idExtractor!(item));
//         } catch (_) {}
//       }
//       for (final it in newItems) {
//         try {
//           final id = idExtractor!(it);
//           if (!existingIds.contains(id)) {
//             _items.add(it);
//             existingIds.add(id);
//           }
//         } catch (_) {
//           // fall back to adding if extractor fails
//           if (_items.indexWhere((e) => equality != null && equality!(e, it)) == -1) {
//             _items.add(it);
//           }
//         }
//       }
//       return;
//     }

//     if (equality != null) {
//       for (final it in newItems) {
//         if (_items.indexWhere((e) => equality!(e, it)) == -1) {
//           _items.add(it);
//         }
//       }
//       return;
//     }
//   }
// }

// enum _LastActionType { refresh, loadMore }

// class _LastAction {
//   final _LastActionType type;
//   final dynamic pageKey;
//   _LastAction(this.type, this.pageKey);
// }

// /// Widget for infinite list using PaginationController.
// class AdvancedPaginationView<T> extends StatefulWidget {
//   final PaginationController<T> controller;
//   final Future<PageResponse<T>> Function(dynamic pageKey, int limit) onFetchData;
//   final Widget Function(BuildContext, T, int) itemBuilder;

//   // builders
//   final Widget Function(BuildContext)? loadingBuilder;
//   final Widget Function(BuildContext, String, VoidCallback)? errorBuilder;
//   final Widget Function(BuildContext)? emptyBuilder;
//   final Widget Function(BuildContext)? loadingMoreBuilder;
//   final Widget Function(BuildContext, String, VoidCallback)? loadingMoreErrorBuilder;

//   // list config
//   final ScrollPhysics? physics;
//   final EdgeInsetsGeometry? padding;
//   final bool showLoadingMore;
//   final bool enableRefresh;
//   final ScrollController? scrollController;
//   final double? itemExtent;
//   final Widget Function(BuildContext, int)? separatorBuilder; // index-based
//   final Key? listViewKey;

//   // prefetching threshold in number of items from end
//   final int? loadMoreThreshold;

//   const AdvancedPaginationView({
//     super.key,
//     required this.controller,
//     required this.onFetchData,
//     required this.itemBuilder,
//     this.loadingBuilder,
//     this.errorBuilder,
//     this.emptyBuilder,
//     this.loadingMoreBuilder,
//     this.loadingMoreErrorBuilder,
//     this.physics,
//     this.padding,
//     this.showLoadingMore = true,
//     this.enableRefresh = true,
//     this.scrollController,
//     this.itemExtent,
//     this.separatorBuilder,
//     this.listViewKey,
//     this.loadMoreThreshold,
//   });

//   @override
//   State<AdvancedPaginationView<T>> createState() =>
//       _AdvancedPaginationViewState<T>();
// }

// class _AdvancedPaginationViewState<T> extends State<AdvancedPaginationView<T>> {
//   late final ScrollController _scrollController;
//   bool _attachedScroll = false;

//   int get _threshold => widget.loadMoreThreshold ?? widget.controller.config.loadMoreThreshold;

//   @override
//   void initState() {
//     super.initState();
//     _scrollController = widget.scrollController ?? ScrollController();
//     _attachScroll();
//     WidgetsBinding.instance.addPostFrameCallback((_) {
//       if (!widget.controller.isInitialLoading && widget.controller.items.isEmpty) {
//         // ensure controller has fetch function
//         widget.controller.initialize(widget.onFetchData);
//       } else {
//         // still initialize fetch function if not set
//         widget.controller.initialize(widget.onFetchData);
//       }
//     });
//   }

//   void _attachScroll() {
//     if (!_attachedScroll) {
//       _scrollController.addListener(_onScroll);
//       _attachedScroll = true;
//     }
//   }

//   void _detachScroll() {
//     if (_attachedScroll) {
//       _scrollController.removeListener(_onScroll);
//       _attachedScroll = false;
//     }
//   }

//   @override
//   void dispose() {
//     _detachScroll();
//     if (widget.scrollController == null) {
//       _scrollController.dispose();
//     }
//     super.dispose();
//   }

//   void _onScroll() {
//     if (!mounted) return;
//     if (widget.controller.isInitialLoading || widget.controller.isLoadingMore) return;
//     if (widget.controller.hasReachedMax) return;
//     try {
//       final pos = _scrollController.position;
//       // if scrolled within roughly threshold items -> trigger
//       final maxExtent = pos.maxScrollExtent;
//       final pixels = pos.pixels;
//       // if itemExtent known use it to compute pixel threshold
//       final pixelThreshold = widget.itemExtent != null
//           ? widget.itemExtent! * _threshold
//           : 200.0; // fallback
//       if (pixels >= maxExtent - pixelThreshold) {
//         widget.controller.loadNextPage();
//       }
//     } catch (_) {
//       // ignore scroll errors when controller not attached
//     }
//   }

//   Widget _defaultLoading() {
//     return const Center(
//       child: Padding(
//         padding: EdgeInsets.all(16),
//         child: CircularProgressIndicator(),
//       ),
//     );
//   }

//   Widget _defaultError(String error, VoidCallback retry) {
//     return Center(
//       child: Padding(
//         padding: const EdgeInsets.all(16),
//         child: Column(
//           mainAxisAlignment: MainAxisAlignment.center,
//           children: [
//             Icon(Icons.error_outline, size: 64, color: Theme.of(context).colorScheme.error),
//             const SizedBox(height: 12),
//             Text('Something went wrong', style: Theme.of(context).textTheme.titleLarge),
//             const SizedBox(height: 8),
//             Text(error, textAlign: TextAlign.center),
//             const SizedBox(height: 12),
//             ElevatedButton(onPressed: retry, child: const Text('Retry')),
//           ],
//         ),
//       ),
//     );
//   }

//   Widget _defaultEmpty() {
//     return Center(
//       child: Padding(
//         padding: const EdgeInsets.all(16),
//         child: Column(
//           mainAxisAlignment: MainAxisAlignment.center,
//           children: [
//             Icon(Icons.inbox_outlined, size: 64, color: Theme.of(context).colorScheme.onSurface.withValues(alpha: 0.6)),
//             const SizedBox(height: 12),
//             Text('No items found', style: Theme.of(context).textTheme.titleLarge),
//             const SizedBox(height: 8),
//             Text('Pull to refresh', style: Theme.of(context).textTheme.bodyMedium),
//           ],
//         ),
//       ),
//     );
//   }

//   Widget _defaultLoadingMore() {
//     return const Padding(
//       padding: EdgeInsets.all(16),
//       child: Center(
//         child: SizedBox(width: 24, height: 24, child: CircularProgressIndicator(strokeWidth: 2)),
//       ),
//     );
//   }

//   Widget _defaultLoadingMoreError(String error, VoidCallback retry) {
//     return Padding(
//       padding: const EdgeInsets.all(16),
//       child: Center(
//         child: Column(
//           children: [
//             Text(error, textAlign: TextAlign.center),
//             const SizedBox(height: 8),
//             ElevatedButton(onPressed: retry, child: const Text('Retry')),
//           ],
//         ),
//       ),
//     );
//   }

//   Widget _buildLoading() => widget.loadingBuilder?.call(context) ?? _defaultLoading();
//   Widget _buildError(String err) => widget.errorBuilder?.call(context, err, widget.controller.retry) ?? _defaultError(err, widget.controller.retry);
//   Widget _buildEmpty() => widget.emptyBuilder?.call(context) ?? _defaultEmpty();
//   Widget _buildLoadingMore() => widget.loadingMoreBuilder?.call(context) ?? _defaultLoadingMore();
//   Widget _buildLoadingMoreError(String err) => widget.loadingMoreErrorBuilder?.call(context, err, widget.controller.retry) ?? _defaultLoadingMoreError(err, widget.controller.retry);

//   int _extraItemCount() {
//     if (!widget.showLoadingMore) return 0;
//     // show footer when loading more OR when there was a (load-more) error
//     if (widget.controller.isLoadingMore) return 1;
//     // The controller currently sets hasError & errorMessage for the last error (refresh or loadMore).
//     // We show footer error only when there are items (i.e., it likely was a loadMore failure).
//     if (widget.controller.hasError && widget.controller.items.isNotEmpty) return 1;
//     return 0;
//   }

//   // build item or footer at index
//   Widget _buildItemOrFooter(BuildContext context, int index) {
//     final itemCount = widget.controller.items.length;
//     if (index >= itemCount) {
//       // footer
//       if (widget.controller.isLoadingMore) {
//         return _buildLoadingMore();
//       } else if (widget.controller.hasError && widget.controller.items.isNotEmpty) {
//         return _buildLoadingMoreError(widget.controller.errorMessage ?? 'Unknown error');
//       } else {
//         return const SizedBox.shrink();
//       }
//     }
//     final itemWidget = widget.itemBuilder(context, widget.controller.items[index], index);
//     // If index is near end (within threshold), schedule prefetch as a safety net
//     if (index >= itemCount - _threshold - 1) {
//       WidgetsBinding.instance.addPostFrameCallback((_) {
//         widget.controller.loadNextPage();
//       });
//     }
//     return itemWidget;
//   }

//   @override
//   Widget build(BuildContext context) {
//     return AnimatedBuilder(
//       animation: widget.controller,
//       builder: (context, child) {
//         // initial loading
//         if (widget.controller.isEmpty && widget.controller.isInitialLoading) {
//           return _buildLoading();
//         }

//         // error + empty
//         if (widget.controller.hasError && widget.controller.items.isEmpty) {
//           return _buildError(widget.controller.errorMessage ?? 'Unknown error');
//         }

//         // empty view
//         if (widget.controller.isEmpty) {
//           return widget.enableRefresh
//               ? RefreshIndicator(
//                   onRefresh: widget.controller.refresh,
//                   child: SingleChildScrollView(
//                     physics: const AlwaysScrollableScrollPhysics(),
//                     child: SizedBox(
//                       height: MediaQuery.of(context).size.height * 0.6,
//                       child: _buildEmpty(),
//                     ),
//                   ),
//                 )
//               : _buildEmpty();
//         }

//         // Build list
//         final baseItemCount = widget.controller.items.length;
//         final extras = _extraItemCount();
//         final totalCount = baseItemCount + extras;

//         Widget list;
//         if (widget.separatorBuilder != null) {
//           list = ListView.separated(
//             key: widget.listViewKey,
//             controller: _scrollController,
//             physics: widget.physics ?? const AlwaysScrollableScrollPhysics(),
//             padding: widget.padding,
//             itemCount: totalCount,
//             itemBuilder: (context, index) => _buildItemOrFooter(context, index),
//             separatorBuilder: (context, index) {
//               // don't show separator after footer
//               if (index >= baseItemCount - 1) return const SizedBox.shrink();
//               return widget.separatorBuilder!(context, index);
//             },
//           );
//         } else {
//           list = ListView.builder(
//             key: widget.listViewKey,
//             controller: _scrollController,
//             physics: widget.physics ?? const AlwaysScrollableScrollPhysics(),
//             padding: widget.padding,
//             itemCount: totalCount,
//             itemExtent: widget.itemExtent,
//             itemBuilder: (context, index) => _buildItemOrFooter(context, index),
//           );
//         }

//         return widget.enableRefresh
//             ? RefreshIndicator(onRefresh: widget.controller.refresh, child: list)
//             : list;
//       },
//     );
//   }
// }


// /// Third old code
// // /// Response class for paginated data
// // class PageResponse<T> {
// //   /// The items for this page
// //   final List<T> items;

// //   /// Key for the next page (can be page number, cursor, etc.)
// //   final dynamic nextPageKey;

// //   /// Whether this is the last page
// //   final bool isLastPage;

// //   /// Total count of items (optional)
// //   final int? totalCount;

// //   const PageResponse({
// //     required this.items,
// //     this.nextPageKey,
// //     bool? isLastPage,
// //     this.totalCount,
// //   }) : isLastPage = isLastPage ?? (nextPageKey == null);

// //   /// Create a response indicating the last page
// //   const PageResponse.lastPage({
// //     required this.items,
// //     this.totalCount,
// //   }) : nextPageKey = null,
// //         isLastPage = true;

// //   /// Check if there are more pages
// //   bool get hasNextPage => !isLastPage;

// //   /// Get the count of items in this page
// //   int get itemCount => items.length;

// //   @override
// //   String toString() =>
// //       'PageResponse(items: ${items.length}, nextPageKey: $nextPageKey, isLastPage: $isLastPage)';
// // }

// // /// Configuration for pagination behavior
// // class PaginationConfig {
// //   /// Items per page
// //   final int limit;

// //   /// Initial page key (usually 1 or 0)
// //   final dynamic firstPageKey;

// //   /// Whether to use page-based or cursor-based pagination
// //   final bool isPageBased;

// //   /// Threshold for loading next page (items from end)
// //   final int loadMoreThreshold;

// //   /// Retry attempts for failed requests
// //   final int maxRetryAttempts;

// //   /// Delay between retry attempts
// //   final Duration retryDelay;

// //   /// Whether to enable invisible loading (loads slightly ahead of user)
// //   final bool enableInvisibleLoading;

// //   const PaginationConfig({
// //     this.limit = 20,
// //     this.firstPageKey = 0,
// //     this.isPageBased = true,
// //     this.loadMoreThreshold = 5,
// //     this.maxRetryAttempts = 3,
// //     this.retryDelay = const Duration(milliseconds: 1000),
// //     this.enableInvisibleLoading = true,
// //   }) : assert(limit > 0, 'Limit must be greater than 0'),
// //        assert(loadMoreThreshold >= 0, 'Load more threshold must be non-negative'),
// //        assert(maxRetryAttempts >= 0, 'Max retry attempts must be non-negative');

// //   /// Get the next page key based on current key and pagination type
// //   dynamic getNextPageKey(dynamic currentKey, int itemsReceived) {
// //     if (!isPageBased) return null; // For cursor-based, use the provided nextPageKey

// //     // For page-based pagination
// //     if (currentKey is int) {
// //       // Only increment if we received items
// //       return itemsReceived > 0 ? currentKey + 1 : null;
// //     }
// //     return null;
// //   }

// //   /// Check if we've reached the end based on items received vs limit
// //   bool shouldMarkAsLastPage(int itemsReceived) {
// //     return itemsReceived < limit;
// //   }
// // }

// // /// Simple pagination controller that NEVER removes items
// // class PaginationController<T> extends ChangeNotifier {
// //   final List<T> _items = [];
// //   bool _isLoading = false;
// //   bool _isLoadingMore = false;
// //   bool _hasError = false;
// //   String? _errorMessage;
// //   bool _hasReachedMax = false;
// //   dynamic _currentPageKey;
// //   bool _disposed = false;

// //   /// Configuration for pagination behavior
// //   final PaginationConfig config;

// //   /// Total count of items (if provided by API)
// //   int? _totalCount;

// //   // Getters
// //   List<T> get items => _disposed ? [] : List.unmodifiable(_items);
// //   bool get isLoading => _disposed ? false : _isLoading;
// //   bool get isLoadingMore => _disposed ? false : _isLoadingMore;
// //   bool get hasError => _disposed ? false : _hasError;
// //   String? get errorMessage => _disposed ? null : _errorMessage;
// //   bool get hasReachedMax => _disposed ? true : _hasReachedMax;
// //   dynamic get currentPageKey => _disposed ? null : _currentPageKey;
// //   bool get isEmpty => _disposed ? true : (_items.isEmpty && !_isLoading);
// //   int? get totalCount => _disposed ? null : _totalCount;
// //   int get itemCount => _disposed ? 0 : _items.length;
// //   bool get isDisposed => _disposed;

// //   /// Function that fetches data for a given page key
// //   Future<PageResponse<T>> Function(dynamic pageKey)? _fetchFunction;

// //   PaginationController({PaginationConfig? config})
// //       : config = config ?? const PaginationConfig(),
// //         _currentPageKey = config?.firstPageKey ?? 0;

// //   /// Initialize the controller with a fetch function
// //   void initialize(
// //     Future<PageResponse<T>> Function(dynamic pageKey, int limit) fetchFunction,
// //   ) {
// //     if (_disposed) return;
    
// //     _fetchFunction = (pageKey) => fetchFunction(pageKey, config.limit);
    
// //     // Only auto-refresh if we don't have items yet
// //     if (_items.isEmpty && !_isLoading && !_hasError) {
// //       refresh();
// //     }
// //   }

// //   /// Load the first page (refresh)
// //   Future<void> refresh() async {
// //     if (_disposed || _fetchFunction == null) return;

// //     _currentPageKey = config.firstPageKey;
// //     _items.clear();
// //     _hasReachedMax = false;
// //     _hasError = false;
// //     _errorMessage = null;
// //     _totalCount = null;
// //     _isLoadingMore = false;
    
// //     if (!_disposed) notifyListeners();
// //     await _loadPage(isInitialLoad: true);
// //   }

// //   /// Load the next page
// //   Future<void> loadNextPage() async {
// //     if (_disposed || _isLoading || _isLoadingMore || _hasReachedMax || _hasError || _fetchFunction == null) {
// //       return;
// //     }
// //     await _loadPage(isInitialLoad: false);
// //   }

// //   /// Retry loading current page
// //   Future<void> retry() async {
// //     if (_disposed) return;
    
// //     _hasError = false;
// //     _errorMessage = null;
// //     if (!_disposed) notifyListeners();
    
// //     await _loadPage(isInitialLoad: _items.isEmpty);
// //   }

// //   /// Internal method to load a page with retry logic
// //   Future<void> _loadPage({required bool isInitialLoad}) async {
// //     if (_disposed || _fetchFunction == null) return;

// //     if (isInitialLoad) {
// //       _isLoading = true;
// //     } else {
// //       _isLoadingMore = true;
// //     }
    
// //     _hasError = false;
// //     _errorMessage = null;
// //     if (!_disposed) notifyListeners();

// //     for (int attempt = 0; attempt <= config.maxRetryAttempts; attempt++) {
// //       if (_disposed) return;
      
// //       try {
// //         final response = await _fetchFunction!(_currentPageKey);
        
// //         if (_disposed) return;

// //         // Handle the response
// //         _handleSuccessfulResponse(response);
// //         return;
        
// //       } catch (error) {
// //         if (_disposed) return;
        
// //         if (attempt < config.maxRetryAttempts) {
// //           // Wait before retrying
// //           await Future.delayed(config.retryDelay);
// //           continue;
// //         } else {
// //           // Final attempt failed
// //           _hasError = true;
// //           _errorMessage = error.toString();
// //         }
// //       }
// //     }

// //     if (!_disposed) {
// //       _isLoading = false;
// //       _isLoadingMore = false;
// //       notifyListeners();
// //     }
// //   }

// //   /// Handle successful API response - NEVER removes items
// //   void _handleSuccessfulResponse(PageResponse<T> response) {
// //     if (_disposed) return;
    
// //     // Validate response
// //     if (response.items.isEmpty && _items.isEmpty) {
// //       _hasReachedMax = true;
// //     } else if (response.isLastPage) {
// //       _hasReachedMax = true;
// //     } else {
// //       // Use provided nextPageKey or calculate it
// //       final nextKey = response.nextPageKey ?? 
// //           config.getNextPageKey(_currentPageKey, response.items.length);
      
// //       _currentPageKey = nextKey;
      
// //       // Check if we should mark as last page based on config
// //       if (config.shouldMarkAsLastPage(response.items.length) && 
// //           response.nextPageKey == null) {
// //         _hasReachedMax = true;
// //       }
      
// //       if (_currentPageKey == null) {
// //         _hasReachedMax = true;
// //       }
// //     }

// //     // Add new items - NEVER remove old ones
// //     _items.addAll(response.items);
// //     _totalCount = response.totalCount;

// //     _isLoading = false;
// //     _isLoadingMore = false;
// //     if (!_disposed) notifyListeners();
// //   }

// //   /// Add a single item to the list
// //   void addItem(T item, {int? index}) {
// //     if (_disposed) return;
    
// //     if (index != null && index >= 0 && index <= _items.length) {
// //       _items.insert(index, item);
// //     } else {
// //       _items.add(item);
// //     }
    
// //     // Update total count if we know it
// //     if (_totalCount != null) {
// //       _totalCount = _totalCount! + 1;
// //     }
    
// //     notifyListeners();
// //   }

// //   /// Remove an item from the list
// //   bool removeItem(T item) {
// //     if (_disposed) return false;
    
// //     final removed = _items.remove(item);
// //     if (removed) {
// //       // Update total count if we know it
// //       if (_totalCount != null && _totalCount! > 0) {
// //         _totalCount = _totalCount! - 1;
// //       }
// //       notifyListeners();
// //     }
// //     return removed;
// //   }

// //   /// Remove an item at a specific index
// //   T? removeAt(int index) {
// //     if (_disposed || index < 0 || index >= _items.length) return null;
    
// //     final item = _items.removeAt(index);
    
// //     // Update total count if we know it
// //     if (_totalCount != null && _totalCount! > 0) {
// //       _totalCount = _totalCount! - 1;
// //     }
    
// //     notifyListeners();
// //     return item;
// //   }

// //   /// Update an item in the list
// //   bool updateItem(int index, T item) {
// //     if (_disposed || index < 0 || index >= _items.length) return false;
    
// //     _items[index] = item;
// //     notifyListeners();
// //     return true;
// //   }

// //   /// Update an item by finding it in the list
// //   bool updateItemWhere(bool Function(T) test, T newItem) {
// //     if (_disposed) return false;
    
// //     final index = _items.indexWhere(test);
// //     if (index != -1) {
// //       _items[index] = newItem;
// //       notifyListeners();
// //       return true;
// //     }
// //     return false;
// //   }

// //   /// Insert an item at a specific index
// //   void insertItem(int index, T item) {
// //     if (_disposed) return;
    
// //     if (index >= 0 && index <= _items.length) {
// //       _items.insert(index, item);
      
// //       // Update total count if we know it
// //       if (_totalCount != null) {
// //         _totalCount = _totalCount! + 1;
// //       }
      
// //       notifyListeners();
// //     }
// //   }

// //   /// Clear all items
// //   void clear() {
// //     if (_disposed) return;
    
// //     _items.clear();
// //     _hasReachedMax = false;
// //     _hasError = false;
// //     _errorMessage = null;
// //     _totalCount = null;
// //     _currentPageKey = config.firstPageKey;
// //     _isLoadingMore = false;
// //     notifyListeners();
// //   }

// //   /// Find item by condition
// //   T? findItem(bool Function(T) test) {
// //     if (_disposed) return null;
    
// //     try {
// //       return _items.firstWhere(test);
// //     } catch (e) {
// //       return null;
// //     }
// //   }

// //   /// Find item index by condition
// //   int findIndex(bool Function(T) test) {
// //     if (_disposed) return -1;
// //     return _items.indexWhere(test);
// //   }

// //   @override
// //   void dispose() {
// //     _disposed = true;
// //     _items.clear();
// //     _fetchFunction = null;
// //     super.dispose();
// //   }

// //   @override
// //   void notifyListeners() {
// //     if (!_disposed) {
// //       super.notifyListeners();
// //     }
// //   }
// // }

// // /// Simple, reliable pagination widget
// // class AdvancedPaginationView<T> extends StatefulWidget {
// //   /// Controller that manages pagination state
// //   final PaginationController<T> controller;

// //   /// Function that fetches data for a given page key and limit
// //   final Future<PageResponse<T>> Function(dynamic pageKey, int limit) onFetchData;

// //   /// Builder for individual items
// //   final Widget Function(BuildContext context, T item, int index) itemBuilder;

// //   /// Builder for loading indicator
// //   final Widget Function(BuildContext context)? loadingBuilder;

// //   /// Builder for error state
// //   final Widget Function(BuildContext context, String error, VoidCallback retry)?
// //       errorBuilder;

// //   /// Builder for empty state
// //   final Widget Function(BuildContext context)? emptyBuilder;

// //   /// Builder for loading more indicator at the bottom
// //   final Widget Function(BuildContext context)? loadingMoreBuilder;

// //   /// Physics for the scroll view
// //   final ScrollPhysics? physics;

// //   /// Padding for the list
// //   final EdgeInsetsGeometry? padding;

// //   /// Whether to show loading more indicator
// //   final bool showLoadingMore;

// //   /// Whether to enable pull-to-refresh
// //   final bool enableRefresh;

// //   /// Scroll controller (optional)
// //   final ScrollController? scrollController;

// //   /// Item extent for performance optimization
// //   final double? itemExtent;

// //   /// Separator builder
// //   final Widget Function(BuildContext context, int index)? separatorBuilder;

// //   /// Key for the list view (for maintaining scroll position)
// //   final Key? listViewKey;

// //   const AdvancedPaginationView({
// //     super.key,
// //     required this.controller,
// //     required this.onFetchData,
// //     required this.itemBuilder,
// //     this.loadingBuilder,
// //     this.errorBuilder,
// //     this.emptyBuilder,
// //     this.loadingMoreBuilder,
// //     this.physics,
// //     this.padding,
// //     this.showLoadingMore = true,
// //     this.enableRefresh = true,
// //     this.scrollController,
// //     this.itemExtent,
// //     this.separatorBuilder,
// //     this.listViewKey,
// //   });

// //   @override
// //   State<AdvancedPaginationView<T>> createState() =>
// //       _AdvancedPaginationViewState<T>();
// // }

// // class _AdvancedPaginationViewState<T>
// //     extends State<AdvancedPaginationView<T>> {
// //   late ScrollController _scrollController;

// //   @override
// //   void initState() {
// //     super.initState();
// //     _scrollController = widget.scrollController ?? ScrollController();
// //     _scrollController.addListener(_onScroll);

// //     // Initialize controller if not already done
// //     WidgetsBinding.instance.addPostFrameCallback((_) {
// //       if (!widget.controller.isDisposed) {
// //         widget.controller.initialize(widget.onFetchData);
// //       }
// //     });
// //   }

// //   @override
// //   void dispose() {
// //     _scrollController.removeListener(_onScroll);
// //     if (widget.scrollController == null) {
// //       _scrollController.dispose();
// //     }
// //     super.dispose();
// //   }

// //   void _onScroll() {
// //     if (widget.controller.isDisposed || !mounted) return;
    
// //     final position = _scrollController.position;
    
// //     // Simple approach: load more when user scrolls close to bottom
// //     if (position.pixels >= position.maxScrollExtent - 300) {
// //       if (!widget.controller.isLoadingMore && 
// //           !widget.controller.hasReachedMax &&
// //           !widget.controller.hasError) {
// //         widget.controller.loadNextPage();
// //       }
// //     }
// //   }

// //   Widget _buildLoadingIndicator() {
// //     return widget.loadingBuilder?.call(context) ??
// //         const Center(
// //           child: Padding(
// //             padding: EdgeInsets.all(16.0),
// //             child: CircularProgressIndicator(),
// //           ),
// //         );
// //   }

// //   Widget _buildErrorView(String error) {
// //     return widget.errorBuilder?.call(context, error, widget.controller.retry) ??
// //         Center(
// //           child: Padding(
// //             padding: const EdgeInsets.all(16.0),
// //             child: Column(
// //               mainAxisAlignment: MainAxisAlignment.center,
// //               children: [
// //                 Icon(
// //                   Icons.error_outline,
// //                   size: 64,
// //                   color: Theme.of(context).colorScheme.error,
// //                 ),
// //                 const SizedBox(height: 16),
// //                 Text(
// //                   'Something went wrong',
// //                   style: Theme.of(context).textTheme.headlineSmall,
// //                 ),
// //                 const SizedBox(height: 8),
// //                 Text(
// //                   error,
// //                   textAlign: TextAlign.center,
// //                   style: Theme.of(context).textTheme.bodyMedium,
// //                 ),
// //                 const SizedBox(height: 16),
// //                 ElevatedButton(
// //                   onPressed: widget.controller.retry,
// //                   child: const Text('Retry'),
// //                 ),
// //               ],
// //             ),
// //           ),
// //         );
// //   }

// //   Widget _buildEmptyView() {
// //     return widget.emptyBuilder?.call(context) ??
// //         Center(
// //           child: Padding(
// //             padding: const EdgeInsets.all(16.0),
// //             child: Column(
// //               mainAxisAlignment: MainAxisAlignment.center,
// //               children: [
// //                 Icon(
// //                   Icons.inbox_outlined,
// //                   size: 64,
// //                   color: Theme.of(context)
// //                       .colorScheme
// //                       .onSurface
// //                       .withValues(alpha: 0.6),
// //                 ),
// //                 const SizedBox(height: 16),
// //                 Text(
// //                   'No items found',
// //                   style: Theme.of(context).textTheme.headlineSmall,
// //                 ),
// //                 const SizedBox(height: 8),
// //                 Text(
// //                   'Pull down to refresh',
// //                   style: Theme.of(context).textTheme.bodyMedium?.copyWith(
// //                         color: Theme.of(context)
// //                             .colorScheme
// //                             .onSurface
// //                             .withValues(alpha: 0.6),
// //                       ),
// //                 ),
// //               ],
// //             ),
// //           ),
// //         );
// //   }

// //   Widget _buildLoadingMoreIndicator() {
// //     return widget.loadingMoreBuilder?.call(context) ??
// //         const Padding(
// //           padding: EdgeInsets.all(16.0),
// //           child: Center(
// //             child: SizedBox(
// //               width: 24,
// //               height: 24,
// //               child: CircularProgressIndicator(strokeWidth: 2),
// //             ),
// //           ),
// //         );
// //   }

// //   Widget _buildList() {
// //     final itemCount = widget.controller.items.length +
// //         (widget.showLoadingMore && widget.controller.isLoadingMore ? 1 : 0);

// //     if (widget.separatorBuilder != null) {
// //       return ListView.separated(
// //         key: widget.listViewKey,
// //         controller: _scrollController,
// //         physics: widget.physics ?? const AlwaysScrollableScrollPhysics(),
// //         padding: widget.padding,
// //         itemCount: widget.controller.items.length,
// //         itemBuilder: (context, index) => widget.itemBuilder(
// //           context,
// //           widget.controller.items[index],
// //           index,
// //         ),
// //         separatorBuilder: widget.separatorBuilder!,
// //       );
// //     }

// //     return ListView.builder(
// //       key: widget.listViewKey,
// //       controller: _scrollController,
// //       physics: widget.physics ?? const AlwaysScrollableScrollPhysics(),
// //       padding: widget.padding,
// //       itemCount: itemCount,
// //       itemExtent: widget.itemExtent,
// //       itemBuilder: (context, index) {
// //         // Show loading more indicator
// //         if (index >= widget.controller.items.length) {
// //           return _buildLoadingMoreIndicator();
// //         }

// //         return widget.itemBuilder(
// //           context,
// //           widget.controller.items[index],
// //           index,
// //         );
// //       },
// //     );
// //   }

// //   @override
// //   Widget build(BuildContext context) {
// //     if (widget.controller.isDisposed) {
// //       return const SizedBox.shrink();
// //     }
    
// //     return AnimatedBuilder(
// //       animation: widget.controller,
// //       builder: (context, child) {
// //         // Show loading for initial load
// //         if (widget.controller.isEmpty && widget.controller.isLoading) {
// //           return _buildLoadingIndicator();
// //         }

// //         // Show error if there's an error and no items
// //         if (widget.controller.hasError && widget.controller.items.isEmpty) {
// //           return _buildErrorView(
// //             widget.controller.errorMessage ?? 'Unknown error',
// //           );
// //         }

// //         // Show empty state
// //         if (widget.controller.isEmpty) {
// //           return widget.enableRefresh
// //               ? RefreshIndicator(
// //                   onRefresh: widget.controller.refresh,
// //                   child: SingleChildScrollView(
// //                     physics: const AlwaysScrollableScrollPhysics(),
// //                     child: SizedBox(
// //                       height: MediaQuery.of(context).size.height * 0.7,
// //                       child: _buildEmptyView(),
// //                     ),
// //                   ),
// //                 )
// //               : _buildEmptyView();
// //         }

// //         // Build the list with or without refresh indicator
// //         final listWidget = _buildList();

// //         return widget.enableRefresh
// //             ? RefreshIndicator(
// //                 onRefresh: widget.controller.refresh,
// //                 child: listWidget,
// //               )
// //             : listWidget;
// //       },
// //     );
// //   }
// // }

// // /// Simple example usage
// // class PaginationExample extends StatefulWidget {
// //   const PaginationExample({super.key});

// //   @override
// //   State<PaginationExample> createState() => _PaginationExampleState();
// // }

// // class _PaginationExampleState extends State<PaginationExample> {
// //   late PaginationController<String> _controller;

// //   @override
// //   void initState() {
// //     super.initState();
// //     _controller = PaginationController<String>(
// //       config: const PaginationConfig(
// //         limit: 20,
// //         loadMoreThreshold: 5,
// //       ),
// //     );
// //   }

// //   @override
// //   void dispose() {
// //     _controller.dispose();
// //     super.dispose();
// //   }

// //   // Mock API call
// //   Future<PageResponse<String>> _fetchData(dynamic pageKey, int limit) async {
// //     await Future.delayed(const Duration(milliseconds: 800));

// //     int page = pageKey as int;
// //     List<String> items = [];
// //     int startIndex = page * limit;

// //     // Simulate finite data (stop at 100 items)
// //     if (startIndex >= 100) {
// //       return const PageResponse.lastPage(items: [], totalCount: 100);
// //     }

// //     final endIndex = (startIndex + limit > 100) ? 100 : startIndex + limit;

// //     for (int i = startIndex; i < endIndex; i++) {
// //       items.add('Item ${i + 1}');
// //     }

// //     return PageResponse(
// //       items: items,
// //       nextPageKey: endIndex < 100 ? page + 1 : null,
// //       totalCount: 100,
// //     );
// //   }

// //   @override
// //   Widget build(BuildContext context) {
// //     return Scaffold(
// //       appBar: AppBar(
// //         title: const Text('Fixed Pagination'),
// //         actions: [
// //           IconButton(
// //             icon: const Icon(Icons.refresh),
// //             onPressed: _controller.refresh,
// //           )
// //         ],
// //       ),
// //       body: AdvancedPaginationView<String>(
// //         controller: _controller,
// //         onFetchData: _fetchData,
// //         itemBuilder: (context, item, index) {
// //           return Card(
// //             margin: const EdgeInsets.symmetric(horizontal: 8.0, vertical: 4.0),
// //             child: ListTile(
// //               leading: CircleAvatar(
// //                 child: Text('${index + 1}'),
// //               ),
// //               title: Text(item),
// //               subtitle: Text('Index: $index'),
// //             ),
// //           );
// //         },
// //       ),
// //     );
// //   }
// // }



// /// Second old code
// // import 'package:flutter/material.dart';

// // /// Response class for paginated data
// // class PageResponse<T> {
// //   /// The items for this page
// //   final List<T> items;

// //   /// Key for the next page (can be page number, cursor, etc.)
// //   final dynamic nextPageKey;

// //   /// Whether this is the last page
// //   final bool isLastPage;

// //   /// Total count of items (optional)
// //   final int? totalCount;

// //   const PageResponse({
// //     required this.items,
// //     this.nextPageKey,
// //     bool? isLastPage,
// //     this.totalCount,
// //   }) : isLastPage = isLastPage ?? (nextPageKey == null);

// //   /// Create a response indicating the last page
// //   const PageResponse.lastPage({
// //     required this.items,
// //     this.totalCount,
// //   }) : nextPageKey = null,
// //         isLastPage = true;

// //   /// Check if there are more pages
// //   bool get hasNextPage => !isLastPage;

// //   /// Get the count of items in this page
// //   int get itemCount => items.length;

// //   @override
// //   String toString() =>
// //       'PageResponse(items: ${items.length}, nextPageKey: $nextPageKey, isLastPage: $isLastPage)';
// // }

// // /// Configuration for pagination behavior
// // class PaginationConfig {
// //   /// Items per page
// //   final int limit;

// //   /// Initial page key (usually 1 or 0)
// //   final dynamic firstPageKey;

// //   /// Whether to use page-based or cursor-based pagination
// //   final bool isPageBased;

// //   /// Threshold for loading next page (items from end)
// //   final int loadMoreThreshold;

// //   /// Maximum number of items to keep in memory (0 = no limit)
// //   final int maxCacheSize;

// //   /// Retry attempts for failed requests
// //   final int maxRetryAttempts;

// //   /// Delay between retry attempts
// //   final Duration retryDelay;

// //   const PaginationConfig({
// //     this.limit = 20,
// //     this.firstPageKey = 0,
// //     this.isPageBased = true,
// //     this.loadMoreThreshold = 3,
// //     this.maxCacheSize = 0,
// //     this.maxRetryAttempts = 3,
// //     this.retryDelay = const Duration(milliseconds: 1000),
// //   }) : assert(limit > 0, 'Limit must be greater than 0'),
// //        assert(loadMoreThreshold >= 0, 'Load more threshold must be non-negative'),
// //        assert(maxCacheSize >= 0, 'Max cache size must be non-negative'),
// //        assert(maxRetryAttempts >= 0, 'Max retry attempts must be non-negative');

// //   /// Get the next page key based on current key and pagination type
// //   dynamic getNextPageKey(dynamic currentKey, int itemsReceived) {
// //     if (!isPageBased) return null; // For cursor-based, use the provided nextPageKey

// //     // For page-based pagination
// //     if (currentKey is int) {
// //       // Only increment if we received items
// //       return itemsReceived > 0 ? currentKey + 1 : null;
// //     }
// //     return null;
// //   }

// //   /// Check if we've reached the end based on items received vs limit
// //   bool shouldMarkAsLastPage(int itemsReceived) {
// //     return itemsReceived < limit;
// //   }
// // }

// // /// Pagination controller that manages the state of paginated data
// // class PaginationController<T> extends ChangeNotifier {
// //   final List<T> _items = [];
// //   bool _isLoading = false;
// //   bool _hasError = false;
// //   String? _errorMessage;
// //   bool _hasReachedMax = false;
// //   dynamic _currentPageKey;
// //   bool _disposed = false;
// //   int _retryCount = 0;

// //   /// Configuration for pagination behavior
// //   final PaginationConfig config;

// //   /// Total count of items (if provided by API)
// //   int? _totalCount;

// //   // Getters
// //   List<T> get items => _disposed ? [] : List.unmodifiable(_items);
// //   bool get isLoading => _disposed ? false : _isLoading;
// //   bool get hasError => _disposed ? false : _hasError;
// //   String? get errorMessage => _disposed ? null : _errorMessage;
// //   bool get hasReachedMax => _disposed ? true : _hasReachedMax;
// //   dynamic get currentPageKey => _disposed ? null : _currentPageKey;
// //   bool get isEmpty => _disposed ? true : (_items.isEmpty && !_isLoading);
// //   int? get totalCount => _disposed ? null : _totalCount;
// //   int get itemCount => _disposed ? 0 : _items.length;
// //   bool get isDisposed => _disposed;

// //   /// Function that fetches data for a given page key
// //   Future<PageResponse<T>> Function(dynamic pageKey)? _fetchFunction;

// //   PaginationController({PaginationConfig? config})
// //       : config = config ?? const PaginationConfig(),
// //         _currentPageKey = config?.firstPageKey ?? 0;

// //   /// Initialize the controller with a fetch function
// //   void initialize(
// //     Future<PageResponse<T>> Function(dynamic pageKey, int limit) fetchFunction,
// //   ) {
// //     if (_disposed) return;
    
// //     _fetchFunction = (pageKey) => fetchFunction(pageKey, config.limit);
    
// //     // Only auto-refresh if we don't have items yet
// //     if (_items.isEmpty && !_isLoading && !_hasError) {
// //       refresh();
// //     }
// //   }

// //   /// Load the first page (refresh)
// //   Future<void> refresh() async {
// //     if (_disposed || _fetchFunction == null) return;

// //     _currentPageKey = config.firstPageKey;
// //     _items.clear();
// //     _hasReachedMax = false;
// //     _hasError = false;
// //     _errorMessage = null;
// //     _totalCount = null;
// //     _retryCount = 0;
    
// //     if (!_disposed) notifyListeners();
// //     await _loadPage();
// //   }

// //   /// Load the next page
// //   Future<void> loadNextPage() async {
// //     if (_disposed || _isLoading || _hasReachedMax || _hasError || _fetchFunction == null) {
// //       return;
// //     }
// //     await _loadPage();
// //   }

// //   /// Retry loading current page
// //   Future<void> retry() async {
// //     if (_disposed) return;
    
// //     _hasError = false;
// //     _errorMessage = null;
// //     if (!_disposed) notifyListeners();
    
// //     await _loadPage();
// //   }

// //   /// Internal method to load a page with retry logic
// //   Future<void> _loadPage() async {
// //     if (_disposed || _fetchFunction == null) return;

// //     _isLoading = true;
// //     _hasError = false;
// //     _errorMessage = null;
// //     if (!_disposed) notifyListeners();

// //     for (int attempt = 0; attempt <= config.maxRetryAttempts; attempt++) {
// //       if (_disposed) return;
      
// //       try {
// //         final response = await _fetchFunction!(_currentPageKey);
        
// //         if (_disposed) return;

// //         // Handle the response
// //         _handleSuccessfulResponse(response);
// //         _retryCount = 0; // Reset retry count on success
// //         return;
        
// //       } catch (error) {
// //         if (_disposed) return;
        
// //         if (attempt < config.maxRetryAttempts) {
// //           // Wait before retrying
// //           await Future.delayed(config.retryDelay);
// //           continue;
// //         } else {
// //           // Final attempt failed
// //           _hasError = true;
// //           _errorMessage = error.toString();
// //           _retryCount = attempt + 1;
// //         }
// //       }
// //     }

// //     if (!_disposed) {
// //       _isLoading = false;
// //       notifyListeners();
// //     }
// //   }

// //   /// Handle successful API response
// //   void _handleSuccessfulResponse(PageResponse<T> response) {
// //     if (_disposed) return;
    
// //     // Validate response
// //     if (response.items.isEmpty && _items.isEmpty) {
// //       _hasReachedMax = true;
// //     } else if (response.isLastPage) {
// //       _hasReachedMax = true;
// //     } else {
// //       // Use provided nextPageKey or calculate it
// //       final nextKey = response.nextPageKey ?? 
// //           config.getNextPageKey(_currentPageKey, response.items.length);
      
// //       _currentPageKey = nextKey;
      
// //       // Check if we should mark as last page based on config
// //       if (config.shouldMarkAsLastPage(response.items.length) && 
// //           response.nextPageKey == null) {
// //         _hasReachedMax = true;
// //       }
      
// //       if (_currentPageKey == null) {
// //         _hasReachedMax = true;
// //       }
// //     }

// //     // Add new items with memory management
// //     _items.addAll(response.items);
// //     _totalCount = response.totalCount;

// //     // Memory management: trim cache if needed
// //     if (config.maxCacheSize > 0 && _items.length > config.maxCacheSize) {
// //       final excessItems = _items.length - config.maxCacheSize;
// //       _items.removeRange(0, excessItems);
// //     }

// //     _isLoading = false;
// //     if (!_disposed) notifyListeners();
// //   }

// //   /// Add a single item to the list
// //   void addItem(T item, {int? index}) {
// //     if (_disposed) return;
    
// //     if (index != null && index >= 0 && index <= _items.length) {
// //       _items.insert(index, item);
// //     } else {
// //       _items.add(item);
// //     }
    
// //     // Update total count if we know it
// //     if (_totalCount != null) {
// //       _totalCount = _totalCount! + 1;
// //     }
    
// //     notifyListeners();
// //   }

// //   /// Remove an item from the list
// //   bool removeItem(T item) {
// //     if (_disposed) return false;
    
// //     final removed = _items.remove(item);
// //     if (removed) {
// //       // Update total count if we know it
// //       if (_totalCount != null && _totalCount! > 0) {
// //         _totalCount = _totalCount! - 1;
// //       }
// //       notifyListeners();
// //     }
// //     return removed;
// //   }

// //   /// Remove an item at a specific index
// //   T? removeAt(int index) {
// //     if (_disposed || index < 0 || index >= _items.length) return null;
    
// //     final item = _items.removeAt(index);
    
// //     // Update total count if we know it
// //     if (_totalCount != null && _totalCount! > 0) {
// //       _totalCount = _totalCount! - 1;
// //     }
    
// //     notifyListeners();
// //     return item;
// //   }

// //   /// Update an item in the list
// //   bool updateItem(int index, T item) {
// //     if (_disposed || index < 0 || index >= _items.length) return false;
    
// //     _items[index] = item;
// //     notifyListeners();
// //     return true;
// //   }

// //   /// Update an item by finding it in the list
// //   bool updateItemWhere(bool Function(T) test, T newItem) {
// //     if (_disposed) return false;
    
// //     final index = _items.indexWhere(test);
// //     if (index != -1) {
// //       _items[index] = newItem;
// //       notifyListeners();
// //       return true;
// //     }
// //     return false;
// //   }

// //   /// Insert an item at a specific index
// //   void insertItem(int index, T item) {
// //     if (_disposed) return;
    
// //     if (index >= 0 && index <= _items.length) {
// //       _items.insert(index, item);
      
// //       // Update total count if we know it
// //       if (_totalCount != null) {
// //         _totalCount = _totalCount! + 1;
// //       }
      
// //       notifyListeners();
// //     }
// //   }

// //   /// Clear all items
// //   void clear() {
// //     if (_disposed) return;
    
// //     _items.clear();
// //     _hasReachedMax = false;
// //     _hasError = false;
// //     _errorMessage = null;
// //     _totalCount = null;
// //     _currentPageKey = config.firstPageKey;
// //     _retryCount = 0;
// //     notifyListeners();
// //   }

// //   /// Find item by condition
// //   T? findItem(bool Function(T) test) {
// //     if (_disposed) return null;
    
// //     try {
// //       return _items.firstWhere(test);
// //     } catch (e) {
// //       return null;
// //     }
// //   }

// //   /// Find item index by condition
// //   int findIndex(bool Function(T) test) {
// //     if (_disposed) return -1;
// //     return _items.indexWhere(test);
// //   }

// //   @override
// //   void dispose() {
// //     _disposed = true;
// //     _items.clear();
// //     _fetchFunction = null;
// //     super.dispose();
// //   }

// //   @override
// //   void notifyListeners() {
// //     if (!_disposed) {
// //       super.notifyListeners();
// //     }
// //   }
// // }

// // /// Advanced pagination widget that handles infinite scroll
// // class AdvancedPaginationView<T> extends StatefulWidget {
// //   /// Controller that manages pagination state
// //   final PaginationController<T> controller;

// //   /// Function that fetches data for a given page key and limit
// //   final Future<PageResponse<T>> Function(dynamic pageKey, int limit) onFetchData;

// //   /// Builder for individual items
// //   final Widget Function(BuildContext context, T item, int index) itemBuilder;

// //   /// Builder for loading indicator
// //   final Widget Function(BuildContext context)? loadingBuilder;

// //   /// Builder for error state
// //   final Widget Function(BuildContext context, String error, VoidCallback retry)?
// //       errorBuilder;

// //   /// Builder for empty state
// //   final Widget Function(BuildContext context)? emptyBuilder;

// //   /// Builder for loading more indicator at the bottom
// //   final Widget Function(BuildContext context)? loadingMoreBuilder;

// //   /// Physics for the scroll view
// //   final ScrollPhysics? physics;

// //   /// Padding for the list
// //   final EdgeInsetsGeometry? padding;

// //   /// Whether to show loading more indicator
// //   final bool showLoadingMore;

// //   /// Whether to enable pull-to-refresh
// //   final bool enableRefresh;

// //   /// Scroll controller (optional)
// //   final ScrollController? scrollController;

// //   /// Item extent for performance optimization
// //   final double? itemExtent;

// //   /// Separator builder
// //   final Widget Function(BuildContext context, int index)? separatorBuilder;

// //   /// Key for the list view (for maintaining scroll position)
// //   final Key? listViewKey;

// //   const AdvancedPaginationView({
// //     super.key,
// //     required this.controller,
// //     required this.onFetchData,
// //     required this.itemBuilder,
// //     this.loadingBuilder,
// //     this.errorBuilder,
// //     this.emptyBuilder,
// //     this.loadingMoreBuilder,
// //     this.physics,
// //     this.padding,
// //     this.showLoadingMore = true,
// //     this.enableRefresh = true,
// //     this.scrollController,
// //     this.itemExtent,
// //     this.separatorBuilder,
// //     this.listViewKey,
// //   });

// //   @override
// //   State<AdvancedPaginationView<T>> createState() =>
// //       _AdvancedPaginationViewState<T>();
// // }

// // class _AdvancedPaginationViewState<T>
// //     extends State<AdvancedPaginationView<T>> {
// //   late ScrollController _scrollController;
// //   bool _isLoadingMore = false;

// //   @override
// //   void initState() {
// //     super.initState();
// //     _scrollController = widget.scrollController ?? ScrollController();
// //     _scrollController.addListener(_onScroll);

// //     // Initialize controller if not already done
// //     WidgetsBinding.instance.addPostFrameCallback((_) {
// //       if (!widget.controller.isDisposed) {
// //         widget.controller.initialize(widget.onFetchData);
// //       }
// //     });
// //   }

// //   @override
// //   void dispose() {
// //     _scrollController.removeListener(_onScroll);
// //     if (widget.scrollController == null) {
// //       _scrollController.dispose();
// //     }
// //     super.dispose();
// //   }

// //   void _onScroll() {
// //     if (widget.controller.isDisposed || !mounted) return;
    
// //     // Load more when approaching the bottom
// //     if (_scrollController.position.pixels >=
// //         _scrollController.position.maxScrollExtent - 200) {
// //       _loadMore();
// //     }
// //   }

// //   Future<void> _loadMore() async {
// //     if (_isLoadingMore || widget.controller.isDisposed) return;
    
// //     _isLoadingMore = true;
// //     await widget.controller.loadNextPage();
// //     if (mounted) {
// //       _isLoadingMore = false;
// //     }
// //   }

// //   Widget _buildLoadingIndicator() {
// //     return widget.loadingBuilder?.call(context) ??
// //         const Center(
// //           child: Padding(
// //             padding: EdgeInsets.all(16.0),
// //             child: CircularProgressIndicator(),
// //           ),
// //         );
// //   }

// //   Widget _buildErrorView(String error) {
// //     return widget.errorBuilder?.call(context, error, widget.controller.retry) ??
// //         Center(
// //           child: Padding(
// //             padding: const EdgeInsets.all(16.0),
// //             child: Column(
// //               mainAxisAlignment: MainAxisAlignment.center,
// //               children: [
// //                 Icon(
// //                   Icons.error_outline,
// //                   size: 64,
// //                   color: Theme.of(context).colorScheme.error,
// //                 ),
// //                 const SizedBox(height: 16),
// //                 Text(
// //                   'Something went wrong',
// //                   style: Theme.of(context).textTheme.headlineSmall,
// //                 ),
// //                 const SizedBox(height: 8),
// //                 Text(
// //                   error,
// //                   textAlign: TextAlign.center,
// //                   style: Theme.of(context).textTheme.bodyMedium,
// //                 ),
// //                 const SizedBox(height: 16),
// //                 ElevatedButton(
// //                   onPressed: widget.controller.retry,
// //                   child: const Text('Retry'),
// //                 ),
// //               ],
// //             ),
// //           ),
// //         );
// //   }

// //   Widget _buildEmptyView() {
// //     return widget.emptyBuilder?.call(context) ??
// //         Center(
// //           child: Padding(
// //             padding: const EdgeInsets.all(16.0),
// //             child: Column(
// //               mainAxisAlignment: MainAxisAlignment.center,
// //               children: [
// //                 Icon(
// //                   Icons.inbox_outlined,
// //                   size: 64,
// //                   color: Theme.of(context)
// //                       .colorScheme
// //                       .onSurface
// //                       .withValues(alpha: 0.6),
// //                 ),
// //                 const SizedBox(height: 16),
// //                 Text(
// //                   'No items found',
// //                   style: Theme.of(context).textTheme.headlineSmall,
// //                 ),
// //                 const SizedBox(height: 8),
// //                 Text(
// //                   'Pull down to refresh',
// //                   style: Theme.of(context).textTheme.bodyMedium?.copyWith(
// //                         color: Theme.of(context)
// //                             .colorScheme
// //                             .onSurface
// //                             .withValues(alpha: 0.6),
// //                       ),
// //                 ),
// //               ],
// //             ),
// //           ),
// //         );
// //   }

// //   Widget _buildLoadingMoreIndicator() {
// //     return widget.loadingMoreBuilder?.call(context) ??
// //         const Padding(
// //           padding: EdgeInsets.all(16.0),
// //           child: Center(
// //             child: SizedBox(
// //               width: 24,
// //               height: 24,
// //               child: CircularProgressIndicator(strokeWidth: 2),
// //             ),
// //           ),
// //         );
// //   }

// //   Widget _buildList() {
// //     final itemCount = widget.controller.items.length +
// //         (widget.showLoadingMore &&
// //                 widget.controller.isLoading &&
// //                 widget.controller.items.isNotEmpty
// //             ? 1
// //             : 0);

// //     if (widget.separatorBuilder != null) {
// //       return ListView.separated(
// //         key: widget.listViewKey,
// //         controller: _scrollController,
// //         physics: widget.physics ?? const AlwaysScrollableScrollPhysics(),
// //         padding: widget.padding,
// //         itemCount: widget.controller.items.length,
// //         itemBuilder: (context, index) => _buildListItem(context, index),
// //         separatorBuilder: widget.separatorBuilder!,
// //       );
// //     }

// //     return ListView.builder(
// //       key: widget.listViewKey,
// //       controller: _scrollController,
// //       physics: widget.physics ?? const AlwaysScrollableScrollPhysics(),
// //       padding: widget.padding,
// //       itemCount: itemCount,
// //       itemExtent: widget.itemExtent,
// //       itemBuilder: (context, index) => _buildListItem(context, index),
// //     );
// //   }

// //   Widget _buildListItem(BuildContext context, int index) {
// //     // Show loading more indicator
// //     if (index >= widget.controller.items.length) {
// //       return _buildLoadingMoreIndicator();
// //     }

// //     // Trigger load more when approaching end
// //     if (index >= widget.controller.items.length - widget.controller.config.loadMoreThreshold) {
// //       WidgetsBinding.instance.addPostFrameCallback((_) {
// //         _loadMore();
// //       });
// //     }

// //     return widget.itemBuilder(context, widget.controller.items[index], index);
// //   }

// //   @override
// //   Widget build(BuildContext context) {
// //     if (widget.controller.isDisposed) {
// //       return const SizedBox.shrink();
// //     }
    
// //     return AnimatedBuilder(
// //       animation: widget.controller,
// //       builder: (context, child) {
// //         // Show loading for initial load
// //         if (widget.controller.isEmpty && widget.controller.isLoading) {
// //           return _buildLoadingIndicator();
// //         }

// //         // Show error if there's an error and no items
// //         if (widget.controller.hasError && widget.controller.items.isEmpty) {
// //           return _buildErrorView(
// //             widget.controller.errorMessage ?? 'Unknown error',
// //           );
// //         }

// //         // Show empty state
// //         if (widget.controller.isEmpty) {
// //           return widget.enableRefresh
// //               ? RefreshIndicator(
// //                   onRefresh: widget.controller.refresh,
// //                   child: SingleChildScrollView(
// //                     physics: const AlwaysScrollableScrollPhysics(),
// //                     child: SizedBox(
// //                       height: MediaQuery.of(context).size.height * 0.7,
// //                       child: _buildEmptyView(),
// //                     ),
// //                   ),
// //                 )
// //               : _buildEmptyView();
// //         }

// //         // Build the list with or without refresh indicator
// //         final listWidget = _buildList();

// //         return widget.enableRefresh
// //             ? RefreshIndicator(
// //                 onRefresh: widget.controller.refresh,
// //                 child: listWidget,
// //               )
// //             : listWidget;
// //       },
// //     );
// //   }
// // }

// // /// Example usage widget
// // class PaginationExample extends StatefulWidget {
// //   const PaginationExample({super.key});

// //   @override
// //   State<PaginationExample> createState() => _PaginationExampleState();
// // }

// // class _PaginationExampleState extends State<PaginationExample> {
// //   late PaginationController<String> _controller;

// //   @override
// //   void initState() {
// //     super.initState();
// //     _controller = PaginationController<String>(
// //       config: const PaginationConfig(
// //         limit: 20,
// //         maxCacheSize: 100, // Keep max 100 items in memory
// //         loadMoreThreshold: 5,
// //         maxRetryAttempts: 3,
// //       ),
// //     );
// //   }

// //   @override
// //   void dispose() {
// //     _controller.dispose();
// //     super.dispose();
// //   }

// //   // Mock API call returning PageResponse
// //   Future<PageResponse<String>> _fetchData(dynamic pageKey, int limit) async {
// //     await Future.delayed(
// //       const Duration(milliseconds: 800),
// //     ); // Simulate network delay

// //     int page = pageKey as int;

// //     // Simulate occasional errors for testing
// //     if (page == 3) {
// //       throw Exception('Network error - please try again');
// //     }

// //     // Generate mock data using the provided limit
// //     List<String> items = [];
// //     int startIndex = page * limit;

// //     // Simulate finite data (stop at page 5)
// //     if (page > 5) {
// //       return const PageResponse.lastPage(items: [], totalCount: 120);
// //     }

// //     for (int i = startIndex; i < startIndex + limit; i++) {
// //       items.add('Item ${i + 1}');
// //     }

// //     // Return response with next page key
// //     return PageResponse(
// //       items: items,
// //       nextPageKey: page + 1,
// //       totalCount: 120,
// //     );
// //   }

// //   @override
// //   Widget build(BuildContext context) {
// //     return Scaffold(
// //       appBar: AppBar(
// //         title: const Text('Advanced Pagination'),
// //         backgroundColor: Theme.of(context).colorScheme.inversePrimary,
// //         actions: [
// //           IconButton(
// //             icon: const Icon(Icons.refresh),
// //             onPressed: _controller.refresh,
// //           )
// //         ],
// //       ),
// //       body: AdvancedPaginationView<String>(
// //         controller: _controller,
// //         onFetchData: _fetchData,
// //         itemBuilder: (context, item, index) {
// //           return Card(
// //             margin: const EdgeInsets.symmetric(horizontal: 8.0, vertical: 4.0),
// //             child: ListTile(
// //               leading: CircleAvatar(
// //                 backgroundColor: Theme.of(context).colorScheme.primary,
// //                 child: Text(
// //                   '${index + 1}',
// //                   style: TextStyle(
// //                     color: Theme.of(context).colorScheme.onPrimary,
// //                     fontWeight: FontWeight.bold,
// //                   ),
// //                 ),
// //               ),
// //               title: Text(item),
// //               subtitle: Text(
// //                 'Page ${(index ~/ _controller.config.limit) + 1} • Total: ${_controller.totalCount ?? "?"}',
// //               ),
// //               trailing: PopupMenuButton(
// //                 itemBuilder: (context) => [
// //                   PopupMenuItem(
// //                     child: const Text('Delete'),
// //                     onTap: () => _controller.removeItem(item),
// //                   ),
// //                   PopupMenuItem(
// //                     child: const Text('Duplicate'),
// //                     onTap: () => _controller.addItem('$item (Copy)'),
// //                   ),
// //                 ],
// //               ),
// //             ),
// //           );
// //         },
// //         padding: const EdgeInsets.all(8.0),
// //         // Custom empty state
// //         emptyBuilder: (context) => Center(
// //           child: Column(
// //             mainAxisAlignment: MainAxisAlignment.center,
// //             children: [
// //               Icon(Icons.list_alt, size: 80, color: Colors.grey[400]),
// //               const SizedBox(height: 16),
// //               Text(
// //                 'No items yet',
// //                 style: Theme.of(context).textTheme.headlineSmall,
// //               ),
// //               const SizedBox(height: 8),
// //               Text(
// //                 'Pull to refresh or add some items',
// //                 style: Theme.of(context).textTheme.bodyMedium,
// //               ),
// //             ],
// //           ),
// //         ),
// //         // Custom loading more indicator
// //         loadingMoreBuilder: (context) => Container(
// //           padding: const EdgeInsets.all(16),
// //           alignment: Alignment.center,
// //           child: const Row(
// //             mainAxisAlignment: MainAxisAlignment.center,
// //             children: [
// //               SizedBox(
// //                 width: 16,
// //                 height: 16,
// //                 child: CircularProgressIndicator(strokeWidth: 2),
// //               ),
// //               SizedBox(width: 12),
// //               Text('Loading more...'),
// //             ],
// //           ),
// //         ),
// //       ),
// //       floatingActionButton: FloatingActionButton(
// //         onPressed: () {
// //           _controller.addItem('New Item ${_controller.items.length + 1}');
// //         },
// //         child: const Icon(Icons.add),
// //       ),
// //     );
// //   }
// // }


// /// Old code
// // import 'dart:developer';

// // import 'package:flutter/material.dart';

// // /// Response class for paginated data
// // class PageResponse<T> {
// //   /// The items for this page
// //   final List<T> items;

// //   /// Key for the next page (can be page number, cursor, etc.)
// //   final dynamic nextPageKey;

// //   /// Whether this is the last page
// //   final bool isLastPage;

// //   /// Total count of items (optional)
// //   final int? totalCount;

// //   const PageResponse({required this.items, this.nextPageKey, bool? isLastPage, this.totalCount})
// //     : isLastPage = isLastPage ?? (nextPageKey == null);

// //   /// Create a response indicating the last page
// //   const PageResponse.lastPage({required this.items, this.totalCount}) : nextPageKey = null, isLastPage = true;

// //   /// Check if there are more pages
// //   bool get hasNextPage => !isLastPage;

// //   /// Get the count of items in this page
// //   int get itemCount => items.length;

// //   @override
// //   String toString() => 'PageResponse(items: ${items.length}, nextPageKey: $nextPageKey, isLastPage: $isLastPage)';
// // }

// // /// Configuration for pagination behavior
// // class PaginationConfig {
// //   /// Items per page
// //   final int limit;

// //   /// Initial page key (usually 1 or 0)
// //   final dynamic firstPageKey;

// //   /// Whether to use page-based or cursor-based pagination
// //   final bool isPageBased;

// //   /// Threshold for loading next page (items from end)
// //   final int loadMoreThreshold;

// //   /// Maximum number of items to keep in memory (0 = no limit)
// //   final int maxCacheSize;

// //   const PaginationConfig({
// //     this.limit = 20,
// //     this.firstPageKey = 0,
// //     this.isPageBased = true,
// //     this.loadMoreThreshold = 3,
// //     this.maxCacheSize = 0,
// //   });

// //   /// Get the next page key based on current key and pagination type
// //   dynamic getNextPageKey(dynamic currentKey, int itemsReceived) {
// //     if (!isPageBased) return null; // For cursor-based, use the provided nextPageKey

// //     // For page-based pagination
// //     if (currentKey is int) {
// //       // Only increment if we received items
// //       return itemsReceived > 0 ? currentKey + 1 : null;
// //     }
// //     return null;
// //   }

// //   /// Check if we've reached the end based on items received vs limit
// //   bool shouldMarkAsLastPage(int itemsReceived) {
// //     return itemsReceived < limit;
// //   }
// // }

// // /// Pagination controller that manages the state of paginated data
// // class PaginationController<T> extends ChangeNotifier {
// //   final List<T> _items = [];
// //   bool _isLoading = false;
// //   bool _hasError = false;
// //   String? _errorMessage;
// //   bool _hasReachedMax = false;
// //   dynamic _currentPageKey;

// //   /// Configuration for pagination behavior
// //   final PaginationConfig config;

// //   /// Total count of items (if provided by API)
// //   int? _totalCount;

// //   // Getters
// //   List<T> get items => List.unmodifiable(_items);
// //   bool get isLoading => _isLoading;
// //   bool get hasError => _hasError;
// //   String? get errorMessage => _errorMessage;
// //   bool get hasReachedMax => _hasReachedMax;
// //   dynamic get currentPageKey => _currentPageKey;
// //   bool get isEmpty => _items.isEmpty && !_isLoading;
// //   int? get totalCount => _totalCount;
// //   int get itemCount => _items.length;

// //   /// Function that fetches data for a given page key
// //   Future<PageResponse<T>> Function(dynamic pageKey)? _fetchFunction;

// //   PaginationController({PaginationConfig? config})
// //     : config = config ?? const PaginationConfig(),
// //       _currentPageKey = config?.firstPageKey ?? 1;

// //   /// Initialize the controller with a fetch function
// //   void initialize(Future<PageResponse<T>> Function(dynamic pageKey, int limit) fetchFunction) {
// //     _fetchFunction = (pageKey) => fetchFunction(pageKey, config.limit);
// //     refresh();
// //   }

// //   /// Load the first page (refresh)
// //   Future<void> refresh() async {
// //     _currentPageKey = config.firstPageKey;
// //     _items.clear();
// //     _hasReachedMax = false;
// //     _hasError = false;
// //     _errorMessage = null;
// //     _totalCount = null;
// //     notifyListeners();

// //     await _loadPage();
// //   }

// //   /// Load the next page
// //   Future<void> loadNextPage() async {
// //     if (_isLoading || _hasReachedMax || _hasError) return;

// //     await _loadPage();
// //   }

// //   /// Internal method to load a page
// //   Future<void> _loadPage() async {
// //     if (_fetchFunction == null) return;

// //     _isLoading = true;
// //     _hasError = false;
// //     _errorMessage = null;
// //     notifyListeners();

// //     try {
// //       final response = await _fetchFunction!(_currentPageKey);

// //       if (response.items.isEmpty || response.isLastPage) {
// //         _hasReachedMax = true;
// //       } else {
// //         // Use provided nextPageKey or calculate it
// //         _currentPageKey = response.nextPageKey ?? config.getNextPageKey(_currentPageKey, response.items.length);

// //         // Check if we should mark as last page based on config
// //         if (config.shouldMarkAsLastPage(response.items.length) && response.nextPageKey == null) {
// //           _hasReachedMax = true;
// //         }

// //         if (_currentPageKey == null) {
// //           _hasReachedMax = true;
// //         }
// //       }

// //       // Add new items with memory management
// //       _items.addAll(response.items);
// //       _totalCount = response.totalCount;

// //       // Memory management: trim cache if needed
// //       if (config.maxCacheSize > 0 && _items.length > config.maxCacheSize) {
// //         final excessItems = _items.length - config.maxCacheSize;
// //         _items.removeRange(0, excessItems);
// //       }
// //     } catch (error) {
// //       _hasError = true;
// //       _errorMessage = error.toString();
// //     } finally {
// //       _isLoading = false;
// //       notifyListeners();
// //     }
// //   }

// //   /// Add a single item to the list
// //   void addItem(T item) {
// //     _items.add(item);
// //     notifyListeners();
// //   }

// //   /// Remove an item from the list
// //   void removeItem(T item) {
// //     _items.remove(item);
// //     notifyListeners();
// //   }

// //   /// Update an item in the list
// //   void updateItem(int index, T item) {
// //     if (index >= 0 && index < _items.length) {
// //       _items[index] = item;
// //       notifyListeners();
// //     }
// //   }

// //   /// Insert an item at a specific index
// //   void insertItem(int index, T item) {
// //     if (index >= 0 && index <= _items.length) {
// //       _items.insert(index, item);
// //       notifyListeners();
// //     }
// //   }

// //   /// Clear all items
// //   void clear() {
// //     _items.clear();
// //     _hasReachedMax = false;
// //     _hasError = false;
// //     _errorMessage = null;
// //     _totalCount = null;
// //     _currentPageKey = config.firstPageKey;
// //     notifyListeners();
// //   }

// //   @override
// //   void dispose() {
// //     super.dispose();
// //   }
// // }

// // /// Advanced pagination widget that handles infinite scroll
// // class AdvancedPaginationView<T> extends StatefulWidget {
// //   /// Controller that manages pagination state
// //   final PaginationController<T> controller;

// //   /// Function that fetches data for a given page key and limit
// //   final Future<PageResponse<T>> Function(dynamic pageKey, int limit) onFetchData;

// //   /// Builder for individual items
// //   final Widget Function(BuildContext context, T item, int index) itemBuilder;

// //   /// Builder for loading indicator
// //   final Widget Function(BuildContext context)? loadingBuilder;

// //   /// Builder for error state
// //   final Widget Function(BuildContext context, String error, VoidCallback retry)? errorBuilder;

// //   /// Builder for empty state
// //   final Widget Function(BuildContext context)? emptyBuilder;

// //   /// Builder for loading more indicator at the bottom
// //   final Widget Function(BuildContext context)? loadingMoreBuilder;

// //   /// Physics for the scroll view
// //   final ScrollPhysics? physics;

// //   /// Padding for the list
// //   final EdgeInsetsGeometry? padding;

// //   /// Whether to show loading more indicator
// //   final bool showLoadingMore;

// //   /// Threshold for loading next page (items from end)
// //   final int loadMoreThreshold;

// //   /// Whether to enable pull-to-refresh
// //   final bool enableRefresh;

// //   /// Scroll controller (optional)
// //   final ScrollController? scrollController;

// //   const AdvancedPaginationView({
// //     super.key,
// //     required this.controller,
// //     required this.onFetchData,
// //     required this.itemBuilder,
// //     this.loadingBuilder,
// //     this.errorBuilder,
// //     this.emptyBuilder,
// //     this.loadingMoreBuilder,
// //     this.physics,
// //     this.padding,
// //     this.showLoadingMore = true,
// //     this.loadMoreThreshold = 3,
// //     this.enableRefresh = true,
// //     this.scrollController,
// //   });

// //   @override
// //   State<AdvancedPaginationView<T>> createState() => _AdvancedPaginationViewState<T>();
// // }

// // class _AdvancedPaginationViewState<T> extends State<AdvancedPaginationView<T>> {
// //   late ScrollController _scrollController;

// //   @override
// //   void initState() {
// //     super.initState();
// //     _scrollController = widget.scrollController ?? ScrollController();
// //     _scrollController.addListener(_onScroll);

// //     if (widget.controller._fetchFunction == null) {
// //       widget.controller.initialize((pageKey, limit) => widget.onFetchData(pageKey, limit));
// //     }
// //   }

// //   @override
// //   void dispose() {
// //     if (widget.scrollController == null) {
// //       _scrollController.dispose();
// //     }
// //     super.dispose();
// //   }

// //   void _onScroll() {
// //     if (_scrollController.position.pixels >= _scrollController.position.maxScrollExtent - 200) {
// //       widget.controller.loadNextPage();
// //     }
// //   }

// //   Widget _buildLoadingIndicator() {
// //     return widget.loadingBuilder?.call(context) ??
// //         const Center(child: Padding(padding: EdgeInsets.all(16.0), child: CircularProgressIndicator()));
// //   }

// //   Widget _buildErrorView(String error) {
// //     return widget.errorBuilder?.call(context, error, widget.controller.refresh) ??
// //         Center(
// //           child: Padding(
// //             padding: const EdgeInsets.all(16.0),
// //             child: Column(
// //               mainAxisAlignment: MainAxisAlignment.center,
// //               children: [
// //                 Icon(Icons.error_outline, size: 64, color: Theme.of(context).colorScheme.error),
// //                 const SizedBox(height: 16),
// //                 Text('Something went wrong', style: Theme.of(context).textTheme.headlineSmall),
// //                 const SizedBox(height: 8),
// //                 Text(error, textAlign: TextAlign.center, style: Theme.of(context).textTheme.bodyMedium),
// //                 const SizedBox(height: 16),
// //                 ElevatedButton(onPressed: widget.controller.refresh, child: const Text('Retry')),
// //               ],
// //             ),
// //           ),
// //         );
// //   }

// //   Widget _buildEmptyView() {
// //     return widget.emptyBuilder?.call(context) ??
// //         Center(
// //           child: Padding(
// //             padding: const EdgeInsets.all(16.0),
// //             child: Column(
// //               mainAxisAlignment: MainAxisAlignment.center,
// //               children: [
// //                 Icon(Icons.inbox_outlined, size: 64, color: Theme.of(context).colorScheme.onSurface.withValues(alpha: 0.6)),
// //                 const SizedBox(height: 16),
// //                 Text('No items found', style: Theme.of(context).textTheme.headlineSmall),
// //                 const SizedBox(height: 8),
// //                 Text(
// //                   'Pull down to refresh',
// //                   style: Theme.of(context).textTheme.bodyMedium?.copyWith(color: Theme.of(context).colorScheme.onSurface.withValues(alpha: 0.6)),
// //                 ),
// //               ],
// //             ),
// //           ),
// //         );
// //   }

// //   Widget _buildLoadingMoreIndicator() {
// //     return widget.loadingMoreBuilder?.call(context) ??
// //         const Padding(
// //           padding: EdgeInsets.all(16.0),
// //           child: Center(child: SizedBox(width: 24, height: 24, child: CircularProgressIndicator(strokeWidth: 2))),
// //         );
// //   }

// //   Widget _buildList() {
// //     return ListView.builder(
// //       controller: _scrollController,
// //       physics: widget.physics ?? const AlwaysScrollableScrollPhysics(),
// //       padding: widget.padding,
// //       itemCount:
// //           widget.controller.items.length +
// //           (widget.showLoadingMore && widget.controller.isLoading && widget.controller.items.isNotEmpty ? 1 : 0),
// //       itemBuilder: (context, index) {
// //         // Show loading more indicator
// //         if (index >= widget.controller.items.length) {
// //           return _buildLoadingMoreIndicator();
// //         }

// //         // Trigger load more when approaching end
// //         if (index >= widget.controller.items.length - widget.loadMoreThreshold) {
// //           WidgetsBinding.instance.addPostFrameCallback((_) {
// //             widget.controller.loadNextPage();
// //           });
// //         }

// //         return widget.itemBuilder(context, widget.controller.items[index], index);
// //       },
// //     );
// //   }

// //   @override
// //   Widget build(BuildContext context) {
// //     return AnimatedBuilder(
// //       animation: widget.controller,
// //       builder: (context, child) {
// //         // Show loading for initial load
// //         if (widget.controller.isEmpty && widget.controller.isLoading) {
// //           return _buildLoadingIndicator();
// //         }

// //         // Show error if there's an error and no items
// //         if (widget.controller.hasError && widget.controller.items.isEmpty) {
// //           return _buildErrorView(widget.controller.errorMessage ?? 'Unknown error');
// //         }

// //         // Show empty state
// //         if (widget.controller.isEmpty) {
// //           return widget.enableRefresh
// //               ? RefreshIndicator(
// //                 onRefresh: widget.controller.refresh,
// //                 child: SingleChildScrollView(
// //                   physics: const AlwaysScrollableScrollPhysics(),
// //                   child: SizedBox(height: MediaQuery.of(context).size.height * 0.7, child: _buildEmptyView()),
// //                 ),
// //               )
// //               : _buildEmptyView();
// //         }

// //         // Build the list with or without refresh indicator
// //         final listWidget = _buildList();

// //         return widget.enableRefresh ? RefreshIndicator(onRefresh: widget.controller.refresh, child: listWidget) : listWidget;
// //       },
// //     );
// //   }
// // }

// // /// Example usage widget
// // class PaginationExample extends StatefulWidget {
// //   const PaginationExample({super.key});

// //   @override
// //   State<PaginationExample> createState() => _PaginationExampleState();
// // }

// // class _PaginationExampleState extends State<PaginationExample> {
// //   late PaginationController<String> _controller;

// //   @override
// //   void initState() {
// //     super.initState();
// //     _controller = PaginationController<String>(
// //       config: PaginationConfig(
// //         limit: 2,
// //         maxCacheSize: 30, // Keep max 100 items in memory
// //         loadMoreThreshold: 2,
// //       ),
// //     );
// //   }

// //   @override
// //   void dispose() {
// //     _controller.dispose();
// //     super.dispose();
// //   }

// //   // Mock API call returning PageResponse
// //   Future<PageResponse<String>> _fetchData(dynamic pageKey, int limit) async {
// //     await Future.delayed(Duration(milliseconds: 300)); // Simulate network delay

// //     int page = pageKey as int;

// //     // Generate mock data using the provided limit
// //     List<String> items = [];
// //     int startIndex = (page - 1) * limit;

// //     // // Simulate finite data (stop at page 5)
// //     // if (page > 5) {
// //     //   return PageResponse.lastPage(items: [], totalCount: 50);
// //     // }

// //     for (int i = startIndex; i < startIndex + limit; i++) {
// //       items.add('Item ${i + 1}');
// //       log("item: $i");
// //     }

// //     // Return response with next page key
// //     return PageResponse(items: items, nextPageKey: page + 1, totalCount: 50);
// //   }

// //   @override
// //   Widget build(BuildContext context) {
// //     return Scaffold(
// //       appBar: AppBar(
// //         title: Text('Advanced Pagination'),
// //         backgroundColor: Theme.of(context).colorScheme.inversePrimary,
// //         actions: [IconButton(icon: Icon(Icons.refresh), onPressed: _controller.refresh)],
// //       ),
// //       body: AdvancedPaginationView<String>(
// //         controller: _controller,
// //         onFetchData: _fetchData,
// //         itemBuilder: (context, item, index) {
// //           return Card(
// //             margin: EdgeInsets.symmetric(horizontal: 8.0, vertical: 4.0),
// //             child: ListTile(
// //               leading: CircleAvatar(
// //                 backgroundColor: Theme.of(context).colorScheme.primary,
// //                 child: Text('${index + 1}', style: TextStyle(color: Theme.of(context).colorScheme.onPrimary, fontWeight: FontWeight.bold)),
// //               ),
// //               title: Text(item),
// //               subtitle: Text('Page ${(index ~/ _controller.config.limit) + 1} • Total: ${_controller.totalCount ?? "?"}'),
// //               trailing: PopupMenuButton(
// //                 itemBuilder:
// //                     (context) => [
// //                       PopupMenuItem(child: Text('Delete'), onTap: () => _controller.removeItem(item)),
// //                       PopupMenuItem(child: Text('Duplicate'), onTap: () => _controller.addItem('$item (Copy)')),
// //                     ],
// //               ),
// //             ),
// //           );
// //         },
// //         padding: EdgeInsets.all(8.0),
// //         // Custom empty state
// //         emptyBuilder:
// //             (context) => Center(
// //               child: Column(
// //                 mainAxisAlignment: MainAxisAlignment.center,
// //                 children: [
// //                   Icon(Icons.list_alt, size: 80, color: Colors.grey[400]),
// //                   SizedBox(height: 16),
// //                   Text('No items yet', style: Theme.of(context).textTheme.headlineSmall),
// //                   SizedBox(height: 8),
// //                   Text('Pull to refresh or add some items', style: Theme.of(context).textTheme.bodyMedium),
// //                 ],
// //               ),
// //             ),
// //         // Custom loading more indicator
// //         loadingMoreBuilder:
// //             (context) => Container(
// //               padding: EdgeInsets.all(16),
// //               alignment: Alignment.center,
// //               child: Row(
// //                 mainAxisAlignment: MainAxisAlignment.center,
// //                 children: [
// //                   SizedBox(width: 16, height: 16, child: CircularProgressIndicator(strokeWidth: 2)),
// //                   SizedBox(width: 12),
// //                   Text('Loading more...'),
// //                 ],
// //               ),
// //             ),
// //       ),
// //       floatingActionButton: FloatingActionButton(
// //         onPressed: () {
// //           _controller.addItem('New Item ${_controller.items.length + 1}');
// //         },
// //         child: Icon(Icons.add),
// //       ),
// //     );
// //   }
// // }
