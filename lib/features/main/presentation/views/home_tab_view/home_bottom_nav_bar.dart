import 'dart:ui';

import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:iconsax_flutter/iconsax_flutter.dart';
import 'package:slides_sync/shared/helpers/extension_helper.dart';

class HomeBottomNavBar extends ConsumerWidget {
  final int currentIndex;
  final bool isScrolled;
  final void Function(int index) onTap;
  const HomeBottomNavBar({super.key, required this.currentIndex, required this.onTap, required this.isScrolled});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    return ClipRSuperellipse(
      // borderRadius: BorderRadius.circular(20),
      child: BackdropFilter(
        filter: ImageFilter.blur(sigmaX: isScrolled ? 8 : 0, sigmaY: isScrolled ? 8 : 0),
        child: BottomNavigationBar(
          type: BottomNavigationBarType.fixed,
          currentIndex: currentIndex,
          selectedItemColor: Colors.deepPurple,
          onTap: (index) => onTap(index),
          backgroundColor: isScrolled ? Colors.lightBlueAccent.withAlpha(20) : (context.isDarkMode ? Color(0xff0e1d27) : Color(0xffd6ebf9)),
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
