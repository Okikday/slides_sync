import 'package:custom_widgets_toolkit/custom_widgets_toolkit.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:slides_sync/shared/helpers/extension_helper.dart';

import 'component_widgets.dart';

class AppBarContainerChild extends ConsumerWidget {
  const AppBarContainerChild(
    this.isDarkMode, {
    super.key,
    required this.title,
    this.titleStyle,
    this.subtitle,
    this.subtitleStyle,
    this.tooltipMessage,
    this.onBackButtonClicked,
    this.trailing,
  });

  final bool isDarkMode;
  final String title;
  final String? subtitle;
  final TextStyle? titleStyle;
  final TextStyle? subtitleStyle;
  final String? tooltipMessage;
  final void Function()? onBackButtonClicked;
  final Widget? trailing;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    return Material(
      type: MaterialType.transparency,
      shape: LinearBorder(
        bottom: LinearBorderEdge(),
        side: BorderSide(color: context.theme.colorScheme.onSecondary.withAlpha(80)),
      ),
      child: Padding(
        padding: EdgeInsets.symmetric(horizontal: 12),
        child: Tooltip(
          triggerMode: TooltipTriggerMode.tap,
          message: tooltipMessage ?? title,
          child: Row(
            children: [
              ComponentWidgets.backButton(context, onPressed: onBackButtonClicked),
              ConstantSizing.rowSpacingMedium,
              Expanded(
                child:
                    (subtitle != null || (subtitle != null && subtitle!.isNotEmpty))
                        ? Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          mainAxisAlignment: MainAxisAlignment.center,
                          spacing: 2.5,
                          children: [
                            CustomText(title, fontSize: 17.5, fontWeight: FontWeight.bold, overflow: TextOverflow.ellipsis, color: context.theme.colorScheme.tertiary,),
                            CustomText(subtitle!, fontSize: 12, color: context.theme.colorScheme.onTertiary, overflow: TextOverflow.ellipsis, style: subtitleStyle),
                          ],
                        )
                        : CustomText(title, fontSize: 17.5, fontWeight: FontWeight.bold, overflow: TextOverflow.ellipsis, style: titleStyle, color: context.theme.colorScheme.tertiary),
              ),
              if(trailing == null) ConstantSizing.rowSpacingMedium,
              if (trailing != null) trailing!,
            ],
          ),
        ),
      ),
    );
  }
}
