import 'dart:ui';

import 'package:custom_widgets_toolkit/custom_widgets_toolkit.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:iconsax_flutter/iconsax_flutter.dart';
import 'package:slides_sync/app/models/app_ui_model.dart';
import 'package:slides_sync/use_cases/library/library_ui_funcs.dart';

class LibraryView extends ConsumerWidget {
  final AppUiModel appUiModel;
  const LibraryView({super.key, required this.appUiModel});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final double topPadding = MediaQuery.paddingOf(context).top;
    final Color scaffoldBgColor = Theme.of(context).scaffoldBackgroundColor;
    return NotificationListener(
      onNotification: (notification) => true,
      child: AnnotatedRegion(
        value: SystemUiOverlayStyle(statusBarColor: scaffoldBgColor),
        child: CustomScrollView(
          slivers: [
            SliverToBoxAdapter(child: ConstantSizing.columnSpacing(kToolbarHeight + topPadding)),
            SliverToBoxAdapter(
              child: Padding(
                padding: const EdgeInsets.symmetric(horizontal: 0),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceAround,
                  children: [
                    buildGridItem(title: 'Recommended', icon: Icon(Iconsax.document)),
                    buildGridItem(title: 'Textbooks', icon: Icon(Iconsax.document)),
                    buildGridItem(title: 'Questions', icon: Icon(Iconsax.document)),
                  ],
                ),
              ),
            ),

            PinnedHeaderSliver(child: ConstantSizing.columnSpacing(topPadding)),

            // All Courses Header
            PinnedHeaderSliver(
              child: ColoredBox(
                // color: Colors.lightBlueAccent.withAlpha(100),
                color: scaffoldBgColor,
                child: Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 18, vertical: 4),
                  child: GestureDetector(
                    onTap: (){
                      PrimaryScrollController.of(context).animateTo(0, duration: Durations.long1, curve: Curves.ease);
                    },
                    child: Row(
                      children: [
                        Expanded(child: CustomText("All Courses", fontSize: 20, fontWeight: FontWeight.bold)),

                        CustomElevatedButton(backgroundColor: Colors.transparent, shape: CircleBorder(), child: Icon(Iconsax.crop_copy)),

                        CustomElevatedButton(
                          contentPadding: EdgeInsets.all(8),
                          backgroundColor: Colors.lightBlueAccent.withAlpha(40),
                          shape: CircleBorder(),
                          child: Icon(Iconsax.menu, size: 20, color: appUiModel.isDarkMode ? Colors.white : Colors.black),
                        ),
                      ],
                    ),
                  )
                ),
              ),
            ),

            SliverToBoxAdapter(child: ConstantSizing.columnSpacingMedium),

            SliverPadding(
              padding: EdgeInsets.symmetric(horizontal: 12),
              sliver: SliverGrid(
                gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(crossAxisCount: appUiModel.deviceHeight > appUiModel.deviceWidth ? 2 : 3, mainAxisSpacing: 12, crossAxisSpacing: 12),
                delegate: SliverChildBuilderDelegate((context, index) {
                  return Container(

                    padding: EdgeInsets.all(12),
                    decoration: LibraryUiFuncs.getBoxDecorationStyle(appUiModel.isDarkMode),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                      Padding(
                        padding: const EdgeInsets.only(top: 4),
                        child: CustomText("CSC 213", fontSize: 15, fontWeight: FontWeight.bold, ),
                      ),

                        ConstantSizing.columnSpacing(8),

                        CustomText("Abstract Algebra I", fontSize: 11, fontWeight: FontWeight.bold,),

                        Expanded(
                          child: Column(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              // CustomText("This is a Content."),
                              CustomText("3 categories", fontSize: 14,),
                            ]
                          )
                        ),


                        ConstantSizing.columnSpacing(16),
                        Row(
                          children: [
                            Expanded(
                              child: LinearProgressIndicator(
                                minHeight: 16,
                                borderRadius: BorderRadius.circular(36),
                                value: 0.4,
                                backgroundColor: Colors.black.withAlpha(40),
                                color: Colors.deepPurple, //.withAlpha(40)
                              ),
                            ),
                            ConstantSizing.rowSpacing(8),
                            CustomText("40%", fontSize: 12,),
                          ],
                        ),
                    ],)
                  );
                }, childCount: 30),
              ),
            ),

            SliverToBoxAdapter(child: ConstantSizing.columnSpacing(kBottomNavigationBarHeight + 8)),

            // TODO: there's be a My Books grid for custom additions or starred books
          ],
        ),
      ),
    );
  }

  Widget buildGridItem({required String title, required Widget icon}) {
    return InkWell(
      borderRadius: BorderRadius.circular(8),
      onTap: () {},
      child: Padding(
        padding: const EdgeInsets.all(8.0),
        child: Column(
          children: [
            Container(
              padding: const EdgeInsets.all(12),
              width: 60,
              height: 60,
              decoration: LibraryUiFuncs.getBoxDecorationStyle(appUiModel.isDarkMode),
              child: icon,
            ),
            ConstantSizing.columnSpacingMedium,
            CustomText(title, textAlign: TextAlign.center, fontSize: 12),
          ],
        ),
      ),
    );
  }
}
