import 'dart:ui';

import 'package:custom_widgets_toolkit/custom_widgets_toolkit.dart';
import 'package:flutter/material.dart';
import 'package:flutter_animate/flutter_animate.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:slides_sync/shared/helpers/extension_helper.dart';

class LoadingOverlay extends ConsumerWidget {
  final double? progress;
  final String? message;
  const LoadingOverlay({super.key, this.progress, this.message});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final loadingCard = ClipRSuperellipse(
      borderRadius: BorderRadius.circular(44),
      clipBehavior: Clip.hardEdge,
      child: SizedBox(
        // width: 120,
        height: 44,
        child: BackdropFilter(
          filter: ImageFilter.blur(sigmaX: 4, sigmaY: 4),
          child: Container(
            decoration: BoxDecoration(color: Colors.white12),
            padding: EdgeInsets.symmetric(horizontal: 12, vertical: 4),
            child: Row(
              mainAxisSize: MainAxisSize.min,
              spacing: 12,
              children: [
                CustomText(
                  message ?? "Loading",
                  fontSize: 10,
                  fontWeight: FontWeight.bold,
                  color: ref.theme.primaryText,
                ),
                SizedBox.square(
                  dimension: 14,
                  child: CircularProgressIndicator(
                    strokeCap: StrokeCap.round,
                    color: ref.theme.primaryColor,
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
    return Material(
      type: MaterialType.transparency,
      child: Stack(
        children: [
          Positioned(
            top: context.topPadding + kToolbarHeight + 20,
            left: 16,
            child: Draggable(feedback: loadingCard, childWhenDragging: const SizedBox(), child: loadingCard),
          ),
        ],
      ).animate().fadeIn().slideX(begin: -1, curve: CustomCurves.defaultIosSpring, duration: Durations.extralong1),
    );
  }
}
