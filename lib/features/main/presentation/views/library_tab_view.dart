
import 'package:custom_widgets_toolkit/custom_widgets_toolkit.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:slides_sync/features/main/presentation/providers/is_list_view_notifier.dart';
import 'package:slides_sync/features/main/presentation/views/library_tab_view/library_tab_view_app_bar.dart';
import 'package:slides_sync/shared/styles/app_ui_context.dart';

import 'library_tab_view/all_courses_section.dart';

final StateProvider<bool> isLibrarySectionScrolledProvider = StateProvider((ref) => true);

class LibraryTabView extends ConsumerStatefulWidget {
  const LibraryTabView({super.key});

  @override
  ConsumerState createState() => _LibraryTabViewState();
}

class _LibraryTabViewState extends ConsumerState<LibraryTabView> with AutomaticKeepAliveClientMixin {
  late final AsyncNotifierProvider<IsListViewNotifier, bool> isListViewProvider;
  late final StateProvider<double> scrollOffsetProvider;

  @override
  void initState() {
    super.initState();
    isListViewProvider = AsyncNotifierProvider<IsListViewNotifier, bool>(IsListViewNotifier.new);
    scrollOffsetProvider = StateProvider<double>((ref) => 0.0);
  }

  @override
  Widget build(BuildContext context) {
    super.build(context);
    final double topPadding = context.topPadding;

    final AsyncValue<bool> asyncIsListView = ref.watch(isListViewProvider);
    

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
        headerSliverBuilder: (context, innerBoxIsScrolled) {
          WidgetsBinding.instance.addPostFrameCallback((_) => ref.read(isLibrarySectionScrolledProvider.notifier).update((cb) => !innerBoxIsScrolled));
          return [LibraryTabViewAppBar(isListViewProvider: isListViewProvider, scrollOffsetProvider: scrollOffsetProvider)];
        },
        
        // Body section
        body: NotificationListener(
          onNotification: (notification) => true,
          child: CustomScrollView(
            slivers: [
              // SliverToBoxAdapter(child: ConstantSizing.columnSpacing(kToolbarHeight)),
              
              // LibraryViewHeader(),
              SliverToBoxAdapter(child: ConstantSizing.columnSpacingMedium),
              
              AllCoursesSection(isListView: asyncIsListView.value ?? false),
              
              SliverToBoxAdapter(child: ConstantSizing.columnSpacing(kBottomNavigationBarHeight + topPadding + 24)),
            ],
          ),
        ),
      ),
    );
  }

  @override
  bool get wantKeepAlive => true;
}
