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

    return ClipRSuperellipse(
      borderRadius: BorderRadius.circular(20),
      child: BackdropFilter(
        filter: ImageFilter.blur(sigmaX: isScrolled ? 8 : 0, sigmaY: isScrolled ? 8 : 0),
        child: BottomNavigationBar(
          type: BottomNavigationBarType.fixed,
          currentIndex: currentIndex,
          selectedItemColor: context.theme.primaryColor,
          onTap: (index) => onTap(index),
          backgroundColor: isScrolled ? context.theme.cardColor.withValues(alpha: 0.4) : context.theme.cardColor,
          elevation: 48,
          items: [
            BottomNavigationBarItem(icon: Icon(Iconsax.home), label: "Home", tooltip: "Home"),
            BottomNavigationBarItem(icon: Icon(Iconsax.folder), label: "Library", tooltip: "Library holding all your courses"),
            BottomNavigationBarItem(icon: Icon(Icons.explore_rounded), label: "Explore", tooltip: "Explore courses"),
          ],
        ),
      ),
    );
  }
}
