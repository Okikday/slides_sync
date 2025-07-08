import 'package:custom_widgets_toolkit/custom_widgets_toolkit.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:iconsax_flutter/iconsax_flutter.dart';
import 'package:slides_sync/core/utils/app_navigator.dart';
import 'package:slides_sync/shared/helpers/extension_helper.dart';
import 'package:slides_sync/shared/styles/colors.dart';

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
            CircleAvatar(radius: 40, backgroundColor: AppColors.arsenic, child: Icon(Iconsax.user, color: Colors.white30,),),
            ConstantSizing.columnSpacingMedium,
            CustomText("Username", color: Colors.white,),
            ConstantSizing.columnSpacingSmall,
            CustomText("Some description", color: Colors.grey),

            ConstantSizing.columnSpacingExtraLarge,

            ListTile(leading: Icon(Iconsax.profile_tick), title: CustomText("Profile", color: Colors.white)),
            ListTile(leading: Icon(Iconsax.bookmark), title: CustomText("Bookmarks", color: Colors.white)),
            ListTile(
              leading: Icon(Iconsax.setting),
              title: CustomText("Settings", color: Colors.white),
              onTap: () {
                AppNavigator.to(context).settingsRoute();
              },
            ),
            ListTile(leading: Icon(Iconsax.information_copy), title: CustomText("Help", color: Colors.white)),
          ],
        ),
      ),
    );
  }
}
