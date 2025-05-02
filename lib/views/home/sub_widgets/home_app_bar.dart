import 'dart:developer';
import 'dart:ui';

import 'package:custom_widgets_toolkit/custom_widgets_toolkit.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:iconsax_flutter/iconsax_flutter.dart';
import 'package:slides_sync/app/models/app_ui_model.dart';
import 'package:slides_sync/components/colors.dart';

class HomeAppBar extends StatelessWidget {
  const HomeAppBar({super.key, required this.appUiModel, required this.isScrolled, required this.topPadding});

  final AppUiModel appUiModel;
  final bool isScrolled;
  final double topPadding;

  @override
  Widget build(BuildContext context) {
    return SliverAppBar(
      elevation: 64,
      pinned: true,
      expandedHeight: kToolbarHeight + (topPadding / 2),
      collapsedHeight: kToolbarHeight + (topPadding / 2),
      forceMaterialTransparency: true,
      surfaceTintColor: Colors.transparent,
      systemOverlayStyle: SystemUiOverlayStyle(
        statusBarColor:
            isScrolled ? (appUiModel.isDarkMode ? Color(0xff0e1d27) : Color(0xffd6ebf9)) : Theme.of(context).scaffoldBackgroundColor,
        statusBarBrightness: appUiModel.isDarkMode ? Brightness.light : Brightness.dark,
        statusBarIconBrightness: appUiModel.isDarkMode ? Brightness.light : Brightness.dark,
      ),
      flexibleSpace: FlexibleSpaceBar(
        expandedTitleScale: 1.0,

        background: GestureDetector(
          onTap: () {
            PrimaryScrollController.of(context).animateTo(0, duration: Durations.extralong1, curve: CustomCurves.defaultIosSpring);
          },
          child: Material(
            type: MaterialType.transparency,
            shape: isScrolled ? LinearBorder(bottom: LinearBorderEdge(), side: BorderSide(color: Colors.blueAccent.withAlpha(40))) : null,
            child:
                isScrolled
                    ? AnimatedContainer(duration: Durations.medium3, color: appUiModel.isDarkMode ? Color(0xff0e1d27) : Color(0xffd6ebf9))
                    : ColoredBox(color: Theme.of(context).scaffoldBackgroundColor),
          ),
        ),
        collapseMode: CollapseMode.pin,
        titlePadding: EdgeInsets.only(top: topPadding),
        title: GestureDetector(
          onTap: () {
            PrimaryScrollController.of(context).animateTo(0, duration: Durations.extralong1, curve: CustomCurves.defaultIosSpring);
          },
          child: AnimatedSize(
            duration: Durations.medium3,
            child: Padding(
              padding: EdgeInsets.fromLTRB(16, 0, 16, 4),
              child: Row(
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                  CustomElevatedButton(
                    onClick: () {},
                    overlayColor: Colors.lightBlueAccent.withAlpha(0),
                    backgroundColor: isScrolled ? SlidesRepoColors.lightGray.withAlpha(100) : SlidesRepoColors.lightGray,
                    shape: CircleBorder(),
                    contentPadding: EdgeInsets.all(12),
                    child: Icon(Iconsax.profile_add_copy, color: isScrolled ? Colors.deepPurple : Colors.black, size: 26),
                  ),

                  ConstantSizing.rowSpacingMedium,
                  Expanded(child: CustomText("Hello, user", fontSize: 16, fontWeight: FontWeight.bold)),

                  CustomElevatedButton(
                    shape: CircleBorder(),
                    backgroundColor: Colors.lightBlueAccent.withAlpha(40),
                    overlayColor: Colors.deepPurple.withAlpha(20),
                    onClick: (){
                      CustomSnackBar.showSnackBar(context, content: "This toggles Focus Mode(FullScreen)", textStyle: TextStyle(color: Colors.white), icon: Icon(Iconsax.info_circle_copy, color: Colors.white,), usePrimaryColor: true);
                    },
                    child: Icon(Iconsax.crop, color: appUiModel.isDarkMode ? Colors.white : Colors.deepPurple),
                  ),

                  CustomElevatedButton(
                    onClick: () {},
                    overlayColor: Colors.lightBlueAccent.withAlpha(60),
                    shape: CircleBorder(),
                    backgroundColor: isScrolled ? SlidesRepoColors.altLightGray.withAlpha(100) : SlidesRepoColors.lightGray,
                    child: Badge(
                      backgroundColor: Colors.transparent,
                      offset: Offset(-1, -1),
                      // label: CircleAvatar(
                      //   radius: 7.5,
                      //   backgroundColor: Color(0xfff3f4f6),
                      //   child: CircleAvatar(
                      //     radius: 7,
                      //     backgroundColor: Colors.deepOrange,
                      //     child: CustomText("5", color: Colors.white, fontSize: 10, fontWeight: FontWeight.bold),
                      //   ),
                      // ),
                      child: Icon(Iconsax.notification, color: appUiModel.isDarkMode && isScrolled ? Colors.white : Colors.black, size: 24),
                    ),
                  ),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}
