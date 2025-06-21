import 'package:custom_widgets_toolkit/custom_widgets_toolkit.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:slides_sync/core/utils/util_functions.dart';
import 'package:slides_sync/shared/helpers/extension_helper.dart';

class LibraryTabViewHeaderText extends ConsumerWidget {
  const LibraryTabViewHeaderText({super.key, required this.minHeight, required this.maxHeight, required this.scrollOffsetProvider});

  final double minHeight;
  final double maxHeight;
  final StateProvider<double> scrollOffsetProvider;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final scrollOffset = ref.watch(scrollOffsetProvider);
    final double percentScroll = 1.0 - scrollOffset / (maxHeight - minHeight);
    final CustomText textWidget = CustomText(
      "All Courses",
      fontSize: (50 * percentScroll).clamp(20.0, 26),
      fontWeight: FontWeight.bold,
      textAlign: TextAlign.center,
    );
    final Size textSize = UtilFunctions.getTextSize(textWidget.data, textWidget.effectiveStyle(context));

    final double leftPad = (double.parse((context.deviceWidth / 2 - textSize.width / 2).toStringAsFixed(2)) * percentScroll).clamp(
      24.0,
      double.infinity,
    );
    final double bottomPad = (double.parse((maxHeight / 2 - textSize.height / 2).toStringAsFixed(2)) * percentScroll).clamp(
      12.0,
      double.infinity,
    );
    return Positioned(
      // left: 24,
      // bottom: 12,
      bottom: bottomPad,
      left: leftPad,
      child: textWidget,
    );
  }
}
