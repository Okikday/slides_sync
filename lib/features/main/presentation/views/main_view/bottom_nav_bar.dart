import 'dart:ui';

import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:iconsax_flutter/iconsax_flutter.dart';
import 'package:slides_sync/features/main/presentation/providers/main_providers.dart';
import 'package:slides_sync/shared/helpers/extension_helper.dart';
import 'package:slides_sync/shared/styles/colors.dart';

class BottomNavBar extends ConsumerWidget {
  final void Function(int index) onTap;
  const BottomNavBar({super.key, required this.onTap});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    // final bool isScrolled = ref.watch(isMainScrolledProvider);
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
          filter: ImageFilter.blur(sigmaX: 4, sigmaY: 4),
          child: BottomNavigationBar(
            type: BottomNavigationBarType.fixed,
            currentIndex: currentIndex,
            unselectedItemColor: context.theme.colorScheme.onTertiary,
            selectedItemColor: context.theme.primaryColor,
            onTap: (index) => onTap(index),
            backgroundColor: AppColors.bgBlendColor(context).withValues(alpha: 0.86),
            elevation: 48,
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
