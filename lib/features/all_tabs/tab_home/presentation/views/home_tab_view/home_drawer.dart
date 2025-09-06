import 'dart:ui';

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
    final theme = ref.theme;
    return PopScope(
      onPopInvokedWithResult: (didPop, result) {
        Scaffold.of(context).closeDrawer();
      },
      child: Drawer(
        backgroundColor: context.scaffoldBackgroundColor.withAlpha(200),
        child: BackdropFilter(
          filter: ImageFilter.blur(sigmaX: 4, sigmaY: 4),
          child: SingleChildScrollView(
            child: Column(
              children: [
                ConstantSizing.columnSpacing(kToolbarHeight + 24),
                CircleAvatar(
                  radius: 40,
                  backgroundColor: theme.altBackgroundPrimary,
                  child: Icon(Iconsax.user, color: theme.secondaryText),
                ),
                ConstantSizing.columnSpacingMedium,
                CustomText("Username", color: theme.primaryText),
                ConstantSizing.columnSpacingSmall,
                CustomText(
                  "Some description",
                  color: theme.secondaryText.withValues(alpha: 0.6),
                ),

                ConstantSizing.columnSpacingExtraLarge,

                ListTile(
                  leading: Icon(
                    Iconsax.profile_tick,
                    color: theme.secondaryText,
                  ),
                  title: CustomText("Profile", color: theme.primaryText),
                ),
                ListTile(
                  leading: Icon(
                    Iconsax.bookmark,
                    color: theme.secondaryText,
                  ),
                  title: CustomText("Bookmarks", color: theme.primaryText),
                ),
                ListTile(
                  leading: Icon(
                    Iconsax.setting,
                    color: theme.secondaryText,
                  ),
                  title: CustomText("Settings", color: theme.primaryText),
                  onTap: () {
                    AppNavigator.to(context).settingsRoute();
                  },
                ),
                ListTile(
                  leading: Icon(
                    Iconsax.information_copy,
                    color: theme.secondaryText,
                  ),
                  title: CustomText("Help", color: theme.primaryText),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
