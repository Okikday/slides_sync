import 'package:custom_widgets_toolkit/custom_widgets_toolkit.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:slides_sync/shared/helpers/extension_helper.dart';

class ScaleClickWrapper extends ConsumerStatefulWidget {
  final double borderRadius;
  // default size, and then when clicked
  final (double from, double to) scaleBetween;
  final void Function(TapDownDetails details)? onTapDown;

  /// Can delay when calling onTapUp to delay when action takes place
  final void Function(TapUpDetails details)? onTapUp;
  final VoidCallback? onTap;
  final VoidCallback? onLongPress;
  final Duration animationDuration;
  final Duration? delayReverseDuration;
  final Curve? curve;
  final Widget child;
  const ScaleClickWrapper({
    super.key,
    this.scaleBetween = (1.0, 0.9),
    this.onTapDown,
    this.onTapUp,
    this.onTap,
    this.onLongPress,
    this.animationDuration = Durations.medium2,
    this.delayReverseDuration,
    this.borderRadius = 0,
    this.curve,
    required this.child,
  });

  @override
  ConsumerState<ScaleClickWrapper> createState() => _ScaleClickWrapperState();
}

class _ScaleClickWrapperState extends ConsumerState<ScaleClickWrapper> {
  late final ValueNotifier<bool> scaleClickNotifier;
  @override
  void initState() {
    super.initState();
    scaleClickNotifier = ValueNotifier(false);
  }

  @override
  void dispose() {
    scaleClickNotifier.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return ValueListenableBuilder(
      valueListenable: scaleClickNotifier,
      builder: (context, value, child) {
        return AnimatedScale(
          scale: value ? widget.scaleBetween.$2 : widget.scaleBetween.$1,
          duration: widget.animationDuration,
          curve: widget.curve ?? CustomCurves.defaultIosSpring,
          child: InnerScaleClickWrapper(
            scaleClickNotifier: scaleClickNotifier,
            borderRadius: widget.borderRadius,
            onTapDown: widget.onTapDown,
            onTapUp: widget.onTapUp,
            onTap: widget.onTap,
            onLongPress: widget.onLongPress,
            child: widget.child,
          ),
        );
      },
    );
  }
}

class InnerScaleClickWrapper extends ConsumerWidget {
  const InnerScaleClickWrapper({
    super.key,
    required this.scaleClickNotifier,
    this.borderRadius = 0,
    this.onTapDown,
    this.onTapUp,
    this.onTap,
    this.onLongPress,
    this.delayReverseDuration,
    required this.child,
  });

  final ValueNotifier<bool> scaleClickNotifier;
  final double borderRadius;
  final void Function(TapDownDetails details)? onTapDown;
  final void Function(TapUpDetails details)? onTapUp;
  final VoidCallback? onTap;
  final VoidCallback? onLongPress;
  final Duration? delayReverseDuration;
  final Widget child;

  void updateScaleClickNotifier(bool newValue) {
    if (scaleClickNotifier.value == newValue) return;
    scaleClickNotifier.value = newValue;
  }

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final theme = ref.theme;

    return Material(
      type: MaterialType.transparency,
      child: InkWell(
        borderRadius: BorderRadius.circular(borderRadius),
        overlayColor: WidgetStatePropertyAll(theme.altBackgroundPrimary),
        splashColor: theme.altBackgroundPrimary,
        onTapDown: (details) {
          updateScaleClickNotifier(true);
          if (onTapDown != null) onTapDown!(details);
        },
        onTapCancel: () {
          updateScaleClickNotifier(false);
        },
        onTapUp: (details) async {
          await Future.delayed(delayReverseDuration ?? Durations.short1);
          updateScaleClickNotifier(false);
          if (onTapUp != null) onTapUp!(details);
        },
        onTap: onTap,
        onLongPress: onLongPress,
        child: child,
      ),
    );
  }
}
