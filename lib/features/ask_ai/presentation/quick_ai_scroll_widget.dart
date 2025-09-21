
import 'package:custom_widgets_toolkit/custom_widgets_toolkit.dart';
import 'package:flutter/material.dart';
import 'package:flutter_animate/flutter_animate.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:iconsax_flutter/iconsax_flutter.dart';
import 'package:slides_sync/shared/helpers/extension_helper.dart';

class QuickAiScrollWidget extends StatelessWidget {
  const QuickAiScrollWidget({super.key});

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      height: 44,
      child: ListView(
        padding: EdgeInsets.only(left: 24.0),
        scrollDirection: Axis.horizontal,
        children: [
          QuickAiScrollButton(label: "Summarize", iconData: Icons.lightbulb_outlined),
          ConstantSizing.rowSpacingMedium,
          QuickAiScrollButton(label: "Explain", iconData: Iconsax.flash_copy),
          ConstantSizing.rowSpacingMedium,
          QuickAiScrollButton(label: "Send documents", iconData: Iconsax.document_copy),
          ConstantSizing.rowSpacingMedium
        ],
      ).animate().moveX(begin: 40, end: 0),
    );
  }
}

class QuickAiScrollButton extends ConsumerWidget {
  final String label;
  final IconData iconData;
  const QuickAiScrollButton({super.key, required this.label, required this.iconData});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final theme = ref.theme;
    return CustomElevatedButton(
      contentPadding: EdgeInsets.symmetric(horizontal: 12.0, vertical: 8.0),
      backgroundColor: theme.altBackgroundPrimary,
      borderRadius: 16,
      child: Row(mainAxisSize: MainAxisSize.min, spacing: 4.0, children: [Icon(iconData, color: theme.onBackground,), CustomText(label, color: theme.onBackground,)]),
    );
  }
}
