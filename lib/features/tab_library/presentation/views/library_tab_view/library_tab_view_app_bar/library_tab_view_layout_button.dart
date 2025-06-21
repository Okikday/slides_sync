import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:iconsax_flutter/iconsax_flutter.dart';
import 'package:slides_sync/features/tab_library/presentation/providers/is_list_view_notifier.dart';
import 'package:slides_sync/features/tab_library/presentation/views/library_tab_view/library_tab_view_app_bar/build_button.dart';

class LibraryTabViewLayoutButton extends ConsumerWidget {
  final AsyncNotifierProvider<IsListViewNotifier, bool> isListViewAsyncProvider;
  const LibraryTabViewLayoutButton({super.key, required this.isListViewAsyncProvider});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final AsyncValue<bool> asyncIsListView = ref.watch(isListViewAsyncProvider);
    return BuildButton(
      onTap: () {
        ref.read(isListViewAsyncProvider.notifier).toggle();
      },
      iconData: (asyncIsListView.value ?? false) ? Iconsax.menu : Icons.list_rounded,
    );
  }
}
