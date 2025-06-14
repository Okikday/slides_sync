
import 'package:custom_widgets_toolkit/custom_widgets_toolkit.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:slides_sync/core/models/file_location.dart';
import 'package:slides_sync/data/models/course_model/sub/course_content.dart';
import 'package:slides_sync/data/models/course_model/sub/course_content_type.dart';
import 'package:slides_sync/features/main/presentation/views/home_tab_view/home_app_bar.dart';
import 'package:slides_sync/features/main/presentation/views/home_tab_view/home_body/recents_section_body.dart';
import 'package:slides_sync/shared/styles/app_ui_context.dart';

import 'home_tab_view/home_body/recents_section_header.dart';
import 'home_tab_view/home_dash_board.dart';

class HomeTabView extends ConsumerStatefulWidget {
  final StateProvider<bool> isScrolledProvider;
  const HomeTabView({super.key, required this.isScrolledProvider});

  @override
  ConsumerState createState() => _HomeTabViewState();
}

class _HomeTabViewState extends ConsumerState<HomeTabView> with AutomaticKeepAliveClientMixin {
  @override
  Widget build(BuildContext context) {
    super.build(context);
    final bool isScrolled = ref.watch(widget.isScrolledProvider);
    final topPadding = context.padding.top;

    return NestedScrollView(
      // physics: NeverScrollableScrollPhysics(),
      headerSliverBuilder: (context, isInnerBoxScrolled) {
        WidgetsBinding.instance.addPostFrameCallback(
          (_) => ref.read(widget.isScrolledProvider.notifier).update((cb) => isInnerBoxScrolled),
        );
        return [
          HomeAppBar(
            title: 'Happy Reading',
            isScrolled: isScrolled,
            topPadding: topPadding,
            onClickUserIcon: () {
              Scaffold.of(context).openDrawer();
              // SystemChrome.setSystemUIOverlayStyle(SystemUiOverlayStyle(statusBarColor: Theme.of(context).scaffoldBackgroundColor));
            },
            onClickNotification: () {},
          ),
        ];
      },

      body: CustomScrollView(
        physics: BouncingScrollPhysics(),
        slivers: [
          SliverToBoxAdapter(child: ConstantSizing.columnSpacingMedium),

          // Dashboard Section
          SliverToBoxAdapter(
            child: SizedBox(
              height: 200,
              child: NotificationListener(
                onNotification: (notification) => true,
                child: AnimatedSize(
                  duration: Durations.medium4,
                  child: CarouselView(
                    padding: EdgeInsets.zero,
                    backgroundColor: Colors.transparent,
                    enableSplash: false,
                    itemSnapping: true,
                    shrinkExtent: context.deviceWidth * 0.95,
                    itemExtent: context.deviceWidth,
                    children: [
                      HomeDashBoard(
                        courseName: 'Foundation of Sequential Programming',
                        detail: 'CSC 213',
                        progressValue: 0.45,
                        completed: false,
                      ),
                      HomeDashBoard(courseName: 'Software Workshop II', detail: 'CSC 211', progressValue: 0.45),
                      HomeDashBoard(courseName: 'Mathematical Methods I', detail: 'MAT 233', progressValue: 0.45),
                    ],
                  ),
                ),
              ),
            ),
          ),

          SliverToBoxAdapter(child: ConstantSizing.columnSpacingExtraLarge),

          // Recents Section Header
          // Won't show up if the recent courses is empty
          RecentsSectionHeader(onClickSeeAll: (){},),

          // Recents Section Body
          RecentsSectionBody(recentCourses: [
            CourseContent.create(title: "Context Free Grammar", path: FileLocation(), courseContentType: CourseContentType.image)
          ],),
          

          
        ],
      ),
    );
  }

  @override
  bool get wantKeepAlive => true;
}
