import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:iconsax_flutter/iconsax_flutter.dart';
import 'package:slides_sync/features/all_tabs/tab_library/presentation/providers/custom_notifiers/is_list_view_notifier.dart';
import 'package:slides_sync/features/all_tabs/tab_library/presentation/views/library_tab_view/library_tab_view_app_bar/build_button.dart';

class LibraryTabViewLayoutButton extends ConsumerWidget {
  final AutoDisposeAsyncNotifierProvider<IsListViewNotifier, bool> isListLayoutProvider;
  final Color? backgroundColor;

  const LibraryTabViewLayoutButton({super.key, required this.isListLayoutProvider, this.backgroundColor});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final AsyncValue<bool> asyncIsListView = ref.watch(isListLayoutProvider);
    return BuildButton(
      onTap: () {
        ref.read(isListLayoutProvider.notifier).toggle();
      },
      backgroundColor: backgroundColor,
      iconData: (asyncIsListView.value ?? false) ? Iconsax.menu : Icons.list_rounded,
    );
  }
}
