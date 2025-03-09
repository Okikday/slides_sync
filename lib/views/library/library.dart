import 'dart:ui';

import 'package:custom_widgets_toolkit/custom_widgets_toolkit.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:iconsax_flutter/iconsax_flutter.dart';
import 'package:slides_sync/app/models/app_ui_model.dart';

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
        value: SystemUiOverlayStyle(statusBarColor: scaffoldBgColor,),
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

            PinnedHeaderSliver(
              child: ColoredBox(
                // color: Colors.lightBlueAccent.withAlpha(100),
                color: scaffoldBgColor,
                child: ClipRRect(
                  child: BackdropFilter(
                    filter: ImageFilter.blur(sigmaX: 8, sigmaY: 8,),
                    child: Padding(
                      padding: const EdgeInsets.symmetric(horizontal: 18),
                      child: Row(
                        children: [
                          Expanded(child: CustomText("All Courses", fontSize: 20, fontWeight: FontWeight.bold)),

                          CustomElevatedButton(
                            backgroundColor: Colors.transparent,
                            shape: CircleBorder(),
                            child: Icon(Iconsax.crop_copy, ),
                          ),

                          CustomElevatedButton(
                            backgroundColor: Colors.lightBlueAccent.withAlpha(40),
                            shape: CircleBorder(),
                            child: Icon(Iconsax.menu, size: 24, color: appUiModel.isDarkMode ? Colors.white : Colors.black,),
                          ),

                        ],
                      ),
                    ),
                  ),
                ),
              ),
            ),

            SliverToBoxAdapter(child: ConstantSizing.columnSpacingMedium),

            SliverPadding(
              padding: EdgeInsets.symmetric(horizontal: 12),
              sliver: SliverGrid(
                  gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(crossAxisCount: 2, mainAxisSpacing: 12, crossAxisSpacing: 12,),
                delegate: SliverChildBuilderDelegate((context, index){
                  return Container(color: Colors.blue, width: 200, height: 200,);
                }, childCount: 30),
              ),
            ),

            SliverToBoxAdapter(child: ConstantSizing.columnSpacing(kBottomNavigationBarHeight + 8)),

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
              decoration: BoxDecoration(
                color: Colors.lightBlueAccent.withAlpha(25),
                borderRadius: BorderRadius.circular(12),
                border: Border.all(width: 2, color: Colors.lightBlueAccent.withAlpha(25)),
                boxShadow:
                    appUiModel.isDarkMode
                        ? [
                          BoxShadow(
                            color: Colors.black.withAlpha(50),
                            blurRadius: 8,
                            offset: Offset(0, 0),
                            blurStyle: BlurStyle.inner,
                            spreadRadius: 2,
                          ),
                        ]
                        : [
                          BoxShadow(
                            color: Colors.lightBlueAccent.withAlpha(25),
                            blurRadius: 8,
                            offset: Offset(0, 0),
                            blurStyle: BlurStyle.inner,
                            spreadRadius: 2,
                          ),
                        ],
              ),
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
