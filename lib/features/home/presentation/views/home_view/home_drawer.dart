import 'package:custom_widgets_toolkit/custom_widgets_toolkit.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:iconsax_flutter/iconsax_flutter.dart';
import 'package:slides_sync/core/models/app_ui_model.dart';

class HomeDrawer extends ConsumerWidget {
  final AppUiModel appUiModel;
  final Color scaffoldBgColor;
  const HomeDrawer({super.key, required this.appUiModel, required this.scaffoldBgColor});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    return Drawer(
      backgroundColor: scaffoldBgColor,
      child: SingleChildScrollView(
        child: Column(
          children: [
            ConstantSizing.columnSpacing(kToolbarHeight + 24),
            CircleAvatar(radius: 40,),
            ConstantSizing.columnSpacingSmall,
            CustomText("Username"),
            ConstantSizing.columnSpacingSmall,
            CustomText("200 Level - 2nd Semester", color: Colors.grey,),
        
            ConstantSizing.columnSpacingExtraLarge,
        
            ListTile(leading: Icon(Iconsax.profile_tick), title: CustomText("Profile"),),
            ListTile(leading: Icon(Iconsax.bookmark), title: CustomText("Bookmarks"),),
            ListTile(leading: Icon(Iconsax.setting), title: CustomText("Settings"),),
            ListTile(leading: Icon(Iconsax.information_copy), title: CustomText("Help"),)
        
          ],
        ),
      ),
    );
  }
}
