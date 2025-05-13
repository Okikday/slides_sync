import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:custom_widgets_toolkit/custom_widgets_toolkit.dart';

class ManageCourseButton extends ConsumerWidget {
  final String title;
  final IconData iconData;
  final void Function() onTap;
  const ManageCourseButton({super.key, required this.title, required this.iconData, required this.onTap});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    return Column(
      mainAxisSize: MainAxisSize.min,
      spacing: 16,
      children: [
        CustomElevatedButton(
        onClick: onTap,
        shape: CircleBorder(),
        overlayColor: Colors.lightBlueAccent.withAlpha(100),
        pixelHeight: 100,
        pixelWidth: 100,
        backgroundColor: Colors.lightBlueAccent.withAlpha(80),
        textColor: Colors.white,
        borderRadius: 24,
        child: Icon(iconData, size: 64),
      ),
      CustomText(title),
      ],
    );
  }
}