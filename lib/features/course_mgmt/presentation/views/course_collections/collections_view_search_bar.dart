import 'package:custom_widgets_toolkit/custom_widgets_toolkit.dart';
import 'package:flutter/material.dart';
import 'package:iconsax_flutter/iconsax_flutter.dart';
import 'package:slides_sync/shared/styles/app_ui_context.dart';
import 'package:slides_sync/shared/styles/colors.dart';

class CollectionsViewSearchBar extends StatelessWidget {
  const CollectionsViewSearchBar({super.key});

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 16.0),
      child: Row(
        spacing: 12.0,
        children: [
          Expanded(
            child: ClipRSuperellipse(
              borderRadius: BorderRadius.circular(10.0),
              child: CustomTextfield(
                hint: "Search Collections",
                inputTextStyle: TextStyle(fontSize: 15),
                backgroundColor: context.isDarkMode ? SlidesRepoColors.darkBlue : Colors.black,
                border: OutlineInputBorder(borderSide: BorderSide.none, borderRadius: BorderRadius.zero),
                prefixIcon: Padding(
                  padding: const EdgeInsets.only(left: 12.0, right: 10.0, top: 12.0, bottom: 12.0),
                  child: Icon(Iconsax.search_normal_copy, size: 20, color: context.isDarkMode ? Colors.white : Colors.white),
                ),
              ),
            ),
          ),

          CustomElevatedButton(
            pixelHeight: 48,
            shape: CircleBorder(),
            backgroundColor: Colors.lightBlueAccent.withAlpha(40),
            child: Icon(Iconsax.filter_copy, size: 20),
          ),
        ],
      ),
    );
  }
}
