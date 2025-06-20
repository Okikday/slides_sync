import 'package:custom_widgets_toolkit/custom_widgets_toolkit.dart';
import 'package:flutter/material.dart';
import 'package:slides_sync/shared/helpers/extension_helper.dart';

class BuildButton extends StatelessWidget {
  const BuildButton({super.key, required this.onTap, required this.iconData});

  final void Function() onTap;
  final IconData iconData;

  @override
  Widget build(BuildContext context) {
    return CustomElevatedButton(
      contentPadding: EdgeInsets.all(12),
      backgroundColor: Colors.lightBlueAccent.withAlpha(40),
      shape: CircleBorder(),
      onClick: onTap,
      child: Icon(iconData, size: 20, color: context.isDarkMode ? Colors.white : Colors.black),
    );
  }
}
