import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:slides_sync/core/storage/hive_data/app_hive_data.dart';
import 'package:slides_sync/core/storage/hive_data/hive_data_paths.dart';
import 'package:slides_sync/core/utils/result.dart';
import 'package:slides_sync/features/all_tabs/tab_library/presentation/actions/courses_view_actions.dart';
import 'package:slides_sync/features/all_tabs/tab_library/presentation/providers/courses_view_providers.dart';
import 'package:slides_sync/features/all_tabs/tab_library/presentation/providers/library_tab_view_providers.dart';
import 'package:slides_sync/features/all_tabs/tab_library/presentation/views/library_tab_view/library_tab_view_app_bar.dart';
import 'package:slides_sync/features/all_tabs/tab_library/presentation/views/sub/library_tab_body.dart';
class LibraryTabView extends ConsumerStatefulWidget {
  const LibraryTabView({super.key});

  @override
  ConsumerState createState() => _LibraryTabViewState();
}

class _LibraryTabViewState extends ConsumerState<LibraryTabView> with AutomaticKeepAliveClientMixin {
  late final ScrollController scrollController;

  @override
  void initState() {
    super.initState();
    scrollController = ScrollController();
    scrollController.addListener(scrollListener);
    WidgetsBinding.instance.addPostFrameCallback((_) async {
      Result.tryRunAsync(() async {
        final option =
            CourseSortOption
                .values[await AppHiveData.instance.getData(key: HiveDataPaths.libraryCourseSortOption) as int? ?? 0];
        ref.read(CoursesViewProviders.coursesFilterOptions.notifier).update((cb) => option);
      });
    });
  }

  void scrollListener() {
    final notifier = LibraryTabViewProviders.scrollPositionNotifier;
    if (notifier.value == scrollController.offset) return;
    notifier.value = scrollController.offset;
  }

  @override
  void dispose() {
    scrollController.removeListener(scrollListener);
    scrollController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    super.build(context);

    return NestedScrollView(
      controller: scrollController,
      physics: const NeverScrollableScrollPhysics(),
      headerSliverBuilder: (context, isInnerBoxScrolled) {
        return [LibraryTabViewAppBar()];
      },

      // Body section
      body: LibraryTabBody(),
    );
  }

  @override
  bool get wantKeepAlive => true;
}
