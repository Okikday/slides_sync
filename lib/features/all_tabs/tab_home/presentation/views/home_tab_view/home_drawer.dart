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
                  backgroundColor: context.theme.colorScheme.onSurface,
                  child: Icon(Iconsax.user, color: ref.theme.secondaryText),
                ),
                ConstantSizing.columnSpacingMedium,
                CustomText("Username", color: ref.theme.primaryText),
                ConstantSizing.columnSpacingSmall,
                CustomText(
                  "Some description",
                  color: ref.theme.secondaryText.withValues(alpha: 0.6),
                ),

                ConstantSizing.columnSpacingExtraLarge,

                ListTile(
                  leading: Icon(
                    Iconsax.profile_tick,
                    color: ref.theme.secondaryText,
                  ),
                  title: CustomText("Profile", color: ref.theme.primaryText),
                ),
                ListTile(
                  leading: Icon(
                    Iconsax.bookmark,
                    color: ref.theme.secondaryText,
                  ),
                  title: CustomText("Bookmarks", color: ref.theme.primaryText),
                ),
                ListTile(
                  leading: Icon(
                    Iconsax.setting,
                    color: ref.theme.secondaryText,
                  ),
                  title: CustomText("Settings", color: ref.theme.primaryText),
                  onTap: () {
                    AppNavigator.to(context).settingsRoute();
                  },
                ),
                ListTile(
                  leading: Icon(
                    Iconsax.information_copy,
                    color: ref.theme.secondaryText,
                  ),
                  title: CustomText("Help", color: ref.theme.primaryText),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
