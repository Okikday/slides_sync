
import 'package:custom_widgets_toolkit/custom_widgets_toolkit.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:slides_sync/shared/styles/app_ui_context.dart';

class AskFileOrCameraDialog extends ConsumerWidget {
  final String title;
  final List<Widget> actions;
  final Color? backgroundColor;
  const AskFileOrCameraDialog({super.key, this.title = "Select Image from", this.actions = const [], this.backgroundColor});

  @override
  Widget build(BuildContext context, WidgetRef ref) {

    return Stack(
      alignment: Alignment.center,
      children: [
        Positioned.fill(child: GestureDetector(onTap: () => LoadingDialog.hideLoadingDialog(context))),
        Positioned(
          left: 24,
          right: 24,
          child: Align(
            alignment: Alignment.center,
            child: Container(
              clipBehavior: Clip.hardEdge,
              decoration: BoxDecoration(
                color: context.scaffoldBackgroundColor.withValues(alpha: 0.9),
                borderRadius: BorderRadius.circular(16.0),
                border: Border.all(width: 1, color: Colors.lightBlueAccent.withAlpha(25)),
                boxShadow: [
                  BoxShadow(
                    color: backgroundColor ?? (context.isDarkMode ? Colors.lightBlueAccent.withAlpha(25) : Colors.black.withAlpha(20)),
                    blurRadius: 8,
                    offset: Offset(0, 0),
                    blurStyle: BlurStyle.inner,
                    spreadRadius: 2,
                  ),
                ],
              ),
              padding: EdgeInsets.symmetric(vertical: 16, horizontal: 12),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  ConstantSizing.columnSpacingSmall,
                  Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 8),
                    child: Center(child: CustomText(title, fontWeight: FontWeight.bold, fontSize: 18, textAlign: TextAlign.center)),
                  ),
                  ConstantSizing.columnSpacingSmall,
                  Divider(color: context.isDarkMode ? Colors.lightBlue.withAlpha(40) : Colors.grey.withAlpha(40)),

                ],
              ),
            ),
          ),
        ),
      ],
    );
  }
}
