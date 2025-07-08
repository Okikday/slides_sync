import 'package:custom_widgets_toolkit/custom_widgets_toolkit.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:iconsax_flutter/iconsax_flutter.dart';
import 'package:slides_sync/core/utils/ui_utils.dart';
import 'package:slides_sync/shared/components/app_bar_container.dart';
import 'package:slides_sync/shared/helpers/extension_helper.dart';
import 'package:slides_sync/shared/styles/colors.dart';

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

              Container(
                decoration: BoxDecoration(
                  color: context.isDarkMode ? AppColors.arsenic : AppColors.altLightGray,
                  borderRadius: BorderRadius.circular(24),
                ),
                child: Column(
                  children: [
                    Padding(
                      padding: const EdgeInsets.fromLTRB(16, 12, 16, 16),
                      child: Row(
                        spacing: 8,
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        crossAxisAlignment: CrossAxisAlignment.center,
                        children: [
                          Icon(Iconsax.sun),
                          Column(
                            mainAxisSize: MainAxisSize.min,
                            crossAxisAlignment: CrossAxisAlignment.start,
                            spacing: 2,
                            children: [
                              CustomText("App Theme"),
                              CustomText(
                                "Customize colors to suit your style",
                                fontSize: 11,
                                color: context.isDarkMode ? AppColors.altLightGray : Colors.black54,
                              ),
                            ],
                          ),

                          CustomElevatedButton(
                            label: "Change",
                            backgroundColor: AppColors.battleshipGrey.withValues(alpha: 0.3),
                            textColor: context.isDarkMode ? AppColors.lightGray : Colors.black54,
                            textSize: 14,
                            onClick: () {
                              UiUtils.showFlushBar(context, msg: "Couldn't start theme engine");
                            },
                          ),
                        ],
                      ),
                    ),
                  ],
                ),
              ),

              ConstantSizing.columnSpacingLarge,

              CustomText("Language", color: AppColors.altLightGray),

              ConstantSizing.columnSpacingMedium,
            ],
          ),
        ),
      ),
    );
  }
}
