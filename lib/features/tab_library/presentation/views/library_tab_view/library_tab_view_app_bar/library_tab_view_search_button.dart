import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:iconsax_flutter/iconsax_flutter.dart';
import 'package:slides_sync/features/tab_library/presentation/views/library_tab_view/library_tab_view_app_bar.dart';
import 'package:slides_sync/features/tab_library/presentation/views/library_tab_view/library_tab_view_app_bar/build_button.dart';

class LibraryTabViewSearchButton extends ConsumerWidget {
  const LibraryTabViewSearchButton({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    return BuildButton(onTap: () {}, iconData: Iconsax.search_normal_copy);
  }
}
