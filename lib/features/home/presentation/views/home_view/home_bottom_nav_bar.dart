import 'dart:ui';

import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:iconsax_flutter/iconsax_flutter.dart';
import 'package:slides_sync/app/models/app_ui_model.dart';

class HomeBottomNavBar extends ConsumerWidget {
  final AppUiModel appUiModel;
  final int currentIndex;
  final bool isScrolled;
  final void Function(int index) onTap;
  const HomeBottomNavBar({super.key, required this.appUiModel, required this.currentIndex, required this.onTap, required this.isScrolled});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    return ClipRRect(
      child: BackdropFilter(
        filter: ImageFilter.blur(sigmaX: isScrolled ? 8 : 0, sigmaY: isScrolled ? 8 : 0),
        child: BottomNavigationBar(
          currentIndex: currentIndex,
          selectedItemColor: Colors.deepPurple,
          onTap: (index) => onTap(index),
          backgroundColor:
          isScrolled ? Colors.lightBlueAccent.withAlpha(20) : (appUiModel.isDarkMode ? Color(0xff0e1d27) : Color(0xffd6ebf9)),
          elevation: 48,
          items: [
            BottomNavigationBarItem(icon: Icon(Iconsax.home), label: "Home", tooltip: "Home"),
            BottomNavigationBarItem(icon: Icon(Iconsax.folder), label: "Library", tooltip: "Library"),
            BottomNavigationBarItem(icon: Icon(Icons.explore_rounded), label: "Explore", tooltip: "Explore"),
          ],
        ),
      ),
    );
  }
}