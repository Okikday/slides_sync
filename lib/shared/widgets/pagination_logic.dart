// import 'dart:developer';

// import 'package:flutter/material.dart';

// /// Response class for paginated data
// class PageResponse<T> {
//   /// The items for this page
//   final List<T> items;

//   /// Key for the next page (can be page number, cursor, etc.)
//   final dynamic nextPageKey;

//   /// Whether this is the last page
//   final bool isLastPage;

//   /// Total count of items (optional)
//   final int? totalCount;

//   const PageResponse({required this.items, this.nextPageKey, bool? isLastPage, this.totalCount})
//     : isLastPage = isLastPage ?? (nextPageKey == null);

//   /// Create a response indicating the last page
//   const PageResponse.lastPage({required this.items, this.totalCount}) : nextPageKey = null, isLastPage = true;

//   /// Check if there are more pages
//   bool get hasNextPage => !isLastPage;

//   /// Get the count of items in this page
//   int get itemCount => items.length;

//   @override
//   String toString() => 'PageResponse(items: ${items.length}, nextPageKey: $nextPageKey, isLastPage: $isLastPage)';
// }

// /// Configuration for pagination behavior
// class PaginationConfig {
//   /// Items per page
//   final int limit;

//   /// Initial page key (usually 1 or 0)
//   final dynamic firstPageKey;

//   /// Whether to use page-based or cursor-based pagination
//   final bool isPageBased;

//   /// Threshold for loading next page (items from end)
//   final int loadMoreThreshold;

//   /// Maximum number of items to keep in memory (0 = no limit)
//   final int maxCacheSize;

//   const PaginationConfig({
//     this.limit = 20,
//     this.firstPageKey = 0,
//     this.isPageBased = true,
//     this.loadMoreThreshold = 3,
//     this.maxCacheSize = 0,
//   });

//   /// Get the next page key based on current key and pagination type
//   dynamic getNextPageKey(dynamic currentKey, int itemsReceived) {
//     if (!isPageBased) return null; // For cursor-based, use the provided nextPageKey

//     // For page-based pagination
//     if (currentKey is int) {
//       // Only increment if we received items
//       return itemsReceived > 0 ? currentKey + 1 : null;
//     }
//     return null;
//   }

//   /// Check if we've reached the end based on items received vs limit
//   bool shouldMarkAsLastPage(int itemsReceived) {
//     return itemsReceived < limit;
//   }
// }

// /// Pagination controller that manages the state of paginated data
// class PaginationController<T> extends ChangeNotifier {
//   final List<T> _items = [];
//   bool _isLoading = false;
//   bool _hasError = false;
//   String? _errorMessage;
//   bool _hasReachedMax = false;
//   dynamic _currentPageKey;

//   /// Configuration for pagination behavior
//   final PaginationConfig config;

//   /// Total count of items (if provided by API)
//   int? _totalCount;

//   // Getters
//   List<T> get items => List.unmodifiable(_items);
//   bool get isLoading => _isLoading;
//   bool get hasError => _hasError;
//   String? get errorMessage => _errorMessage;
//   bool get hasReachedMax => _hasReachedMax;
//   dynamic get currentPageKey => _currentPageKey;
//   bool get isEmpty => _items.isEmpty && !_isLoading;
//   int? get totalCount => _totalCount;
//   int get itemCount => _items.length;

//   /// Function that fetches data for a given page key
//   Future<PageResponse<T>> Function(dynamic pageKey)? _fetchFunction;

//   PaginationController({PaginationConfig? config})
//     : config = config ?? const PaginationConfig(),
//       _currentPageKey = config?.firstPageKey ?? 1;

//   /// Initialize the controller with a fetch function
//   void initialize(Future<PageResponse<T>> Function(dynamic pageKey, int limit) fetchFunction) {
//     _fetchFunction = (pageKey) => fetchFunction(pageKey, config.limit);
//     refresh();
//   }

//   /// Load the first page (refresh)
//   Future<void> refresh() async {
//     _currentPageKey = config.firstPageKey;
//     _items.clear();
//     _hasReachedMax = false;
//     _hasError = false;
//     _errorMessage = null;
//     _totalCount = null;
//     notifyListeners();

//     await _loadPage();
//   }

//   /// Load the next page
//   Future<void> loadNextPage() async {
//     if (_isLoading || _hasReachedMax || _hasError) return;

//     await _loadPage();
//   }

//   /// Internal method to load a page
//   Future<void> _loadPage() async {
//     if (_fetchFunction == null) return;

//     _isLoading = true;
//     _hasError = false;
//     _errorMessage = null;
//     notifyListeners();

