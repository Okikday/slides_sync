import 'dart:developer';
import 'dart:ui';

import 'package:custom_widgets_toolkit/custom_widgets_toolkit.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:iconsax_flutter/iconsax_flutter.dart';
import 'package:slides_sync/core/usecases/app_navigator.dart';
import 'package:slides_sync/features/course_mgmt/data/models/course_model/course_model.dart';
import 'package:slides_sync/features/course_mgmt/presentation/viewmodels/notifiers/select_to_modify_course/get_courses_notifier.dart';
import 'package:slides_sync/features/home/presentation/viewmodels/library_vm/notifiers/is_list_view_notifier.dart';
import 'package:slides_sync/features/home/presentation/views/library_tab_view/library_tab_view_app_bar.dart';
import 'package:slides_sync/shared/components/loading_view.dart';
import 'package:slides_sync/shared/strings/routes_strings.dart';
import 'package:slides_sync/shared/styles/app_ui_context.dart';

import 'library_tab_view/all_courses_header.dart';
import 'library_tab_view/all_courses_section.dart';
import 'library_tab_view/library_view_header.dart';

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
    

    return Stack(
      children: [
        Positioned.fill(
          child: Align(
            alignment: Alignment.bottomRight,
            child: Transform.translate(
              offset: Offset(50, 0),
              child: CircleAvatar(
                radius: 100,
                backgroundColor: context.isDarkMode ? Colors.deepPurple.withAlpha(4) : Colors.black.withAlpha(4),
              ),
            ),
          ),
        ),
        
        Positioned.fill(
          child: NotificationListener(
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
                return [LibraryTabViewAppBar(isListViewProvider: isListViewProvider, scrollOffsetProvider: scrollOffsetProvider)];
              },

              // Body section
              body: Stack(
                children: [
                  Positioned.fill(
                    child: NotificationListener(
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

                  Positioned(
                    bottom: kBottomNavigationBarHeight + 24,
                    right: 24,
                    child: FloatingActionButton(
                      onPressed: () {
                        context.push(RoutesStrings.manageCoursesView);
                      },
                      elevation: 40,
                      backgroundColor: context.isDarkMode ? Colors.lightBlueAccent.withAlpha(40) : Colors.lightBlueAccent.withAlpha(80),
                      shape: CircleBorder(),

                      child: CircleAvatar(
                        radius: 25,
                        backgroundColor: Colors.deepPurple,
                        child: Icon(Iconsax.setting_4, color: Colors.white),
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ),
        ),
      ],
    );
  }

  @override
  bool get wantKeepAlive => true;
}
