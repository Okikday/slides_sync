// ignore_for_file: public_member_api_docs, sort_constructors_first
import 'package:custom_widgets_toolkit/custom_widgets_toolkit.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:slides_sync/shared/components/dialogs/app_customizable_dialog.dart';
import 'package:slides_sync/shared/styles/app_ui_context.dart';

class AppActionDialogModel {
  final String title;

  final Widget icon;
  final void Function() onTap;

  AppActionDialogModel({required this.title, required this.icon, required this.onTap});

  AppActionDialogModel copyWith({String? title, Widget? icon, void Function()? onTap}) {
    return AppActionDialogModel(title: title ?? this.title, icon: icon ?? this.icon, onTap: onTap ?? this.onTap);
  }
}

class AppActionDialog extends ConsumerWidget {
  final String? title;
  final Widget? leading;
  final Alignment? alignment;
  final Offset? blurSigma;
  final Color? backgroundColor;
  final List<AppActionDialogModel> actions;
  const AppActionDialog({super.key, this.title = "Title", this.blurSigma, this.backgroundColor, this.alignment, this.leading, required this.actions});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    return AppCustomizableDialog(
      blurSigma: blurSigma,
      backgroundColor: backgroundColor,
      alignment: alignment ?? Alignment.center,
      leading: Column(
        mainAxisSize: MainAxisSize.min,
        crossAxisAlignment: CrossAxisAlignment.start,
        children:
            leading != null
                ? [leading!, Divider(color: context.isDarkMode ? Colors.lightBlue.withAlpha(40) : Colors.grey.withAlpha(40), height: 0)]
                : [
                  ConstantSizing.columnSpacingSmall,
                  Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 8),
                    child: Center(child: CustomText(title!, fontWeight: FontWeight.bold, fontSize: 18, textAlign: TextAlign.center)),
                  ),
                  ConstantSizing.columnSpacingSmall,
                  Divider(color: context.isDarkMode ? Colors.lightBlue.withAlpha(40) : Colors.grey.withAlpha(40), height: 0),
                ],
      ),
      child: ListView.builder(
        padding: EdgeInsets.zero,
        shrinkWrap: true,
        itemCount: actions.length,
        itemBuilder: (context, index) {
          final action = actions[index];

          if (index == actions.length - 1) {
            return BuildPlainActionButton(title: action.title, icon: action.icon, onTap: action.onTap);
          }

          return Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              BuildPlainActionButton(title: action.title, icon: action.icon, onTap: action.onTap),
              Divider(color: Colors.lightBlueAccent.withAlpha(20), height: 0),
            ],
          );
        },
      ),
    );
  }
}

class BuildPlainActionButton extends ConsumerWidget {
  final String title;
  final Widget icon;
  final void Function() onTap;
  const BuildPlainActionButton({super.key, required this.title, required this.icon, required this.onTap});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    return CustomElevatedButton(
      borderRadius: 0,
      backgroundColor: Colors.transparent,
      contentPadding: EdgeInsets.symmetric(horizontal: 12.0, vertical: 16.0),
      onClick: onTap,
      child: Row(spacing: 12.0, children: [icon, Expanded(child: CustomText(title))]),
    );
  }
}
