import 'package:custom_widgets_toolkit/custom_widgets_toolkit.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:iconsax_flutter/iconsax_flutter.dart';
import 'package:slides_sync/core/utils/app_navigator.dart';
import 'package:slides_sync/shared/helpers/extension_helper.dart';

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
            CircleAvatar(radius: 40, backgroundColor: context.theme.colorScheme.onSurface, child: Icon(Iconsax.user, color: context.theme.colorScheme.onTertiary,),),
            ConstantSizing.columnSpacingMedium,
            CustomText("Username", color: context.theme.colorScheme.tertiary,),
            ConstantSizing.columnSpacingSmall,
            CustomText("Some description", color: context.theme.colorScheme.onTertiary.withValues(alpha: 0.6),),

            ConstantSizing.columnSpacingExtraLarge,

            ListTile(leading: Icon(Iconsax.profile_tick, color: context.theme.colorScheme.onTertiary,), title: CustomText("Profile", color: context.theme.colorScheme.tertiary)),
            ListTile(leading: Icon(Iconsax.bookmark, color: context.theme.colorScheme.onTertiary,), title: CustomText("Bookmarks", color: context.theme.colorScheme.tertiary)),
            ListTile(
              leading: Icon(Iconsax.setting, color: context.theme.colorScheme.onTertiary,),
              title: CustomText("Settings", color: context.theme.colorScheme.tertiary),
              onTap: () {
                AppNavigator.to(context).settingsRoute();
              },
            ),
            ListTile(leading: Icon(Iconsax.information_copy, color: context.theme.colorScheme.onTertiary,), title: CustomText("Help", color: context.theme.colorScheme.tertiary)),
          ],
        ),
      ),
    );
  }
}
