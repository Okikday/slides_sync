import 'package:custom_widgets_toolkit/custom_widgets_toolkit.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import 'component_widgets.dart';

class AppBarContainerChild extends ConsumerWidget {
  const AppBarContainerChild(this.isDarkMode, {
    super.key,
    required this.title,
    this.onBackButtonClicked,
    this.trailing
  });

  final bool isDarkMode;
  final String title;
  final void Function()? onBackButtonClicked;
  final Widget? trailing;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    return Material(
      type: MaterialType.transparency,
      shape: LinearBorder(
        bottom: LinearBorderEdge(),
        side: BorderSide(color: isDarkMode ? Colors.lightBlueAccent.withAlpha(60) : Colors.grey.withAlpha(40)),
      ),
      child: Padding(
        padding: EdgeInsets.symmetric(horizontal: 12),
        child: Tooltip(
          triggerMode: TooltipTriggerMode.tap,
          message: title,
          child: Row(
            children: [
              ComponentWidgets.backButton(context, onPressed: onBackButtonClicked),
              ConstantSizing.rowSpacingMedium,
              Expanded(child: CustomText(title, fontSize: 18, fontWeight: FontWeight.bold, overflow: TextOverflow.ellipsis,)),
              if(trailing != null) trailing!
            ],
          ),
        ),
      ),
    );
  }
}