import 'package:custom_widgets_toolkit/custom_widgets_toolkit.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:iconsax_flutter/iconsax_flutter.dart';
import 'package:slides_sync/shared/styles/app_ui_context.dart';

class AllCoursesHeader extends ConsumerWidget {
  final void Function() onTap;
  final void Function() onTapGridButton;
  final bool isListView;
  const AllCoursesHeader({super.key, required this.onTap, required this.isListView, required this.onTapGridButton});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    
    return Padding(
        padding: const EdgeInsets.symmetric(horizontal: 18, vertical: 4),
        child: GestureDetector(
          onTap: onTap,
          child: Row(
            children: [
              Expanded(child: CustomText("All Courses", fontSize: 20, fontWeight: FontWeight.bold)),
        
              CustomElevatedButton(
                contentPadding: EdgeInsets.all(8),
                backgroundColor: Colors.lightBlueAccent.withAlpha(40),
                shape: CircleBorder(),
                onClick: onTapGridButton,
                child: Icon(isListView ? Iconsax.menu : Icons.list_rounded, size: 20, color: context.isDarkMode ? Colors.white : Colors.black),
              ),
            ],
          ),
        )
    );
  }
}
