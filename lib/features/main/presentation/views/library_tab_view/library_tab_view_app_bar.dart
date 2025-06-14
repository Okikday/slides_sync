import 'dart:ui';
import 'package:custom_widgets_toolkit/custom_widgets_toolkit.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:iconsax_flutter/iconsax_flutter.dart';
import 'package:slides_sync/core/utils/util_functions.dart';
import 'package:slides_sync/features/main/presentation/providers/is_list_view_notifier.dart';
import 'package:slides_sync/shared/styles/app_ui_context.dart';

class LibraryTabViewAppBar extends ConsumerWidget {
  const LibraryTabViewAppBar({super.key, required this.isListViewProvider, required this.scrollOffsetProvider});

  final AsyncNotifierProvider<IsListViewNotifier, bool> isListViewProvider;
  final StateProvider<double> scrollOffsetProvider;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final AsyncValue<bool> asyncIsListView = ref.watch(isListViewProvider);
    final double scrollOffset = ref.watch(scrollOffsetProvider);

    final double maxHeight = 240; // context.deviceHeight * 0.3
    final double minHeight = 80;
    final double percentScroll = 1.0 - scrollOffset / (maxHeight - minHeight);

    final CustomText textWidget = CustomText(
      "All Courses",
      fontSize: (50 * percentScroll).clamp(20.0, 26),
      fontWeight: FontWeight.bold,
      textAlign: TextAlign.center,
    );
    final Size textSize = UtilFunctions.getTextSize(textWidget.data, textWidget.effectiveStyle(context));

    final double leftPad = (double.parse((context.deviceWidth / 2 - textSize.width / 2).toStringAsFixed(2)) * percentScroll).clamp(
      24.0,
      double.infinity,
    );
    final double bottomPad = (double.parse((maxHeight / 2 - textSize.height / 2).toStringAsFixed(2)) * percentScroll).clamp(
      12.0,
      double.infinity,
    );

    return SliverAppBar(
      pinned: true,
      collapsedHeight: minHeight,
      expandedHeight: maxHeight,
      surfaceTintColor: Colors.transparent,
      backgroundColor: context.scaffoldBackgroundColor.withAlpha(200),

      automaticallyImplyLeading: false,
      flexibleSpace: FlexibleSpaceBar(
        expandedTitleScale: 1.0,
        title: GestureDetector(
          onTap: () {
            PrimaryScrollController.of(context).animateTo(0, duration: Durations.extralong1, curve: CustomCurves.defaultIosSpring);
          },
          child: ClipRSuperellipse(
            child: BackdropFilter(
              filter: ImageFilter.blur(sigmaX: 4, sigmaY: 4),
              child: ColoredBox(
                color: context.scaffoldBackgroundColor.withAlpha(200),
                child: Stack(
                  children: [
                    Column(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        Expanded(child: SizedBox()),

                        // ALL COURSES HEADER
                        Padding(
                          padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 4),
                          child: Row(
                            spacing: 8.0,
                            crossAxisAlignment: CrossAxisAlignment.end,
                            children: [
                              const Expanded(child: SizedBox()),

                              CustomElevatedButton(
                                contentPadding: EdgeInsets.all(12),
                                backgroundColor: Colors.lightBlueAccent.withAlpha(40),
                                shape: CircleBorder(),
                                child: Icon(Iconsax.search_normal_copy, size: 20, color: context.isDarkMode ? Colors.white : Colors.black),
                                onClick: (){
                                  
                                },
                              ),

                              CustomElevatedButton(
                                contentPadding: EdgeInsets.all(12),
                                backgroundColor: Colors.lightBlueAccent.withAlpha(40),
                                shape: CircleBorder(),
                                onClick: () {
                                  ref.read(isListViewProvider.notifier).toggle();
                                },
                                child: Icon(
                                  asyncIsListView.value ?? false ? Iconsax.menu : Icons.list_rounded,
                                  size: 20,
                                  color: context.isDarkMode ? Colors.white : Colors.black,
                                ),
                              ),
                            ],
                          ),
                        ),
                      ],
                    ),

                    Positioned(
                      // left: 24,
                      // bottom: 12,
                      bottom: bottomPad,
                      left: leftPad,
                      child: textWidget,
                    ),
                  ],
                ),
              ),
            ),
          ),
        ),
      ),
    );
  }
}
