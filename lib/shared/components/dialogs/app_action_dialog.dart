// ignore_for_file: public_member_api_docs, sort_constructors_first
import 'package:custom_widgets_toolkit/custom_widgets_toolkit.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:slides_sync/shared/components/dialogs/app_customizable_dialog.dart';

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
  final String title;
  final List<AppActionDialogModel> actions;
  const AppActionDialog({super.key, required this.title, required this.actions});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    return AppCustomizableDialog(
      title: title,
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
              Divider(color: Colors.lightBlueAccent.withAlpha(20)),
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
      onClick: onTap,
      child: Row(spacing: 12.0, children: [icon, Expanded(child: CustomText(title))]),
    );
  }
}
