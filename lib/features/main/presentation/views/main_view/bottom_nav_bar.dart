import 'dart:ui';

import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:iconsax_flutter/iconsax_flutter.dart';
import 'package:slides_sync/features/main/presentation/providers/main_providers.dart';
import 'package:slides_sync/shared/helpers/extension_helper.dart';

class BottomNavBar extends ConsumerWidget {
  final void Function(int index) onTap;
  const BottomNavBar({super.key, required this.onTap});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    // final bool isScrolled = ref.watch(isMainScrolledProvider);
    final int currentIndex = ref.watch(mainTabViewIndexProvider);

    return Container(
      clipBehavior: Clip.antiAlias,

      // margin: EdgeInsets.only(bottom: context.bottomPadding, left: 8, right: 8),
      decoration: BoxDecoration(
        // borderRadius: BorderRadius.circular(kBottomNavigationBarHeight),
        // color: ref.theme.background..withValues(alpha: 0.8),
        border: Border(top: BorderSide(color: ref.theme.bgText.withAlpha(80))),
      ),
      child: BackdropFilter(
        filter: ImageFilter.blur(sigmaX: 4, sigmaY: 4),
        child: BottomNavigationBar(
          type: BottomNavigationBarType.fixed,
          currentIndex: currentIndex,
          unselectedItemColor: ref.theme.secondaryText,
          selectedItemColor: ref.theme.primaryColor,
          onTap: (index) => onTap(index),
          backgroundColor: ref.theme.background.withValues(alpha: 0.8),
          elevation: 0,
          landscapeLayout: BottomNavigationBarLandscapeLayout.linear,
          items: [
            BottomNavigationBarItem(icon: Icon(Iconsax.home), label: "Home", tooltip: "Home"),
            BottomNavigationBarItem(
              icon: Icon(Iconsax.folder),
              label: "Library",
              tooltip: "Library holding all your courses",
            ),
            BottomNavigationBarItem(icon: Icon(Icons.explore_rounded), label: "Explore", tooltip: "Explore courses"),
          ],
        ),
      ),
    );
  }
}
