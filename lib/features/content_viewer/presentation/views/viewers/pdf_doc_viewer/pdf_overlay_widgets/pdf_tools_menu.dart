import 'package:custom_widgets_toolkit/custom_widgets_toolkit.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:iconsax_flutter/iconsax_flutter.dart';
import 'package:slides_sync/features/all_tabs/tab_library/presentation/views/library_tab_view/library_tab_view_app_bar/build_button.dart';
import 'package:slides_sync/shared/helpers/extension_helper.dart';

class PdfToolsMenu extends ConsumerWidget {
  final ValueNotifier<bool> isOptionsVisibleNotifier;
  final bool isVisible;
  const PdfToolsMenu({super.key, required this.isOptionsVisibleNotifier, required this.isVisible});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    return AnimatedContainer(
      duration: Durations.extralong1,
      curve: CustomCurves.defaultIosSpring,
      height: 72,
      padding: EdgeInsets.symmetric(horizontal: 16),
      // constraints: BoxConstraints(maxWidth: context.deviceWidth - 40),
      decoration: BoxDecoration(color: ref.theme.background, borderRadius: BorderRadius.circular(100)),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          ValueListenableBuilder(
            valueListenable: isOptionsVisibleNotifier,
            builder: (context, value, child) {
              return AnimatedSize(
                duration: Durations.extralong1,
                curve: CustomCurves.defaultIosSpring,
                child: SizedBox(
                  width: value ? null : 0,
                  child: ListView(
                    shrinkWrap: true,
                    scrollDirection: Axis.horizontal,
                    children:
                        [
                          BuildButton(onTap: () {}, iconData: Iconsax.setting_copy),
                          BuildButton(onTap: () {}, iconData: Iconsax.edit_copy),
                          BuildButton(onTap: () {}, iconData: Iconsax.magic_star_copy),
                        ].map((e) => Padding(padding: EdgeInsets.only(right: 16), child: e)).toList(),
                  ),
                ),
              );
            },
          ),
          InkWell(
            customBorder: CircleBorder(),
            onTap: () {
              final bool isOptionsVisible = isOptionsVisibleNotifier.value;
              isOptionsVisibleNotifier.value = !isOptionsVisible;
            },
            child: SizedBox(width: 72 - 32, child: Icon(Iconsax.menu_copy)),
          ),
        ],
      ),
    );
  }
}
