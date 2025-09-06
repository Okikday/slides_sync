import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:iconsax_flutter/iconsax_flutter.dart';
import 'package:slides_sync/features/all_tabs/tab_library/presentation/providers/library_tab_view_providers.dart';
import 'package:slides_sync/features/all_tabs/tab_library/presentation/views/library_tab_view/library_tab_view_app_bar/build_button.dart';

class LibraryTabViewLayoutButton extends ConsumerWidget {
  const LibraryTabViewLayoutButton({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final AsyncValue<bool> asyncIsListView = ref.watch(LibraryTabViewProviders.isListLayout);
    return BuildButton(
      onTap: () {
        ref.read(LibraryTabViewProviders.isListLayout.notifier).toggle();
      },
      iconData: (asyncIsListView.value ?? false) ? Iconsax.menu : Icons.list_rounded,
    );
  }
}
