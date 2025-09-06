import 'dart:ui';
import 'package:custom_widgets_toolkit/custom_widgets_toolkit.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:slides_sync/features/auth/presentation/welcome_view/welcome_view.dart';
import 'package:slides_sync/shared/helpers/extension_helper.dart';

class ScaleClickWrapper extends ConsumerStatefulWidget {
  final VoidCallback onTap;
  final double borderRadius;
  final Widget child;
  const ScaleClickWrapper({super.key, required this.onTap, this.borderRadius = 0, required this.child});

  @override
  ConsumerState<ScaleClickWrapper> createState() => _ScaleClickWrapperState();
}
class _ScaleClickWrapperState extends ConsumerState<ScaleClickWrapper> {
  late final AutoDisposeStateProvider<bool> scaleClickProvider;
  @override
  void initState() {
    super.initState();
    scaleClickProvider = AutoDisposeStateProvider((cb) => false);
  }

  @override
  Widget build(BuildContext context) {
    final theme = ref.theme;
    updateScaleClickProvider(bool newValue) => ref.read(scaleClickProvider.notifier).update((cb) => newValue);
    return AnimatedScale(
      scale: ref.watch(scaleClickProvider) ? 0.9 : 1.0,
      duration: Durations.medium2,
      curve: CustomCurves.defaultIosSpring,
      child: Material(
        type: MaterialType.transparency,
        child: InkWell(
          borderRadius: BorderRadius.circular(widget.borderRadius),
          overlayColor: WidgetStatePropertyAll(theme.altBackgroundPrimary),
          splashColor: theme.altBackgroundPrimary,
          onTapDown: (details) {
            updateScaleClickProvider(true);
          },
          onTapCancel: () {
            updateScaleClickProvider(false);
          },
          onTapUp: (details) async {
            await Future.delayed(Durations.short1);
            updateScaleClickProvider(false);
          },
          onTap: () async {
            await Future.delayed(Durations.short4);
            widget.onTap();
          },
          child: widget.child,
        ),
      ),
    );
  }
}
