import 'package:custom_widgets_toolkit/custom_widgets_toolkit.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:iconsax_flutter/iconsax_flutter.dart';
import 'package:slides_sync/core/models/app_ui_model.dart';

class AllCoursesHeader extends ConsumerWidget {
  final AppUiModel appUiModel;
  final void Function() onTap;
  final void Function() onTapGridButton;
  final bool isListView;
  const AllCoursesHeader({super.key, required this.appUiModel, required this.onTap, required this.isListView, required this.onTapGridButton});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final Color scaffoldBgColor = Theme.of(context).scaffoldBackgroundColor;
    return PinnedHeaderSliver(
      child: ColoredBox(
        // color: Colors.lightBlueAccent.withAlpha(100),
        color: scaffoldBgColor,
        child: Padding(
            padding: const EdgeInsets.symmetric(horizontal: 18, vertical: 4),
            child: GestureDetector(
              onTap: onTap,
              child: Row(
                children: [
                  Expanded(child: CustomText("All Courses", fontSize: 20, fontWeight: FontWeight.bold)),

                  // CustomElevatedButton(backgroundColor: Colors.transparent, shape: CircleBorder(), child: Icon(Iconsax.crop_copy)),

                  CustomElevatedButton(
                    contentPadding: EdgeInsets.all(8),
                    backgroundColor: Colors.lightBlueAccent.withAlpha(40),
                    shape: CircleBorder(),
                    onClick: onTapGridButton,
                    child: Icon(isListView ? Iconsax.menu : Icons.list_rounded, size: 20, color: appUiModel.isDarkMode ? Colors.white : Colors.black),
                  ),
                ],
              ),
            )
        ),
      ),
    );
  }
}
