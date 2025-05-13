import 'package:custom_widgets_toolkit/custom_widgets_toolkit.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:iconsax_flutter/iconsax_flutter.dart';
import 'package:slides_sync/core/utils/app_ui_state.dart';
import 'package:slides_sync/features/home_library/presentation/views/library_tab_view/all_courses_section.dart';
import 'package:slides_sync/features/home_library/presentation/views/library_tab_view/library_view_header.dart';
import 'package:slides_sync/shared/components/loading_view.dart';
import 'package:slides_sync/data/hive_data/app_hive_data.dart';
import 'package:slides_sync/data/hive_data_paths.dart';
import 'package:slides_sync/features/home_library/presentation/views/library_tab_view/all_courses_header.dart';

class IsListViewNotifier extends AsyncNotifier<bool> {
  final String _key = "${HiveDataPaths.views}/library/all_courses_section/var/isListView";

  @override
  Future<bool> build() async {
    final value = await AppHiveData.instance.getData(key: _key);
    return value is bool ? value : true;
  }

  Future<void> toggle() async {
    final current = state.value ?? true;
    final updated = !current;
    state = AsyncData(updated);
    await AppHiveData.instance.setData(key: _key, value: updated);
  }
}

class LibraryView extends ConsumerStatefulWidget {
  final NotifierProvider<AppUiState, AppUiModel> appUiStateProvider;
  const LibraryView(this.appUiStateProvider, {super.key});

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
    final appUiModel = ref.watch(appUiStateProvider);
    final double topPadding = MediaQuery.paddingOf(context).top;
    final Color scaffoldBgColor = Theme.of(context).scaffoldBackgroundColor;
    final AsyncValue<bool> asyncIsListView = ref.watch(isListViewProvider);

    return AnnotatedRegion(
      value: SystemUiOverlayStyle(
        statusBarColor: scaffoldBgColor,
        statusBarBrightness: appUiModel.isDarkMode ? Brightness.light : Brightness.dark,
        statusBarIconBrightness: appUiModel.isDarkMode ? Brightness.light : Brightness.dark,
        systemNavigationBarIconBrightness: appUiModel.isDarkMode ? Brightness.light : Brightness.dark,
        systemNavigationBarColor: (appUiModel.isDarkMode ? Color(0xff0e1d27) : Color(0xffd6ebf9)),
      ),
      child: NotificationListener(
        onNotification: (notification) => true,
        child: CustomScrollView(
          slivers: [
            SliverToBoxAdapter(child: ConstantSizing.columnSpacing(kToolbarHeight)),

            LibraryViewHeader(appUiModel: appUiModel),

            PinnedHeaderSliver(child: ConstantSizing.columnSpacing(topPadding)),

            // All Courses Header
            AllCoursesHeader(
              appUiModel: appUiModel,
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
              return AllCoursesSection(appUiStateProvider, isListView: data);
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
