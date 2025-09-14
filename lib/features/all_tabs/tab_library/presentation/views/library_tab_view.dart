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
import 'package:slides_sync/features/main/presentation/providers/main_providers.dart';

class LibraryTabView extends ConsumerStatefulWidget {
  const LibraryTabView({super.key});

  @override
  ConsumerState createState() => _LibraryTabViewState();
}

class _LibraryTabViewState extends ConsumerState<LibraryTabView> with AutomaticKeepAliveClientMixin {
  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      if (ref.read(MainProviders.mainTabViewIndexProvider.notifier).state == 1) {
        ref.read(MainProviders.isMainScrolledProvider.notifier).update((cb) => false);
      }
    });
    WidgetsBinding.instance.addPostFrameCallback((_) async {
      Result.tryRunAsync(() async {
        final option =
            CourseSortOption
                .values[await AppHiveData.instance.getData(key: HiveDataPaths.libraryCourseSortOption) as int? ?? 0];
        ref.read(CoursesViewProviders.coursesFilterOptions.notifier).update((cb) => option);
      });
    });
  }

  @override
  Widget build(BuildContext context) {
    super.build(context);

    return NotificationListener(
      onNotification: (notification) {
        if (notification is ScrollUpdateNotification) {
          ref.read(LibraryTabViewProviders.scrollPosition.notifier).update((cb) => notification.metrics.pixels);
        }
        return true;
      },
      child: NestedScrollView(
        physics: const NeverScrollableScrollPhysics(),
        headerSliverBuilder: (context, isInnerBoxScrolled) {
          if (ref.read(MainProviders.mainTabViewIndexProvider.notifier).state == 1) {
            final currValue = ref.read(MainProviders.isMainScrolledProvider.notifier).state;
            if (currValue != isInnerBoxScrolled) {
              WidgetsBinding.instance.addPostFrameCallback(
                (_) => ref.read(MainProviders.isMainScrolledProvider.notifier).update((cb) => isInnerBoxScrolled),
              );
            }
          }

          return [LibraryTabViewAppBar()];
        },

        // Body section
        body: LibraryTabBody(),
      ),
    );
  }

  @override
  bool get wantKeepAlive => true;
}
