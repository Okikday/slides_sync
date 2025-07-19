import 'dart:ui';

import 'package:custom_widgets_toolkit/custom_widgets_toolkit.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:iconsax_flutter/iconsax_flutter.dart';
import 'package:slides_sync/features/main/presentation/providers/main_providers.dart';
import 'package:slides_sync/shared/helpers/extension_helper.dart';
import 'package:slides_sync/shared/styles/colors.dart';

class HomeAppBar extends ConsumerWidget {
  const HomeAppBar({super.key, required this.onClickUserIcon, required this.title, required this.onClickNotification});

  final void Function() onClickUserIcon;

  final String title;
  final void Function() onClickNotification;
  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final topPadding = context.topPadding;
    final bool isScrolled = ref.watch(isMainScrolledProvider);
    return SliverAppBar(
      elevation: 64,
      pinned: true,
      automaticallyImplyLeading: false,
      centerTitle: false,
      leadingWidth: 0,
      expandedHeight: kToolbarHeight + (topPadding / 2),
      collapsedHeight: kToolbarHeight + (topPadding / 2),
      forceMaterialTransparency: true,
      surfaceTintColor: Colors.transparent,
      systemOverlayStyle: SystemUiOverlayStyle(
        statusBarColor:
            isScrolled
                ? AppColors.bgBlendColor(context)
                : context.scaffoldBackgroundColor,
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
            shape:
                isScrolled
                    ? LinearBorder(
                      bottom: LinearBorderEdge(),
                      side: BorderSide(color: AppColors.bgBlendColor(context, .88, .12)),
                    )
                    : null,
            child:
                isScrolled
                    ? AnimatedContainer(
                      duration: Durations.medium3,
                      clipBehavior: Clip.hardEdge,
                      color: AppColors.bgBlendColor(context).withValues(alpha: 0.94),
                      child: BackdropFilter(filter: ImageFilter.blur(sigmaX: 4, sigmaY: 4), child: const SizedBox.expand(),),
                    )
                    : ColoredBox(color: context.scaffoldBackgroundColor),
          ),
        ),
        // collapseMode: CollapseMode.pin,
        titlePadding: EdgeInsets.zero,
        title: Align(
          alignment: Alignment(0, 0.75),
          child: GestureDetector(
            onTap: () {
              PrimaryScrollController.of(context).animateTo(0, duration: Durations.extralong1, curve: CustomCurves.defaultIosSpring);
            },
            child: AnimatedSize(
              duration: Durations.medium3,
              child: Padding(
                padding: EdgeInsets.fromLTRB(16, 8, 16, 4),
                child: Row(
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: [
                    CustomElevatedButton(
                      onClick: onClickUserIcon,
                      pixelHeight: context.defaultBtnDimension,
                      pixelWidth: context.defaultBtnDimension,
                      overlayColor: context.theme.colorScheme.secondary.withAlpha(40),
                      contentPadding: EdgeInsets.zero,
                      backgroundColor: AppColors.bgBlendColor(context, .85, .11),
                      shape: CircleBorder(),
                      child: Icon(
                        Iconsax.menu_1_copy,
                        color: isScrolled ? context.theme.colorScheme.tertiary : context.theme.colorScheme.onTertiary,
                        size: context.defaultBtnDimension * 0.5,
                      ),
                    ),

                    ConstantSizing.rowSpacingMedium,
                    Expanded(child: CustomText(title, fontSize: 17, fontWeight: FontWeight.bold, color: context.theme.colorScheme.primary)),

                    // CustomElevatedButton(
                    //   shape: CircleBorder(),
                    //   backgroundColor: context.theme.secondary.withAlpha(40),
                    //   overlayColor: context.theme.primaryColor.withAlpha(20),
                    //   onClick: onToggleFullScreen,
                    //   child: Icon(Iconsax.crop, color: context.isDarkMode ? Colors.white : context.theme.primaryColor),
                    // ),
                    CustomElevatedButton(
                      onClick: onClickNotification,
                      overlayColor: context.theme.colorScheme.secondary.withAlpha(40),
                      shape: CircleBorder(),
                      backgroundColor: AppColors.bgBlendColor(context, .86, isScrolled ? 0.11 : 0.1),
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
                        child: Icon(
                          Iconsax.notification,
                          color: context.isDarkMode && isScrolled ? context.theme.colorScheme.tertiary : context.theme.colorScheme.onTertiary,
                          size: 24,
                        ),
                      ),
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
