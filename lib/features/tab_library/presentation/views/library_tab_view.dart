import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:slides_sync/features/tab_library/presentation/providers/is_list_view_notifier.dart';
import 'package:slides_sync/features/main/presentation/providers/main_providers.dart';
import 'package:slides_sync/features/tab_library/presentation/views/sub/library_outer_scroll_view.dart';

class LibraryTabView extends ConsumerStatefulWidget {
  const LibraryTabView({super.key});

  @override
  ConsumerState createState() => _LibraryTabViewState();
}

class _LibraryTabViewState extends ConsumerState<LibraryTabView> with AutomaticKeepAliveClientMixin {
  late final AsyncNotifierProvider<IsListViewNotifier, bool> isListViewAsyncProvider;
  late final StateProvider<double> scrollOffsetProvider;

  @override
  void initState() {
    super.initState();
    isListViewAsyncProvider = AsyncNotifierProvider<IsListViewNotifier, bool>(IsListViewNotifier.new);
    scrollOffsetProvider = StateProvider<double>((ref) => 0.0);
    WidgetsBinding.instance.addPostFrameCallback((_) {
      if (ref.read(mainTabViewIndexProvider.notifier).state == 1) {
        ref.read(isMainScrolledProvider.notifier).update((cb) => false);
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    super.build(context);

    return LibraryOuterScrollView(scrollOffsetProvider: scrollOffsetProvider, isListViewAsyncProvider: isListViewAsyncProvider);
  }

  @override
  bool get wantKeepAlive => true;
}
