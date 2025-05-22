import 'package:custom_widgets_toolkit/custom_widgets_toolkit.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:iconsax_flutter/iconsax_flutter.dart';
import 'package:slides_sync/features/home/presentation/viewmodels/library_vm/notifiers/is_list_view_notifier.dart';
import 'package:slides_sync/shared/components/loading_view.dart';
import 'package:slides_sync/shared/styles/app_ui_context.dart';

import 'library_tab_view/all_courses_header.dart';
import 'library_tab_view/all_courses_section.dart';
import 'library_tab_view/library_view_header.dart';


class LibraryView extends ConsumerStatefulWidget {
  const LibraryView({super.key});

  @override
  ConsumerState createState() => _LibraryViewState();
}

class _LibraryViewState extends ConsumerState<LibraryView> with AutomaticKeepAliveClientMixin{
  late final AsyncNotifierProvider<IsListViewNotifier, bool> isListViewProvider;

  @override
  void initState(){
    super.initState();
    isListViewProvider = AsyncNotifierProvider<IsListViewNotifier, bool>(
      IsListViewNotifier.new,
    );
  }

  @override
  Widget build(BuildContext context) {
    super.build(context);
    final double topPadding = MediaQuery.paddingOf(context).top;
    
    final AsyncValue<bool> asyncIsListView = ref.watch(isListViewProvider);

    return AnnotatedRegion(
      value: SystemUiOverlayStyle(
        statusBarColor: context.scaffoldBackgroundColor,
        statusBarBrightness: context.isDarkMode ? Brightness.light : Brightness.dark,
        statusBarIconBrightness: context.isDarkMode ? Brightness.light : Brightness.dark,
        systemNavigationBarIconBrightness: context.isDarkMode ? Brightness.light : Brightness.dark,
        systemNavigationBarColor: (context.isDarkMode ? Color(0xff0e1d27) : Color(0xffd6ebf9)),
      ),
      child: NotificationListener(
        onNotification: (notification) => true,
        child: CustomScrollView(
          slivers: [
            SliverToBoxAdapter(child: ConstantSizing.columnSpacing(kToolbarHeight)),

            LibraryViewHeader(),

            PinnedHeaderSliver(child: ConstantSizing.columnSpacing(topPadding)),

            // All Courses Header
            AllCoursesHeader(
              isListView: asyncIsListView.value ?? false,
              onTapGridButton: (){
                ref.read(isListViewProvider.notifier).toggle();
              },
              onTap: () {
                PrimaryScrollController.of(context).animateTo(0, duration: Durations.extralong1, curve: CustomCurves.defaultIosSpring);
              },
            ),

            SliverToBoxAdapter(child: ConstantSizing.columnSpacingMedium),
            
            asyncIsListView.when(data: (data){
              return AllCoursesSection(isListView: data);
            }, error: (_, __){
              return RotatedBox(quarterTurns: 2, child: Icon(Iconsax.info_circle));
            }, loading: (){
              return SliverToBoxAdapter(child: LoadingView(msg: "Loading Courses",));
            }),
            

            SliverToBoxAdapter(child: ConstantSizing.columnSpacing(kBottomNavigationBarHeight + topPadding + 24)),

            // TODO: there's be a My Books grid for custom additions or starred books
          ],
        ),
      ),
    );
  }
  
  @override
  bool get wantKeepAlive => true;

  
}
