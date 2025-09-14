import 'package:custom_widgets_toolkit/custom_widgets_toolkit.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:iconsax_flutter/iconsax_flutter.dart';
import 'package:slides_sync/core/utils/ui_utils.dart';
import 'package:slides_sync/features/settings/presentation/views/sub/settings_appearance_dialog.dart';
import 'package:slides_sync/shared/components/app_bar_container.dart';
import 'package:slides_sync/shared/helpers/extension_helper.dart';

class SettingsView extends ConsumerWidget {
  const SettingsView({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final theme = ref.theme;
    return AnnotatedRegion(
      value: UiUtils.getSystemUiOverlayStyle(Colors.transparent, context.isDarkMode),
      child: Scaffold(
        appBar: AppBarContainer(
          appBarHeight: kToolbarHeight + 12,
          padding: EdgeInsets.zero,
          child: AppBarContainerChild(context.isDarkMode, title: "Settings",),
        ),

        body: Padding(
          padding: const EdgeInsets.fromLTRB(20, 24, 20, 8),
          child: ListView(
            children: [
              CustomText("Appearance", color: theme.supportingText),

              ConstantSizing.columnSpacingMedium,

              SettingsCard(
                title: "App Theme",
                iconData: Iconsax.sun,
                content: "Customize colors to suit your style",
                trailing: CustomElevatedButton(
                  label: "Change",
                  backgroundColor: theme.altBackgroundPrimary,
                  textColor: theme.supportingText,
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

              CustomText("Technical", color: theme.supportingText),

              ConstantSizing.columnSpacingMedium,

              SettingsCard(
                title: "Content not copied",
                iconData: Iconsax.copy,
                content: "Turning this on requires storage permission and reduces storage usage.",
                trailing: Switch(value: false, onChanged: (p) {}),
              ),

              ConstantSizing.columnSpacingMedium,

              SettingsCard(
                title: "Built-in viewer",
                iconData: Iconsax.sun,
                content:
                    "When enabled, materials will open using the app’s built-in viewer instead of an external app.\nDoesn't apply for unsupported files*",
                trailing: Switch(value: false, onChanged: (p) {}),
              ),

              // ConstantSizing.columnSpacingMedium,
            ],
          ),
        ),
      ),
    );
  }
}

class SettingsCard extends ConsumerWidget {
  final String title;
  final IconData iconData;
  final String? content;
  final Widget? trailing;
  const SettingsCard({super.key, required this.title, required this.iconData, this.content, this.trailing});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final theme = ref.theme;
    return Container(
      decoration: BoxDecoration(color: theme.supportingText.withAlpha(10), borderRadius: BorderRadius.circular(24)),
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
                      CustomText(title, color: theme.onBackground),
                      if (content != null)
                        CustomText(
                          content!,
                          fontSize: 11,
                          color: theme.supportingText,
                        ),
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
