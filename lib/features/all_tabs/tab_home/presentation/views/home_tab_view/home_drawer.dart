import 'dart:ui';

import 'package:custom_widgets_toolkit/custom_widgets_toolkit.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:iconsax_flutter/iconsax_flutter.dart';
import 'package:slides_sync/core/routes/app_route_navigator.dart';
import 'package:slides_sync/features/auth/domain/usecases/auth_uc/user_data_functions.dart';
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
        backgroundColor: theme.background,
        child: SingleChildScrollView(
          child: Column(
            children: [
              ConstantSizing.columnSpacing(kToolbarHeight + 24),
              CircleAvatar(
                radius: 40,
                backgroundColor: theme.altBackgroundPrimary,
                child: Icon(Iconsax.user, color: theme.supportingText),
              ),
              ConstantSizing.columnSpacingMedium,
              FutureBuilder(
                future: UserDataFunctions().getUserDetails(),
                builder: (context, asyncSnapshot) {
                  if (asyncSnapshot.hasData && asyncSnapshot.data != null && asyncSnapshot.data?.data != null) {
                    return Column(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        CustomText(asyncSnapshot.data!.data!.displayName, color: theme.onBackground),
                        ConstantSizing.columnSpacingSmall,
                        CustomText(asyncSnapshot.data!.data!.email, color: theme.supportingText.withValues(alpha: 0.6)),
                      ],
                    );
                  }
                  return Column(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      CustomText("Username", color: theme.onBackground),
                      ConstantSizing.columnSpacingSmall,
                      CustomText("Email", color: theme.onBackground),
                    ],
                  );
                },
              ),

              ConstantSizing.columnSpacingExtraLarge,

              ListTile(
                tileColor: Colors.transparent,
                leading: Icon(Iconsax.profile_tick, color: theme.supportingText.withValues(alpha: 0.5)),
                title: CustomText("Profile", color: theme.onBackground),
              ),
              ListTile(
                tileColor: Colors.transparent,
                leading: Icon(Iconsax.setting, color: theme.supportingText.withValues(alpha: 0.5)),
                title: CustomText("Settings", color: theme.onBackground),
                onTap: () {
                  AppRouteNavigator.to(context).settingsRoute();
                },
              ),
              ListTile(
                tileColor: Colors.transparent,
                leading: Icon(Iconsax.pen_tool, color: theme.supportingText.withValues(alpha: 0.5)),
                title: CustomText("Tools", color: theme.onBackground),
                onTap: () {
                  // Tools like Calculate gpa, Reading Metrics etc
                },
              ),
              
            ],
          ),
        ),
      ),
    );
  }
}
