import 'package:custom_widgets_toolkit/custom_widgets_toolkit.dart';
import 'package:flutter/material.dart';
import 'package:flutter_animate/flutter_animate.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:slides_sync/shared/components/dialogs/app_customizable_dialog.dart';
import 'package:slides_sync/shared/helpers/extension_helper.dart';
import 'package:slides_sync/shared/styles/colors.dart';

class AppAlertDialog extends ConsumerWidget {
  final String title;
  final String content;
  final List<Widget> actions;
  final void Function()? onCancel;
  final void Function()? onConfirm;
  final void Function()? onPop;
  final Color? backgroundColor;
  const AppAlertDialog({
    super.key,
    required this.title,
    required this.content,
    this.onPop,
    this.actions = const [],
    this.onCancel,
    this.onConfirm,
    this.backgroundColor,
  });

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    return AppCustomizableDialog(
      backgroundColor: backgroundColor,
      child: Column(
        mainAxisSize: MainAxisSize.min,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          ConstantSizing.columnSpacingSmall,
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 8),
            child: Center(
              child: CustomText(
                title,
                fontWeight: FontWeight.bold,
                fontSize: 17,
                textAlign: TextAlign.center,
                color: context.theme.colorScheme.tertiary,
              ),
            ),
          ),
          ConstantSizing.columnSpacingSmall,
          Divider(color: AppColors.bgBlendColor(context)),
          ConstantSizing.columnSpacingSmall,
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 12),
            child: CustomText(content, fontSize: 14.5, color: context.theme.colorScheme.tertiary),
          ),
          ConstantSizing.columnSpacingExtraLarge,
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 12),
            child: Row(
              spacing: 16.0,
              children: [
                ...actions.map((e) => Flexible(child: e)),
                if (actions.isEmpty)
                  ...[
                    CustomElevatedButton(
                      label: "Cancel",
                      textSize: 14,
                      pixelHeight: 44,
                      textColor: Colors.red,
                      backgroundColor: Colors.red.withAlpha(40),
                      borderRadius: ConstantSizing.borderRadiusCircle,
                      onClick: () {
                        if (onCancel != null) onCancel!();
                      },
                    ),
                    CustomElevatedButton(
                      label: "Confirm",
                      textSize: 14,
                      pixelHeight: 44,
                      textColor: context.theme.primaryColor,
                      backgroundColor: context.theme.primaryColor.withAlpha(80),
                      borderRadius: ConstantSizing.borderRadiusCircle,
                      onClick: () {
                        if (onConfirm != null) onConfirm!();
                      },
                    ),
                  ].map((e) => Flexible(child: e)),
              ],
            ),
          ),
        ],
      ),
    );

  }
}
