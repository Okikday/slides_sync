import 'package:custom_widgets_toolkit/custom_widgets_toolkit.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:iconsax_flutter/iconsax_flutter.dart';
import 'package:slides_sync/features/ask_ai/presentation/ask_ai_screen.dart';
import 'package:slides_sync/shared/common_widgets/scale_click_wrapper.dart';
import 'package:slides_sync/shared/helpers/extension_helper.dart';

class PdfToolsMenu extends ConsumerWidget {
  final bool isVisible;
  const PdfToolsMenu({super.key, required this.isVisible});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final theme = ref.theme;
    return ScaleClickWrapper(
      borderRadius: 100,
      onTap: () {
        Navigator.push(
          context,
          PageAnimation.pageRouteBuilder(
            AskAiScreen(),
            type: TransitionType.none,
            reverseDuration: Durations.short1,
            opaque: false,
            barrierColor: theme.background.withAlpha(180),
          ),
        );
      },
      child: DecoratedBox(
        decoration: BoxDecoration(
          shape: BoxShape.circle,
          boxShadow: [
            BoxShadow(
              offset: Offset(-3, -3),
              color: theme.onPrimary.withValues(alpha: 0.7),
              blurStyle: BlurStyle.normal,
              blurRadius: 50,
            ),
          ],
          gradient: RadialGradient(colors: [theme.primary, theme.onPrimary]),
        ),
        child: Padding(
          padding: const EdgeInsets.all(24.0),
          child: Icon(Iconsax.magic_star, size: 20, color: theme.supportingText),
        ),
      ),
    );
    ;
  }
}
