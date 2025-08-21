import 'package:custom_widgets_toolkit/custom_widgets_toolkit.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:iconsax_flutter/iconsax_flutter.dart';
import 'package:slides_sync/shared/assets/assets.dart';
import 'package:slides_sync/shared/helpers/extension_helper.dart';

class MoreSection extends ConsumerWidget {
  const MoreSection({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    return Container(
      padding: EdgeInsets.symmetric(horizontal: 0, vertical: 2),
      margin: EdgeInsets.symmetric(horizontal: 10),
      decoration: BoxDecoration(
        color: ref.theme.altBackgroundPrimary.withValues(alpha: 0.4),
        borderRadius: BorderRadius.circular(24),
        image: DecorationImage(
          image: Assets.images.zigzagWavy.asImageProvider,
          fit: BoxFit.cover,
          opacity: 0.01,
          colorFilter: ColorFilter.mode(
            ref.theme.primaryColor,
            BlendMode.srcIn,
          ),
        ),
      ),
      child: ConstrainedBox(
        constraints: BoxConstraints(minHeight: 50, maxHeight: 100),
        child: ListView(
          scrollDirection: Axis.horizontal,
          padding: EdgeInsets.zero,
          children: [
            Padding(
              padding: const EdgeInsets.only(left: 20.0, right: 12.0),
              child: MoreSectionOption(title: "Favorites", iconData: Iconsax.heart_copy),
            ),

            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 12.0),
              child: MoreSectionOption(title: "Bookmarks", iconData: Iconsax.menu_copy),
            ),

            Padding(padding: const EdgeInsets.symmetric(horizontal: 12.0), child: MoreSectionOption(title: "", iconData: Iconsax.add_copy)),
          ],
        ),
      ),
    );
  }
}

class MoreSectionOption extends ConsumerWidget {
  final String title;
  final IconData iconData;
  const MoreSectionOption({super.key, required this.title, required this.iconData});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    return Column(
      mainAxisAlignment: MainAxisAlignment.center,
      spacing: 6.0,
      children: [
        CustomElevatedButton(
          pixelHeight: 48,
          pixelWidth: 48,
          // contentPadding: EdgeInsets.all(0),
          shape: const CircleBorder(),
          backgroundColor: ref.theme.background,
          child: Icon(iconData, color: ref.theme.secondaryText)
        ),
        CustomText(title, color: ref.theme.secondaryText, fontSize: 12),
      ],
    );
  }
}
