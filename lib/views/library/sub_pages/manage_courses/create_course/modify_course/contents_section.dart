import 'dart:ui';

import 'package:custom_widgets_toolkit/custom_widgets_toolkit.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:iconsax_flutter/iconsax_flutter.dart';
import 'package:slides_sync/app/models/app_ui_model.dart';


class ContentsSection extends ConsumerWidget {
  final AppUiModel appUiModel;

  const ContentsSection(this.appUiModel, {super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    return SliverPadding(
      padding: EdgeInsets.only(top: 8, bottom: 20),
      sliver: SliverList.builder(
        itemCount: 10,
          itemBuilder: (context, index){
        return Padding(
          padding: const EdgeInsets.only(left: 16.0, right: 16.0, top: 16),
          child: _buildCollectionListTile(
            appUiModel,
            collectionTitle: "Textbooks",
            iconData: Iconsax.book,
            collectionCount: 3,
            contentCount: 10,
          ),
        );
      }),
    );
  }
}




class ContentsSectionHeader extends ConsumerWidget {
  const ContentsSectionHeader({
    super.key,
    required this.scaffoldBgColor,
    required this.appUiModel,
  });

  final Color scaffoldBgColor;
  final AppUiModel appUiModel;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    return PinnedHeaderSliver(
      child: ColoredBox(
        color: scaffoldBgColor,
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 16.0),
          child: Row(
            children: [
              Expanded(child: CustomText("Contents", fontSize: 18, fontWeight: FontWeight.bold)),

              CustomElevatedButton(
                backgroundColor: Colors.transparent,
                shape: CircleBorder(),
                child: Icon(Iconsax.add_circle_copy),
              ),

              CustomElevatedButton(
                contentPadding: EdgeInsets.all(8),
                backgroundColor: Colors.lightBlueAccent.withAlpha(40),
                shape: CircleBorder(),
                child: Icon(Iconsax.arrow_up_copy, size: 20, color: appUiModel.isDarkMode ? Colors.white : Colors.black),
              ),
            ],
          ),
        ),
      ),
    );
  }
}




Widget _buildCollectionListTile(
    AppUiModel appUiModel, {
      required String collectionTitle,
      required IconData iconData,
      int collectionCount = 0,
      int contentCount = 0,
      // void Function()? onTap,
    }) {
  return ClipRRect(
    borderRadius: BorderRadius.circular(16),
    child: ColoredBox(
      color: Color.fromARGB(255, 38, 50, 73),
      child: Padding(
        padding: const EdgeInsets.all(4.0),
        child: Container(
          height: 80,
          clipBehavior: Clip.hardEdge,
          padding: EdgeInsets.symmetric(vertical: 16, horizontal: 16),
          //Color(0xFF485BAD)
          decoration: BoxDecoration(
            color: Color.fromARGB(255, 44, 55, 82),
            borderRadius: BorderRadius.circular(12),
            border: Border.fromBorderSide(BorderSide.none),
          ),
          child: BackdropFilter(
            filter: ImageFilter.blur(sigmaX: 4, sigmaY: 4),
            child: Row(
              children: [
                CircleAvatar(backgroundColor: Colors.lightBlueAccent.withAlpha(25), child: Icon(iconData)),
                ConstantSizing.rowSpacingMedium,
                Expanded(
                  child: Column(
                    mainAxisSize: MainAxisSize.min,
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      CustomText(collectionTitle, fontWeight: FontWeight.bold),
                      ConstantSizing.columnSpacing(4),
                      if (collectionCount > 0 || contentCount > 0)
                        CustomText(
                          "${collectionCount < 1 ? '' : "$collectionCount collections"}${(contentCount > 0 && collectionCount > 0) ? ", " : ''}${contentCount < 1 ? '' : "$contentCount content"}",
                          fontSize: 10.5,
                          color: Colors.blueGrey,
                        ),
                    ],
                  ),
                ),
                ConstantSizing.rowSpacingMedium,
                Icon(Iconsax.play_circle),
              ],
            ),
          ),
        ),
      ),
    ),
  );
}