//     try {
//       final response = await _fetchFunction!(_currentPageKey);

//       if (response.items.isEmpty || response.isLastPage) {
//         _hasReachedMax = true;
//       } else {
//         // Use provided nextPageKey or calculate it
//         _currentPageKey = response.nextPageKey ?? config.getNextPageKey(_currentPageKey, response.items.length);

//         // Check if we should mark as last page based on config
//         if (config.shouldMarkAsLastPage(response.items.length) && response.nextPageKey == null) {
//           _hasReachedMax = true;
//         }

//         if (_currentPageKey == null) {
//           _hasReachedMax = true;
//         }
//       }

//       // Add new items with memory management
//       _items.addAll(response.items);
//       _totalCount = response.totalCount;

//       // Memory management: trim cache if needed
//       if (config.maxCacheSize > 0 && _items.length > config.maxCacheSize) {
//         final excessItems = _items.length - config.maxCacheSize;
//         _items.removeRange(0, excessItems);
//       }
//     } catch (error) {
//       _hasError = true;
//       _errorMessage = error.toString();
//     } finally {
//       _isLoading = false;
//       notifyListeners();
//     }
//   }

//   /// Add a single item to the list
//   void addItem(T item) {
//     _items.add(item);
//     notifyListeners();
//   }

//   /// Remove an item from the list
//   void removeItem(T item) {
//     _items.remove(item);
//     notifyListeners();
//   }

//   /// Update an item in the list
//   void updateItem(int index, T item) {
//     if (index >= 0 && index < _items.length) {
//       _items[index] = item;
//       notifyListeners();
//     }
//   }

//   /// Insert an item at a specific index
//   void insertItem(int index, T item) {
//     if (index >= 0 && index <= _items.length) {
//       _items.insert(index, item);
//       notifyListeners();
//     }
//   }

//   /// Clear all items
//   void clear() {
//     _items.clear();
//     _hasReachedMax = false;
//     _hasError = false;
//     _errorMessage = null;
//     _totalCount = null;
//     _currentPageKey = config.firstPageKey;
//     notifyListeners();
//   }

//   @override
//   void dispose() {
//     super.dispose();
//   }
// }

// /// Advanced pagination widget that handles infinite scroll
// class AdvancedPaginationView<T> extends StatefulWidget {
//   /// Controller that manages pagination state
//   final PaginationController<T> controller;

//   /// Function that fetches data for a given page key and limit
//   final Future<PageResponse<T>> Function(dynamic pageKey, int limit) onFetchData;

//   /// Builder for individual items
//   final Widget Function(BuildContext context, T item, int index) itemBuilder;

//   /// Builder for loading indicator
//   final Widget Function(BuildContext context)? loadingBuilder;

//   /// Builder for error state
//   final Widget Function(BuildContext context, String error, VoidCallback retry)? errorBuilder;

//   /// Builder for empty state
//   final Widget Function(BuildContext context)? emptyBuilder;

//   /// Builder for loading more indicator at the bottom
//   final Widget Function(BuildContext context)? loadingMoreBuilder;

//   /// Physics for the scroll view
//   final ScrollPhysics? physics;

//   /// Padding for the list
//   final EdgeInsetsGeometry? padding;

//   /// Whether to show loading more indicator
//   final bool showLoadingMore;

//   /// Threshold for loading next page (items from end)
//   final int loadMoreThreshold;

//   /// Whether to enable pull-to-refresh
//   final bool enableRefresh;

//   /// Scroll controller (optional)
//   final ScrollController? scrollController;

//   const AdvancedPaginationView({
//     super.key,
//     required this.controller,
//     required this.onFetchData,
//     required this.itemBuilder,
//     this.loadingBuilder,
//     this.errorBuilder,
//     this.emptyBuilder,
//     this.loadingMoreBuilder,
//     this.physics,
//     this.padding,
//     this.showLoadingMore = true,
//     this.loadMoreThreshold = 3,
//     this.enableRefresh = true,
//     this.scrollController,
//   });

//   @override
//   State<AdvancedPaginationView<T>> createState() => _AdvancedPaginationViewState<T>();
// }

// class _AdvancedPaginationViewState<T> extends State<AdvancedPaginationView<T>> {
//   late ScrollController _scrollController;

//   @override
//   void initState() {
//     super.initState();
//     _scrollController = widget.scrollController ?? ScrollController();
//     _scrollController.addListener(_onScroll);

//     if (widget.controller._fetchFunction == null) {
//       widget.controller.initialize((pageKey, limit) => widget.onFetchData(pageKey, limit));
//     }
//   }

