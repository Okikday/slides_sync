import 'package:custom_widgets_toolkit/custom_widgets_toolkit.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:iconsax_flutter/iconsax_flutter.dart';
import 'package:slides_sync/shared/helpers/extension_helper.dart';
import 'package:slides_sync/shared/styles/colors.dart';

class HomeAppBar extends StatelessWidget {
  const HomeAppBar({
    super.key,
    required this.isScrolled,
    required this.onClickUserIcon,
    required this.title,
    required this.onClickNotification,
  });

  final bool isScrolled;

  final void Function() onClickUserIcon;

  final String title;
  final void Function() onClickNotification;
  @override
  Widget build(BuildContext context) {
    final topPadding = context.topPadding;
    return SliverAppBar(
      elevation: 64,
      pinned: true,
      leading: SizedBox(),
      expandedHeight: kToolbarHeight + (topPadding / 2),
      collapsedHeight: kToolbarHeight + (topPadding / 2),
      forceMaterialTransparency: true,
      surfaceTintColor: Colors.transparent,
      systemOverlayStyle: SystemUiOverlayStyle(
        statusBarColor:
            isScrolled ? (context.isDarkMode ? Color(0xff0e1d27) : Color(0xffd6ebf9)) : Theme.of(context).scaffoldBackgroundColor,
        statusBarBrightness: context.isDarkMode ? Brightness.light : Brightness.dark,
        statusBarIconBrightness: context.isDarkMode ? Brightness.light : Brightness.dark,
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
                    ? AnimatedContainer(duration: Durations.medium3, color: context.isDarkMode ? Color(0xff0e1d27) : Color(0xffd6ebf9))
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
                    onClick: onClickUserIcon,
                    overlayColor: Colors.lightBlueAccent.withAlpha(40),
                    backgroundColor: isScrolled ? SlidesRepoColors.lightGray.withAlpha(100) : SlidesRepoColors.lightGray,
                    shape: CircleBorder(),
                    contentPadding: EdgeInsets.all(12),
                    child: Icon(Iconsax.profile_circle, color: isScrolled ? Colors.deepPurple : Colors.black, size: 26),
                  ),

                  ConstantSizing.rowSpacingMedium,
                  Expanded(child: CustomText(title, fontSize: 16, fontWeight: FontWeight.bold)),

                  // CustomElevatedButton(
                  //   shape: CircleBorder(),
                  //   backgroundColor: Colors.lightBlueAccent.withAlpha(40),
                  //   overlayColor: Colors.deepPurple.withAlpha(20),
                  //   onClick: onToggleFullScreen,
                  //   child: Icon(Iconsax.crop, color: context.isDarkMode ? Colors.white : Colors.deepPurple),
                  // ),
                  CustomElevatedButton(
                    onClick: onClickNotification,
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
                      child: Icon(Iconsax.notification, color: context.isDarkMode && isScrolled ? Colors.white : Colors.black, size: 24),
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
