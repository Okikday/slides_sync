import 'package:custom_widgets_toolkit/custom_widgets_toolkit.dart';
import 'package:flutter/material.dart';
import 'package:iconsax_flutter/iconsax_flutter.dart';
import 'package:slides_sync/app/models/app_ui_model.dart';


class ContentsSectionHeader extends StatelessWidget {
  const ContentsSectionHeader({
    super.key,
    required this.scaffoldBgColor,
    required this.appUiModel,
  });

  final Color scaffoldBgColor;
  final AppUiModel appUiModel;

  @override
  Widget build(BuildContext context) {
    return PinnedHeaderSliver(
      child: ColoredBox(
        color: scaffoldBgColor,
        child: Row(
          children: [
            Expanded(child: CustomText("Contents", fontSize: 18, fontWeight: FontWeight.bold)),

            CustomElevatedButton(
              backgroundColor: Colors.transparent,
              shape: CircleBorder(),
              child: Icon(Iconsax.add_circle_copy),
            ),

            CustomElevatedButton(
              contentPadding: EdgeInsets.all(8),
              backgroundColor: Colors.lightBlueAccent.withAlpha(40),
              shape: CircleBorder(),
              child: Icon(Iconsax.arrow_up_copy, size: 20, color: appUiModel.isDarkMode ? Colors.white : Colors.black),
            ),
          ],
        ),
      ),
    );
  }
}