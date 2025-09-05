import 'package:custom_widgets_toolkit/custom_widgets_toolkit.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:slides_sync/features/all_tabs/tab_library/presentation/providers/is_list_view_notifier.dart';
import 'package:slides_sync/features/all_tabs/tab_library/presentation/views/library_tab_view/all_courses_section.dart';
import 'package:slides_sync/shared/helpers/extension_helper.dart';

class LibraryInnerScrollView extends ConsumerWidget {
  const LibraryInnerScrollView({super.key, required this.isListViewAsyncProvider});

  final AsyncNotifierProvider<IsListViewNotifier, bool> isListViewAsyncProvider;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    return NotificationListener(
      onNotification: (notification) => true,
      child: CustomScrollView(
        slivers: [
          SliverToBoxAdapter(child: ConstantSizing.columnSpacingMedium),

          AllCoursesSection(isListViewAsyncProvider: isListViewAsyncProvider),

          SliverToBoxAdapter(child: ConstantSizing.columnSpacing(kBottomNavigationBarHeight + context.topPadding + 24)),
        ],
      ),
    );
  }
}
