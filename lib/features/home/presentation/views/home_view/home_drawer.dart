import 'package:custom_widgets_toolkit/custom_widgets_toolkit.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:iconsax_flutter/iconsax_flutter.dart';
import 'package:slides_sync/shared/styles/app_ui_context.dart';

class HomeDrawer extends ConsumerWidget {
  const HomeDrawer({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    return Drawer(
      backgroundColor: context.scaffoldBackgroundColor,
      child: SingleChildScrollView(
        child: Column(
          children: [
            ConstantSizing.columnSpacing(kToolbarHeight + 24),
            CircleAvatar(radius: 40,),
            ConstantSizing.columnSpacingSmall,
            CustomText("Username"),
            ConstantSizing.columnSpacingSmall,
            CustomText("Add description", color: Colors.grey,),
        
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
