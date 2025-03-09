import 'dart:ui';

import 'package:custom_widgets_toolkit/custom_widgets_toolkit.dart';
import 'package:flutter/material.dart';
import 'package:iconsax_flutter/iconsax_flutter.dart';
import 'package:slides_sync/components/colors.dart';
import 'package:slides_sync/views/home/sub_widgets/home_body.dart';

List<Widget> recentSection(BuildContext context, HomeBody widget) {
  return [
    PinnedHeaderSliver(
      child: AnimatedContainer(
        duration: Durations.medium3,
        clipBehavior: Clip.hardEdge,
        padding: const EdgeInsets.symmetric(horizontal: ConstantSizing.spaceMedium),
        decoration: BoxDecoration(color: Theme.of(context).scaffoldBackgroundColor),
        child: BackdropFilter(
          filter: ImageFilter.blur(sigmaX: 4, sigmaY: 4),
          child: Row(
            children: [
              Expanded(child: CustomText("Recents", fontSize: 20, fontWeight: FontWeight.bold)),

              CustomTextButton(
                label: "See all",
                textColor: widget.appUiModel.isDarkMode ? SlidesRepoColors.darkTextSecondary : SlidesRepoColors.textSecondary,
                textSize: 16,
                onClick: () {},
              ),
            ],
          ),
        ),
      ),
    ),

    SliverList.builder(
      itemCount: 4,
      itemBuilder: (context, index) {
        return RecentListTile(isDarkMode: widget.appUiModel.isDarkMode, title: "Regular Expressions", subtitle: "Slide 4");
      },
    ),
  ];
}


class RecentListTile extends StatelessWidget {
  final bool isDarkMode;
  final String title;
  final String subtitle;
  final void Function()? onTapTile;
  final void Function()? onTapPlay;
  const RecentListTile({super.key, required this.title, required this.subtitle, this.onTapTile, this.onTapPlay, required this.isDarkMode});

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: EdgeInsets.only(top: 8, left: 8, right: 8),
      child: CustomElevatedButton(
        backgroundColor: (isDarkMode ? Color(0xff0e1d27) : SlidesRepoColors.lightGray),
        overlayColor: Colors.lightBlueAccent.withAlpha(50),
        contentPadding: EdgeInsets.symmetric(horizontal: 16, vertical: 8),
        borderRadius: 12,
        pixelHeight: 72,
        onClick: (){
          if(onTapTile != null) onTapTile!();
        },
        child: Row(
          children: [
            Container(
              height: 48,
              width: 48,
              decoration: BoxDecoration(borderRadius: BorderRadius.circular(12), color: Colors.lightBlueAccent.withAlpha(100)),
              child: Icon(Iconsax.document_1, size: 26,),
            ),

            ConstantSizing.rowSpacingMedium,

            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  FittedBox(child: CustomText(title, fontSize: 16, fontWeight: FontWeight.bold)),
                  FittedBox(child: CustomText(subtitle, fontSize: 14, color: SlidesRepoColors.textSecondary)),
                ],
              ),
            ),

            CustomElevatedButton(
              contentPadding: EdgeInsets.all(10),
              shape: CircleBorder(),
              backgroundColor: Colors.black,
              overlayColor: Colors.lightBlueAccent.withAlpha(50),
              onClick: (){
                if(onTapPlay != null) onTapPlay!();
              },
              child: Icon(Iconsax.play, color: Colors.white, size: 26),
            ),
          ],
        ),
      ),
    );
  }
}

