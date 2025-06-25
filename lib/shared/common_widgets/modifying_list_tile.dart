import 'package:custom_widgets_toolkit/custom_widgets_toolkit.dart';
import 'package:flutter/material.dart';
import 'package:slides_sync/shared/helpers/extension_helper.dart';

class ModifyingListTile extends StatelessWidget {
  final Widget leadingIcon;
  final Widget trailingIcon;
  final String title;
  final String subtitle;
  final void Function()? onTapTile;
  final void Function()? onTapLeading;
  final void Function()? onTapTrailing;
  final void Function()? onLongPressTile;

  const ModifyingListTile({
    super.key,
    required this.leadingIcon,
    required this.trailingIcon,
    required this.title,
    required this.subtitle,
    this.onTapTile,
    this.onTapLeading,
    this.onTapTrailing,
    this.onLongPressTile,
  });

  @override
  Widget build(BuildContext context) {
    final buttonPadding = context.hPadding5;
    final btnDimension = context.defaultBtnDimension;

    return Padding(
      padding: EdgeInsets.only(bottom: buttonPadding),
      child: ClipRRect(
        borderRadius: BorderRadius.circular(16),
        child: ColoredBox(
          // color: context.isDarkMode ? Color.fromARGB(255, 52, 33, 79) : Color(0xFFDBF3FF),
          color: context.isDarkMode ? Color.fromARGB(255, 46, 29, 70) : Color(0xFFDBF3FF).withValues(alpha: 0.89),
          child: Padding(
            padding: const EdgeInsets.all(4.0),
            child: CustomElevatedButton(
              onClick: onTapTile,
              onLongClick: onLongPressTile,
              borderRadius: 12,

              contentPadding: EdgeInsets.all(buttonPadding),
              // backgroundColor: context.isDarkMode ? Color.fromARGB(255, 46, 29, 70) : Color(0xFFDBF3FF).withValues(alpha: 0.89),
              backgroundColor: context.isDarkMode ? Color.fromARGB(255, 52, 33, 79) : Color(0xFFDBF3FF),
              child: Row(
                spacing: ConstantSizing.spaceMedium,
                mainAxisSize: MainAxisSize.min,
                children: [
                  CustomElevatedButton(
                    pixelHeight: btnDimension,
                    pixelWidth: btnDimension,
                    contentPadding: EdgeInsets.all(buttonPadding),
                    backgroundColor: Colors.lightBlueAccent.withAlpha(25),
                    onClick: onTapLeading,
                    child: leadingIcon,
                  ),
                  Expanded(
                    child: Column(
                      mainAxisSize: MainAxisSize.min,
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        CustomText(title, fontWeight: FontWeight.bold),
                        ConstantSizing.columnSpacing(4),
                        CustomText(subtitle, fontSize: 12, color: Colors.grey),
                      ],
                    ),
                  ),

                  CustomElevatedButton(
                    shape: CircleBorder(),
                    contentPadding: EdgeInsets.all(buttonPadding),
                    onClick: () {
                      if (onTapTrailing != null) onTapTrailing!();
                    },
                    backgroundColor: Colors.lightBlueAccent.withAlpha(20),
                    child: trailingIcon,
                  ),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}
