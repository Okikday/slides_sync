import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:iconsax_flutter/iconsax_flutter.dart';
import 'package:slides_sync/features/all_tabs/tab_library/presentation/views/library_tab_view/library_tab_view_app_bar/build_button.dart';

class LibraryTabViewSearchButton extends ConsumerWidget {
  final Color? backgroundColor;
  final VoidCallback onTap;
  const LibraryTabViewSearchButton({super.key, this.backgroundColor, required this.onTap});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    return BuildButton(onTap: onTap, iconData: Iconsax.search_normal_copy, backgroundColor: backgroundColor);
  }
}
