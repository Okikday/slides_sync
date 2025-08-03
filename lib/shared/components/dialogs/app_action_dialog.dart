// ignore_for_file: public_member_api_docs, sort_constructors_first
import 'package:custom_widgets_toolkit/custom_widgets_toolkit.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:slides_sync/shared/components/dialogs/app_customizable_dialog.dart';
import 'package:slides_sync/shared/helpers/extension_helper.dart';
import 'package:slides_sync/shared/styles/colors.dart';

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
  final void Function()? onPop;
  const AppActionDialog({
    super.key,
    this.title = "Title",
    this.blurSigma,
    this.backgroundColor,
    this.alignment,
    this.leading,
    required this.actions,
    this.onPop,
  });

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final divider = Divider(color: AppColors.bgBlendColor(context), height: 0);
    return AppCustomizableDialog(
      blurSigma: blurSigma,
      backgroundColor: backgroundColor,
      alignment: alignment ?? Alignment.center,
      onPop: onPop,
      leading: Column(
        mainAxisSize: MainAxisSize.min,
        crossAxisAlignment: CrossAxisAlignment.start,
        children:
            leading != null
                ? [leading!, divider]
                : [
                  ConstantSizing.columnSpacingSmall,
                  Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 8),
                    child: Center(child: CustomText(title!, color: context.theme.colorScheme.tertiary, fontWeight: FontWeight.bold, fontSize: 18, textAlign: TextAlign.center)),
                  ),
                  ConstantSizing.columnSpacingSmall,
                  divider,
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
            children: [BuildPlainActionButton(title: action.title, icon: action.icon, onTap: action.onTap), divider],
          );
        },
      ),
    );
  }
}

class BuildPlainActionButton extends ConsumerWidget {
  final String title;
  final Widget icon;
  final void Function()? onTap;

  final Color? backgroundColor;
  final TextStyle? textStyle;
  final EdgeInsets? contentPadding;
  const BuildPlainActionButton({
    super.key,
    required this.title,
    required this.icon,
    this.onTap,
    this.backgroundColor,
    this.textStyle,
    this.contentPadding = const EdgeInsets.symmetric(horizontal: 12.0, vertical: 12.0),
  });

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    return CustomElevatedButton(
      borderRadius: 0,
      backgroundColor: backgroundColor ?? Colors.transparent,
      contentPadding: contentPadding,
      onClick: onTap,
      child: Row(
        spacing: 12.0,
        children: [icon, Expanded(child: CustomText(title, color: AppColors.primaryText(context), style: textStyle))],
      ),
    );
  }
}
