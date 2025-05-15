import 'dart:ui';

import 'package:custom_widgets_toolkit/custom_widgets_toolkit.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:iconsax_flutter/iconsax_flutter.dart';
import 'package:slides_sync/core/utils/app_ui_state.dart';

import '../../../../core/utils/ui_utils.dart';
import '../../../../shared/components/app_bar_container.dart';
import '../../../../shared/components/app_bar_container_child.dart';

class CourseNavigationView extends ConsumerStatefulWidget {
  const CourseNavigationView({super.key});

  @override
  ConsumerState createState() => _CourseNavigationViewState();
}

class _CourseNavigationViewState extends ConsumerState<CourseNavigationView> {
  @override
  Widget build(BuildContext context) {
    final AppUiModel appUiModel = ref.watch(appUiStateProvider);
    final Color scaffoldBgColor = Theme.of(context).scaffoldBackgroundColor;

    return AnnotatedRegion(
      value: UiUtils.getSystemUiOverlayStyle(scaffoldBgColor, appUiModel.isDarkMode),
      child: Scaffold(
        appBar: AppBarContainer(
          appBarHeight: kToolbarHeight + 12,
          padding: EdgeInsets.zero,
          child: AppBarContainerChild(appUiModel.isDarkMode, title: 'Browse Course'),
        ),

        body: Column(
          children: [
            ConstantSizing.columnSpacingMedium,
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 16.0),
              child: Row(
                children: [
                  Icon(Iconsax.home, size: 26, color: Colors.grey,),
                  Icon(Icons.keyboard_arrow_right, color: Colors.grey,),
                  CustomText("Textbooks", color: Colors.grey, fontSize: 16,),
                  Icon(Icons.keyboard_arrow_right, color: Colors.grey,),
                  CustomText("Essentials",),
                  Icon(Icons.keyboard_arrow_right),
                ],
              ),
            ),

            ConstantSizing.columnSpacingLarge,

            _buildExample(),
            _buildExample(),
            _buildExample(),
            _buildExample()

            // Padding(
            //   padding: const EdgeInsets.symmetric(horizontal: 12.0),
            //   child: _buildCollectionListTile(appUiModel, collectionTitle: "This is a collection", iconData: Iconsax.document),
            // ),
            // ConstantSizing.columnSpacingMedium,
            // Padding(
            //   padding: const EdgeInsets.symmetric(horizontal: 12.0),
            //   child: _buildCollectionListTile(appUiModel, collectionTitle: "This is a collection", iconData: Iconsax.document),
            // ),
            // ConstantSizing.columnSpacingMedium,
            // Padding(
            //   padding: const EdgeInsets.symmetric(horizontal: 12.0),
            //   child: _buildCollectionListTile(appUiModel, collectionTitle: "This is a collection", iconData: Iconsax.document),
            // ),
          ],
        ),
      ),
    );
  }
}



Widget _buildExample(){
  return Column(
    mainAxisSize: MainAxisSize.min,
    children: [

      Padding(
        padding: const EdgeInsets.symmetric(horizontal: 16.0, vertical: 8.0),
        child: Row(
          spacing: 12.0,
          children: [
            Icon(Iconsax.document, size: 40,),
            Expanded(child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                CustomText("This is a collection/slide", fontSize: 16, fontWeight: FontWeight.bold,),
                CustomText("4 items", color: Colors.grey,)
              ],
            )),
            CustomText("data")
          ],
        ),
      ),
      Divider(color: Colors.lightBlueAccent.withAlpha(40),),
    ],
  );
}


Widget _buildCollectionListTile(
    AppUiModel appUiModel, {
      required String collectionTitle,
      required IconData iconData,
      int subCollectionCount = 0,
      int contentCount = 0,
      // void Function()? onTap,
    }) {
  return ClipRRect(
    borderRadius: BorderRadius.circular(16),
    child: ColoredBox(
      color: appUiModel.isDarkMode ? Color(0xFF143850) : Color(0xFFDBF3FF),
      child: Padding(
        padding: const EdgeInsets.all(4.0),
        child: Container(
          height: 70,
          clipBehavior: Clip.hardEdge,
          padding: EdgeInsets.symmetric(vertical: 16, horizontal: 16),
          //Color(0xFF485BAD)
          decoration: BoxDecoration(
            color: appUiModel.isDarkMode ? Color(0xFF163343).withValues(alpha: 0.89) : Color(0xFFDBF3FF).withValues(alpha: 0.89),

            borderRadius: BorderRadius.circular(12),
            border: Border.fromBorderSide(BorderSide.none),
          ),
          child: BackdropFilter(
            filter: ImageFilter.blur(sigmaX: 4, sigmaY: 4),
            child: Row(
              children: [
                CircleAvatar(backgroundColor: Colors.lightBlueAccent.withAlpha(25), child: Icon(iconData, color: appUiModel.isDarkMode ? Colors.white : Colors.black,)),
                ConstantSizing.rowSpacingMedium,
                Expanded(
                  child: Column(
                    mainAxisSize: MainAxisSize.min,
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      CustomText(collectionTitle, fontWeight: FontWeight.bold,),
                      ConstantSizing.columnSpacing(4),
                      if (subCollectionCount > 0 || contentCount > 0)
                        CustomText(
                          "${subCollectionCount < 1 ? '' : "$subCollectionCount collections"}${(contentCount > 0 && subCollectionCount > 0) ? ", " : ''}${contentCount < 1 ? '' : "$contentCount content"}",
                          fontSize: 10.5,
                          color: Colors.grey,
                        ),
                    ],
                  ),
                ),
                ConstantSizing.rowSpacingMedium,
                Icon(Iconsax.arrow_right, color: appUiModel.isDarkMode ? Colors.white : Colors.black,),
              ],
            ),
          ),
        ),
      ),
    ),
  );
}