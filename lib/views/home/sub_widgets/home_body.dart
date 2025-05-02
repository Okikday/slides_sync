import 'dart:developer';
import 'dart:ui';

import 'package:custom_widgets_toolkit/custom_widgets_toolkit.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:iconsax_flutter/iconsax_flutter.dart';
import 'package:page_transition/page_transition.dart';
import 'package:slides_sync/app/models/app_ui_model.dart';
import 'package:slides_sync/app/states/app_ui_state.dart';
import 'package:slides_sync/components/colors.dart';
import 'package:slides_sync/views/home/home.dart';
import 'package:slides_sync/views/home/sub_widgets/home_app_bar.dart';
import 'package:slides_sync/views/home/sub_widgets/recents_section/recents_section.dart';

import 'home_dash_board.dart';

class HomeBody extends ConsumerStatefulWidget {
  final NotifierProvider<AppUiState, AppUiModel> appUiStateProvider;
  final NotifierProvider<IsScrolled, bool> isScrolledProvider;
  final bool isScrolled;
  const HomeBody(this.appUiStateProvider, {super.key, required this.isScrolledProvider, required this.isScrolled});

  @override
  ConsumerState createState() => _HomeBodyState();
}

class _HomeBodyState extends ConsumerState<HomeBody> with AutomaticKeepAliveClientMixin {
  @override
  Widget build(BuildContext context) {
    super.build(context);
    final AppUiModel appUiModel = ref.watch(widget.appUiStateProvider);
    final topPadding = MediaQuery.paddingOf(context).top;
    return NestedScrollView(

      physics: NeverScrollableScrollPhysics(),
      headerSliverBuilder: (context, isInnerBoxScrolled) {

        WidgetsBinding.instance.addPostFrameCallback((_) {
          ref.read(widget.isScrolledProvider.notifier).update(isInnerBoxScrolled);
        });
        return [HomeAppBar(appUiModel: appUiModel, isScrolled: widget.isScrolled, topPadding: topPadding)];
      },
      body: appUiModel.deviceWidth > appUiModel.deviceHeight ? buildLandscape(context) : buildPotrait(context)
    );
  }

  CustomScrollView buildPotrait(BuildContext context) {
    final AppUiModel appUiModel = ref.watch(widget.appUiStateProvider);
    final double topPadding = MediaQuery.paddingOf(context).top;
    return CustomScrollView(
      physics: BouncingScrollPhysics(),
      slivers: [
        SliverToBoxAdapter(child: ConstantSizing.columnSpacingMedium),
        
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
                  shrinkExtent: appUiModel.deviceWidth * 0.95,
                  itemExtent: appUiModel.deviceWidth,
                  children: [
                    HomeDashBoard(
                      appUiModel: appUiModel,
                      courseName: 'Foundation of Sequential Programming',
                      detail: 'CSC 213 -> (200-Level-1st-Semester)',
                      progressValue: 0.45,
                    ),
                    HomeDashBoard(
                      appUiModel: appUiModel,
                      courseName: 'Software Workshop II',
                      detail: 'CSC 211',
                      progressValue: 0.45,
                    ),
                    HomeDashBoard(
                      appUiModel: appUiModel,
                      courseName: 'Mathematical Methods I',
                      detail: 'MAT 233',
                      progressValue: 0.45,
                    ),
                  ],
                ),
              ),
            ),
          ),
        ),

        SliverToBoxAdapter(child: ConstantSizing.columnSpacingLarge),

        // Recents Section Header
        SliverToBoxAdapter(
          child: Padding(
            padding: const EdgeInsets.symmetric(horizontal: ConstantSizing.spaceMedium),
            child: Row(
              children: [
                Expanded(child: CustomText("Recents", fontSize: 20, fontWeight: FontWeight.bold)),

                CustomTextButton(
                  label: "See all",
                  textColor: appUiModel.isDarkMode ? SlidesRepoColors.darkTextSecondary : SlidesRepoColors.textSecondary,
                  textSize: 16,
                  onClick: () {
                    Navigator.push(
                      context,
                      PageTransition(
                        type: PageTransitionType.bottomToTop,
                        duration: Durations.extralong3,
                        reverseDuration: Durations.medium1,
                        curve: CustomCurves.snappySpring,
                        child: Scaffold(appBar: AppBar(title: CustomText("Recents"),), body: Center(child: CustomText("Recents"))),
                      ),
                    );
                  },
                ),
              ],
            ),
          ),
        ),

        // Recents Section Body
        RecentsSectionBody(appUiModel: appUiModel),

        SliverToBoxAdapter(child: ConstantSizing.columnSpacing(ref.watch(widget.isScrolledProvider) ? kBottomNavigationBarHeight + topPadding : 0)),
      ],
    );
  }

  Row buildLandscape(BuildContext context) {
    final AppUiModel appUiModel = ref.watch(widget.appUiStateProvider);
    return  Row(
      children: [

        Expanded(
          child: SizedBox(
            height: appUiModel.deviceHeight  - kToolbarHeight - kBottomNavigationBarHeight - 56,
            width: appUiModel.deviceWidth/2,
            child: NotificationListener(
              onNotification: (notification) => true,
              child: AnimatedSize(
                duration: Durations.medium4,
                child: CarouselView(
                  padding: EdgeInsets.zero,
                  backgroundColor: Colors.transparent,
                  enableSplash: false,
                  itemSnapping: true,
                  shrinkExtent: appUiModel.deviceHeight * 0.2,
                  itemExtent: appUiModel.deviceHeight  - kToolbarHeight - kBottomNavigationBarHeight - 56,
                  scrollDirection: Axis.vertical,
                  children: [
                    HomeDashBoard(
                      appUiModel: appUiModel,
                      courseName: 'Foundation of Sequential Programming',
                      detail: 'CSC 213',
                      progressValue: 0.45,
                    ),
                    HomeDashBoard(
                      appUiModel: appUiModel,
                      courseName: 'Software Workshop II',
                      detail: 'CSC 211',
                      progressValue: 0.45,
                    ),
                    HomeDashBoard(
                      appUiModel: appUiModel,
                      courseName: 'Mathematical Methods I',
                      detail: 'MAT 233',
                      progressValue: 0.45,
                    ),
                  ],
                ),
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
