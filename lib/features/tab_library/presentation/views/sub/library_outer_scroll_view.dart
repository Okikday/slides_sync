import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:slides_sync/features/main/presentation/providers/main_providers.dart';
import 'package:slides_sync/features/tab_library/presentation/providers/is_list_view_notifier.dart';
import 'package:slides_sync/features/tab_library/presentation/views/sub/library_inner_scroll_view.dart';
import 'package:slides_sync/features/tab_library/presentation/views/library_tab_view/library_tab_view_app_bar.dart';

class LibraryOuterScrollView extends ConsumerWidget {
  const LibraryOuterScrollView({super.key, required this.scrollOffsetProvider, required this.isListViewAsyncProvider});

  final StateProvider<double> scrollOffsetProvider;
  final AsyncNotifierProvider<IsListViewNotifier, bool> isListViewAsyncProvider;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    return NotificationListener(
      onNotification: (notification) {
        if (notification is ScrollUpdateNotification) {
          final offset = double.parse(notification.metrics.pixels.toStringAsFixed(2));
          ref.read(scrollOffsetProvider.notifier).update((cb) => offset);
        }
        return true;
      },
      child: NestedScrollView(
        physics: NeverScrollableScrollPhysics(),
        headerSliverBuilder: (context, isInnerBoxScrolled) {
          if (ref.read(mainTabViewIndexProvider.notifier).state == 1) {
            final currValue = ref.read(isMainScrolledProvider.notifier).state;
            if (currValue != isInnerBoxScrolled) {
              WidgetsBinding.instance.addPostFrameCallback(
                (_) => ref.read(isMainScrolledProvider.notifier).update((cb) => isInnerBoxScrolled),
              );
            }
          }

          return [LibraryTabViewAppBar(isListViewAsyncProvider: isListViewAsyncProvider, scrollOffsetProvider: scrollOffsetProvider)];
        },

        // Body section
        body: LibraryInnerScrollView(isListViewAsyncProvider: isListViewAsyncProvider),
      ),
    );
  }
}
