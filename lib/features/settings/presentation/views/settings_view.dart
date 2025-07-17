import 'package:custom_widgets_toolkit/custom_widgets_toolkit.dart';
import 'package:flutter/material.dart';
import 'package:flutter_animate/flutter_animate.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:iconsax_flutter/iconsax_flutter.dart';
import 'package:slides_sync/app.dart';
import 'package:slides_sync/core/utils/ui_utils.dart';
import 'package:slides_sync/shared/components/app_bar_container.dart';
import 'package:slides_sync/shared/components/dialogs/app_action_dialog.dart';
import 'package:slides_sync/shared/components/dialogs/app_customizable_dialog.dart';
import 'package:slides_sync/shared/helpers/extension_helper.dart';
import 'package:slides_sync/shared/styles/colors.dart';
import 'package:slides_sync/shared/styles/theme/built_in_themes.dart';
import 'package:slides_sync/shared/styles/theme/themes.dart';

class SettingsView extends ConsumerWidget {
  const SettingsView({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    return AnnotatedRegion(
      value: UiUtils.getSystemUiOverlayStyle(Colors.transparent, context.isDarkMode),
      child: Scaffold(
        appBar: AppBarContainer(
          appBarHeight: kToolbarHeight + 12,
          padding: EdgeInsets.zero,
          child: AppBarContainerChild(context.isDarkMode, title: "Settings"),
        ),

        body: Padding(
          padding: const EdgeInsets.fromLTRB(20, 24, 20, 8),
          child: ListView(
            children: [
              CustomText("Appearance", color: AppColors.altLightGray),

              ConstantSizing.columnSpacingMedium,

              SettingsCard(
                title: "App Theme",
                iconData: Iconsax.sun,
                content: "Customize colors to suit your style",
                trailing: CustomElevatedButton(
                  label: "Change",
                  backgroundColor: context.theme.colorScheme.secondary,
                  textColor: context.isDarkMode ? AppColors.lightGray : Colors.black54,
                  textSize: 14,
                  onClick: () {
                    CustomDialog.show(context, barrierColor: Colors.black26, blurSigma: Offset(2, 2), child: SettingsAppearanceDialog());
                  },
                ),
              ),

              ConstantSizing.columnSpacingMedium,

              SettingsCard(
                title: "Use system brightness",
                iconData: Iconsax.sun_1,
                content: "Switch theme when system brightness changes",
                trailing: Switch(value: false, onChanged: (p) {}),
              ),

              ConstantSizing.columnSpacingLarge,

              CustomText("Technical", color: AppColors.altLightGray),

              ConstantSizing.columnSpacingMedium,

              SettingsCard(
                title: "Content not copied",
                iconData: Iconsax.copy,
                content: "Turning this on requires storage permission and reduces storage usage.",
                trailing: Switch(value: false, onChanged: (p) {}),
              ),

              ConstantSizing.columnSpacingLarge,

              CustomText("Language", color: AppColors.altLightGray),

              ConstantSizing.columnSpacingMedium,

              // ConstantSizing.columnSpacingMedium,
            ],
          ),
        ),
      ),
    );
  }
}

class SettingsCard extends StatelessWidget {
  final String title;
  final IconData iconData;
  final String? content;
  final Widget? trailing;
  const SettingsCard({super.key, required this.title, required this.iconData, this.content, this.trailing});

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(color: context.theme.cardColor, borderRadius: BorderRadius.circular(24)),
      child: Column(
        children: [
          Padding(
            padding: const EdgeInsets.fromLTRB(16, 12, 16, 16),
            child: Row(
              spacing: 8,
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                Icon(iconData),
                Expanded(
                  child: Column(
                    mainAxisSize: MainAxisSize.min,
                    crossAxisAlignment: CrossAxisAlignment.start,
                    spacing: 2,
                    children: [
                      CustomText(title, color: context.theme.colorScheme.tertiary),
                      if (content != null)
                        CustomText(content!, fontSize: 11, color: context.isDarkMode ? AppColors.altLightGray : Colors.black54),
                    ],
                  ),
                ),

                if (trailing != null) trailing!,
              ],
            ),
          ),
        ],
      ),
    );
  }
}

class SettingsAppearanceDialog extends ConsumerWidget {
  const SettingsAppearanceDialog({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    return AppCustomizableDialog(
      blurSigma: Offset(2, 2),
      leading: Center(child: CustomText("Adjust Theme", color: context.theme.colorScheme.tertiary)),
      child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 20),
        child: SizedBox(
          width: context.deviceWidth,
          child: SingleChildScrollView(
            scrollDirection: Axis.horizontal,
            child: SingleChildScrollView(
              scrollDirection: Axis.vertical,
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                mainAxisSize: MainAxisSize.min,
                children: [
                  ConstantSizing.columnSpacingSmall,

                  for (int i = 0; i < defaultAppThemeModels.length ~/ 2; i++)
                    () {
                      final light = defaultAppThemeModels[i * 2];
                      final dark = defaultAppThemeModels[i * 2 + 1];
                      return Padding(
                        padding: const EdgeInsets.all(8.0),
                        child: Row(
                          children: [
                            CustomElevatedButton(
                              label: light.title,
                              backgroundColor: context.theme.cardColor,
                              textColor: context.theme.colorScheme.tertiary,
                              onClick: () {
                                ref.read(appThemeDataProvider.notifier).update(resolveThemeData(light));
                              },
                            ),

                            ConstantSizing.rowSpacing(24),

                            CustomElevatedButton(
                              label: dark.title,
                              backgroundColor: context.theme.cardColor,
                              textColor: context.theme.colorScheme.tertiary,
                              onClick: () {
                                ref.read(appThemeDataProvider.notifier).update(resolveThemeData(dark));
                              },
                            ),
                          ],
                        ),
                      );
                    }(),
                ],
              ),
            ),
          ),
        ),
      ),
    ).animate().flipV(duration: Durations.medium1, curve: CustomCurves.defaultIosSpring);
  }
}