//   @override
//   void dispose() {
//     if (widget.scrollController == null) {
//       _scrollController.dispose();
//     }
//     super.dispose();
//   }

//   void _onScroll() {
//     if (_scrollController.position.pixels >= _scrollController.position.maxScrollExtent - 200) {
//       widget.controller.loadNextPage();
//     }
//   }

//   Widget _buildLoadingIndicator() {
//     return widget.loadingBuilder?.call(context) ??
//         const Center(child: Padding(padding: EdgeInsets.all(16.0), child: CircularProgressIndicator()));
//   }

//   Widget _buildErrorView(String error) {
//     return widget.errorBuilder?.call(context, error, widget.controller.refresh) ??
//         Center(
//           child: Padding(
//             padding: const EdgeInsets.all(16.0),
//             child: Column(
//               mainAxisAlignment: MainAxisAlignment.center,
//               children: [
//                 Icon(Icons.error_outline, size: 64, color: Theme.of(context).colorScheme.error),
//                 const SizedBox(height: 16),
//                 Text('Something went wrong', style: Theme.of(context).textTheme.headlineSmall),
//                 const SizedBox(height: 8),
//                 Text(error, textAlign: TextAlign.center, style: Theme.of(context).textTheme.bodyMedium),
//                 const SizedBox(height: 16),
//                 ElevatedButton(onPressed: widget.controller.refresh, child: const Text('Retry')),
//               ],
//             ),
//           ),
//         );
//   }

//   Widget _buildEmptyView() {
//     return widget.emptyBuilder?.call(context) ??
//         Center(
//           child: Padding(
//             padding: const EdgeInsets.all(16.0),
//             child: Column(
//               mainAxisAlignment: MainAxisAlignment.center,
//               children: [
//                 Icon(Icons.inbox_outlined, size: 64, color: Theme.of(context).colorScheme.onSurface.withOpacity(0.6)),
//                 const SizedBox(height: 16),
//                 Text('No items found', style: Theme.of(context).textTheme.headlineSmall),
//                 const SizedBox(height: 8),
//                 Text(
//                   'Pull down to refresh',
//                   style: Theme.of(context).textTheme.bodyMedium?.copyWith(color: Theme.of(context).colorScheme.onSurface.withOpacity(0.6)),
//                 ),
//               ],
//             ),
//           ),
//         );
//   }

//   Widget _buildLoadingMoreIndicator() {
//     return widget.loadingMoreBuilder?.call(context) ??
//         const Padding(
//           padding: EdgeInsets.all(16.0),
//           child: Center(child: SizedBox(width: 24, height: 24, child: CircularProgressIndicator(strokeWidth: 2))),
//         );
//   }

//   Widget _buildList() {
//     return ListView.builder(
//       controller: _scrollController,
//       physics: widget.physics ?? const AlwaysScrollableScrollPhysics(),
//       padding: widget.padding,
//       itemCount:
//           widget.controller.items.length +
//           (widget.showLoadingMore && widget.controller.isLoading && widget.controller.items.isNotEmpty ? 1 : 0),
//       itemBuilder: (context, index) {
//         // Show loading more indicator
//         if (index >= widget.controller.items.length) {
//           return _buildLoadingMoreIndicator();
//         }

//         // Trigger load more when approaching end
//         if (index >= widget.controller.items.length - widget.loadMoreThreshold) {
//           WidgetsBinding.instance.addPostFrameCallback((_) {
//             widget.controller.loadNextPage();
//           });
//         }

//         return widget.itemBuilder(context, widget.controller.items[index], index);
//       },
//     );
//   }

//   @override
//   Widget build(BuildContext context) {
//     return AnimatedBuilder(
//       animation: widget.controller,
//       builder: (context, child) {
//         // Show loading for initial load
//         if (widget.controller.isEmpty && widget.controller.isLoading) {
//           return _buildLoadingIndicator();
//         }

//         // Show error if there's an error and no items
//         if (widget.controller.hasError && widget.controller.items.isEmpty) {
//           return _buildErrorView(widget.controller.errorMessage ?? 'Unknown error');
//         }

//         // Show empty state
//         if (widget.controller.isEmpty) {
//           return widget.enableRefresh
//               ? RefreshIndicator(
//                 onRefresh: widget.controller.refresh,
//                 child: SingleChildScrollView(
//                   physics: const AlwaysScrollableScrollPhysics(),
//                   child: SizedBox(height: MediaQuery.of(context).size.height * 0.7, child: _buildEmptyView()),
//                 ),
//               )
//               : _buildEmptyView();
//         }

