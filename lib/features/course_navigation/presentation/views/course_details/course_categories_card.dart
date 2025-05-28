import 'package:custom_widgets_toolkit/custom_widgets_toolkit.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:slides_sync/shared/styles/external/ui_styles.dart';

class CourseCategoriesCard extends ConsumerWidget {
  final bool isDarkMode;
  final String title;
  final Widget icon;
  final void Function() onTap;
  const CourseCategoriesCard({super.key, required this.isDarkMode, required this.title, required this.onTap, required this.icon});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    return InkWell(
      borderRadius: BorderRadius.circular(12),
      onTap: onTap,
      child: DecoratedBox(
        decoration: UiStyles.getBlueThemedBoxDecoration(isDarkMode),
        child: Padding(
          padding: EdgeInsets.all(12),
          
          child: Row(
            children: [
              Container(
                width: 42,
                height: 42,
                clipBehavior: Clip.hardEdge,
                decoration: BoxDecoration(
                  color: Colors.deepPurple,
                  shape: BoxShape.circle,
                  border: Border.fromBorderSide(BorderSide(color: Colors.deepPurpleAccent.withAlpha(40), width: 1.0)),
                ),
                child: ClipOval(child: icon),
              ),
              ConstantSizing.rowSpacingMedium,
              Expanded(child: CustomText(title, fontSize: 15)),
              CustomText("15 items", fontSize: 12, color: Colors.grey),
            ],
          ),
        ),
      ),
    );
  }
}
