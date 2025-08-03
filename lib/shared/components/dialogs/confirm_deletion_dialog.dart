import 'package:custom_widgets_toolkit/custom_widgets_toolkit.dart';
import 'package:flutter/material.dart';
import 'package:flutter_animate/flutter_animate.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:slides_sync/shared/components/dialogs/app_alert_dialog.dart';
import 'package:slides_sync/shared/helpers/extension_helper.dart';

class ConfirmDeletionDialog extends ConsumerWidget {
  final String title;
  final String content;
  final void Function()? onCancel;
  final void Function() onDelete;
  final void Function()? onPop;
  const ConfirmDeletionDialog({
    super.key,
    this.title = "Confirm deletion",
    this.content = "Are you sure you want to delete?",
    this.onCancel,
    required this.onDelete,
    this.onPop,
  });

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    return AppAlertDialog(
      title: title,
      content: content,

      backgroundColor: context.scaffoldBackgroundColor.withValues(alpha: 0.5),
      onPop: onPop,
      actions: [
        _buildDialogButton(
          label: "Cancel",
          textColor: context.isDarkMode ? Colors.white : Colors.black,
          backgroundColor: Colors.blueGrey.withAlpha(40),
          onClick: () {
            if (onCancel == null) {
              CustomDialog.hide(context);
              return;
            }
            onCancel!();
          },
        ),

        _buildDialogButton(label: "Delete", textColor: Colors.red, backgroundColor: Colors.red.withAlpha(40), onClick: onDelete),
      ],
    ).animate().fadeIn().scaleY(
      begin: 0.2,
      end: 1,
      alignment: Alignment.bottomRight,
      duration: Duration(milliseconds: 500),
      curve: CustomCurves.defaultIosSpring,
    );
    
  }
}

// Dialog button
Widget _buildDialogButton({
  required String label,
  Color textColor = Colors.white,
  Color backgroundColor = Colors.transparent,
  required void Function() onClick,
}) {
  return CustomElevatedButton(
    label: label,
    textSize: 14,
    pixelHeight: 44,
    textColor: textColor,
    backgroundColor: backgroundColor,
    borderRadius: ConstantSizing.borderRadiusCircle,
    onClick: onClick,
  );
}