//         // Build the list with or without refresh indicator
//         final listWidget = _buildList();

//         return widget.enableRefresh ? RefreshIndicator(onRefresh: widget.controller.refresh, child: listWidget) : listWidget;
//       },
//     );
//   }
// }

// /// Example usage widget
// class PaginationExample extends StatefulWidget {
//   const PaginationExample({super.key});

//   @override
//   State<PaginationExample> createState() => _PaginationExampleState();
// }

// class _PaginationExampleState extends State<PaginationExample> {
//   late PaginationController<String> _controller;

//   @override
//   void initState() {
//     super.initState();
//     _controller = PaginationController<String>(
//       config: PaginationConfig(
//         limit: 2,
//         maxCacheSize: 30, // Keep max 100 items in memory
//         loadMoreThreshold: 2,
//       ),
//     );
//   }

//   @override
//   void dispose() {
//     _controller.dispose();
//     super.dispose();
//   }

//   // Mock API call returning PageResponse
//   Future<PageResponse<String>> _fetchData(dynamic pageKey, int limit) async {
//     await Future.delayed(Duration(milliseconds: 300)); // Simulate network delay

//     int page = pageKey as int;

//     // Generate mock data using the provided limit
//     List<String> items = [];
//     int startIndex = (page - 1) * limit;

//     // // Simulate finite data (stop at page 5)
//     // if (page > 5) {
//     //   return PageResponse.lastPage(items: [], totalCount: 50);
//     // }

//     for (int i = startIndex; i < startIndex + limit; i++) {
//       items.add('Item ${i + 1}');
//       log("item: $i");
//     }

//     // Return response with next page key
//     return PageResponse(items: items, nextPageKey: page + 1, totalCount: 50);
//   }

//   @override
//   Widget build(BuildContext context) {
//     return Scaffold(
//       appBar: AppBar(
//         title: Text('Advanced Pagination'),
//         backgroundColor: Theme.of(context).colorScheme.inversePrimary,
//         actions: [IconButton(icon: Icon(Icons.refresh), onPressed: _controller.refresh)],
//       ),
//       body: AdvancedPaginationView<String>(
//         controller: _controller,
//         onFetchData: _fetchData,
//         itemBuilder: (context, item, index) {
//           return Card(
//             margin: EdgeInsets.symmetric(horizontal: 8.0, vertical: 4.0),
//             child: ListTile(
//               leading: CircleAvatar(
//                 backgroundColor: Theme.of(context).colorScheme.primary,
//                 child: Text('${index + 1}', style: TextStyle(color: Theme.of(context).colorScheme.onPrimary, fontWeight: FontWeight.bold)),
//               ),
//               title: Text(item),
//               subtitle: Text('Page ${(index ~/ _controller.config.limit) + 1} • Total: ${_controller.totalCount ?? "?"}'),
//               trailing: PopupMenuButton(
//                 itemBuilder:
//                     (context) => [
//                       PopupMenuItem(child: Text('Delete'), onTap: () => _controller.removeItem(item)),
//                       PopupMenuItem(child: Text('Duplicate'), onTap: () => _controller.addItem('$item (Copy)')),
//                     ],
//               ),
//             ),
//           );
//         },
//         padding: EdgeInsets.all(8.0),
//         // Custom empty state
//         emptyBuilder:
//             (context) => Center(
//               child: Column(
//                 mainAxisAlignment: MainAxisAlignment.center,
//                 children: [
//                   Icon(Icons.list_alt, size: 80, color: Colors.grey[400]),
//                   SizedBox(height: 16),
//                   Text('No items yet', style: Theme.of(context).textTheme.headlineSmall),
//                   SizedBox(height: 8),
//                   Text('Pull to refresh or add some items', style: Theme.of(context).textTheme.bodyMedium),
//                 ],
//               ),
//             ),
//         // Custom loading more indicator
//         loadingMoreBuilder:
//             (context) => Container(
//               padding: EdgeInsets.all(16),
//               alignment: Alignment.center,
//               child: Row(
//                 mainAxisAlignment: MainAxisAlignment.center,
//                 children: [
//                   SizedBox(width: 16, height: 16, child: CircularProgressIndicator(strokeWidth: 2)),
//                   SizedBox(width: 12),
//                   Text('Loading more...'),
//                 ],
//               ),
//             ),
//       ),
//       floatingActionButton: FloatingActionButton(
//         onPressed: () {
//           _controller.addItem('New Item ${_controller.items.length + 1}');
//         },
//         child: Icon(Icons.add),
//       ),
//     );
//   }
// }
