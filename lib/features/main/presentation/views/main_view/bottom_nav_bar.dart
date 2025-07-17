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
    final bool isScrolled = ref.watch(isMainScrolledProvider);
    final int currentIndex = ref.watch(mainTabViewIndexProvider);

    return Container(
      clipBehavior: Clip.hardEdge,
      padding: EdgeInsets.fromLTRB(8, 0, 8, context.bottomPadding + 8),
      decoration: BoxDecoration(
        boxShadow: [BoxShadow(color: Colors.black.withAlpha(20), blurRadius: kBottomNavigationBarHeight / 2, spreadRadius: 4)],
      ),
      child: ClipRSuperellipse(
        borderRadius: BorderRadius.circular(kBottomNavigationBarHeight),
        child: BackdropFilter(
          filter: ImageFilter.blur(sigmaX: 8, sigmaY: 8),
          child: BottomNavigationBar(
            type: BottomNavigationBarType.fixed,
            currentIndex: currentIndex,
            unselectedItemColor: context.theme.colorScheme.onTertiary,
            selectedItemColor: context.theme.primaryColor,
            onTap: (index) => onTap(index),
            backgroundColor:
                isScrolled
                    ? HSLColor.fromColor(context.theme.scaffoldBackgroundColor).withLightness(0.1).toColor().withValues(alpha: 0.2)
                    : HSLColor.fromColor(context.theme.scaffoldBackgroundColor).withLightness(0.1).toColor().withValues(alpha: 0.8),
            elevation: 12,
            items: [
              BottomNavigationBarItem(icon: Icon(Iconsax.home), label: "Home", tooltip: "Home"),
              BottomNavigationBarItem(icon: Icon(Iconsax.folder), label: "Library", tooltip: "Library holding all your courses"),
              BottomNavigationBarItem(icon: Icon(Icons.explore_rounded), label: "Explore", tooltip: "Explore courses"),
            ],
          ),
        ),
      ),
    );
  }
}
