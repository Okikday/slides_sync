import 'package:custom_widgets_toolkit/custom_widgets_toolkit.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:slides_sync/shared/helpers/extension_helper.dart';
import 'package:slides_sync/shared/styles/colors.dart';

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
        side: BorderSide(color: AppColors.bgBlendColor(context, .89, .11)),
      ),
      child: Padding(
        padding: EdgeInsets.symmetric(horizontal: 12),
        child: Tooltip(
          triggerMode: TooltipTriggerMode.tap,
          message: tooltipMessage ?? title,
          child: Row(
            children: [
              AppBackButton(onPressed: onBackButtonClicked),
              ConstantSizing.rowSpacing(8),
              Expanded(
                child:
                    (subtitle != null ||
                            (subtitle != null && subtitle!.isNotEmpty))
                        ? Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          mainAxisAlignment: MainAxisAlignment.center,
                          spacing: 2.5,
                          children: [
                            CustomText(
                              title,
                              fontSize: 17,
                              fontWeight: FontWeight.bold,
                              overflow: TextOverflow.ellipsis,
                              color: ref.theme.primaryText,
                            ),
                            CustomText(
                              subtitle!,
                              fontSize: 12,
                              color: AppColors.bgBlendColor(context, .6, .4),
                              overflow: TextOverflow.ellipsis,
                              style: subtitleStyle,
                            ),
                          ],
                        )
                        : CustomText(
                          title,
                          fontSize: 17,
                          fontWeight: FontWeight.bold,
                          overflow: TextOverflow.ellipsis,
                          style: titleStyle,
                          color: ref.theme.primaryText,
                        ),
              ),
              if (trailing == null) ConstantSizing.rowSpacingMedium,
              if (trailing != null) trailing!,
            ],
          ),
        ),
      ),
    );
  }
}

class AppBackButton extends ConsumerWidget {
  final Color? backgroundColor;
  final void Function()? onPressed;
  const AppBackButton({super.key, this.backgroundColor, this.onPressed});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final theme = ref.theme;
    return IconButton(
      color: theme.secondaryText,
      onPressed: () {
        if (onPressed == null) {
          context.pop();
          return;
        } else {
          onPressed!();
        }
      },
      icon: Icon(
        Icons.arrow_back_ios_new_rounded,
        size: 20,
        color: theme.secondaryText,
      ),
      style: ButtonStyle(
        backgroundColor: WidgetStatePropertyAll(
          backgroundColor ?? theme.altBackgroundPrimary,
        ),
      ),
    );
  }
}
