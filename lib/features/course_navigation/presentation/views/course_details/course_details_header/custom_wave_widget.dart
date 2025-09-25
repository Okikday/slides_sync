import 'dart:math' as math;

import 'package:custom_widgets_toolkit/custom_widgets_toolkit.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:slides_sync/shared/helpers/extension_helper.dart';
import 'package:wave/config.dart';
import 'package:wave/wave.dart';

class CustomShapeWaveFilledWidget extends ConsumerWidget {
  final double progress;
  final Widget? backgroundWidget;
  final TextStyle? textStyle;
  final Size waveSize;
  final bool showProgress;
  final Color? waveColor;
  const CustomShapeWaveFilledWidget({
    super.key,
    required this.progress,
    required this.waveSize,
    this.backgroundWidget,
    this.textStyle,
    this.showProgress = true,
    this.waveColor,
  });

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final theme = ref.theme;
    return Stack(
      children: [
        Positioned(
          width: waveSize.width,
          height: waveSize.height,
          child: Wave(
            value: progress.clamp(0.2, 1.0),
            color: waveColor ?? theme.primaryColor.withAlpha(40),
            direction: Axis.vertical,
          ),
        ),
        // CustomWaveWidget(progress: progress.clamp(0.4, 1.0)),
        if (backgroundWidget != null) Positioned.fill(child: backgroundWidget!),
        if (showProgress)
          Positioned.fill(
            child: Align(
              alignment: Alignment.center,
              child: CustomText(
                "${(progress >= 0.0 && progress <= 1.0) ? (progress * 100.0).truncate() : 0}%",
                fontWeight: FontWeight.bold,
                textAlign: TextAlign.center,
                style: textStyle,
              ),
            ),
          ),
      ],
    );
  }
}

class CustomWaveWidget extends ConsumerWidget {
  final double progress;
  final Color? backgroundColor;
  const CustomWaveWidget({super.key, required this.progress, this.backgroundColor});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final theme = ref.theme;
    final double fill;
    if (progress < 0.0 || progress > 1.0) {
      fill = 0.0;
    } else {
      fill = 1.0 - progress;
    }
    return WaveWidget(
      config: CustomConfig(
        colors: [theme.primaryColor.withAlpha(50), theme.primaryColor.withAlpha(80), theme.primaryColor.withAlpha(30)],
        durations: [5000, 4000, 3000],
        heightPercentages: [fill - 0.01, fill + 0.01, fill + 0.05],
      ),
      backgroundColor: backgroundColor ?? theme.primaryColor.withAlpha(40),
      size: Size(double.infinity, double.infinity),
      waveAmplitude: 10,
    );
  }
}

class Wave extends StatefulWidget {
  final double? value;
  final Color color;
  final Axis direction;

  const Wave({super.key, required this.value, required this.color, required this.direction});

  @override
  State<Wave> createState() => _WaveState();
}

class _WaveState extends State<Wave> with SingleTickerProviderStateMixin {
  late AnimationController _animationController;

  @override
  void initState() {
    super.initState();

    _animationController = AnimationController(vsync: this, duration: Duration(seconds: 2));
    _animationController.repeat();
  }

  @override
  void dispose() {
    _animationController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return AnimatedBuilder(
      animation: CurvedAnimation(parent: _animationController, curve: Curves.easeInOut),
      child: Container(color: widget.color),
      builder: (context, child) => ClipPath(
        clipper: _WaveClipper(
          animationValue: _animationController.value,
          value: widget.value,
          direction: widget.direction,
        ),
      ),
    );
  }
}

class _WaveClipper extends CustomClipper<Path> {
  final double animationValue;
  final double? value;
  final Axis direction;

  _WaveClipper({required this.animationValue, required this.value, required this.direction});

  @override
  Path getClip(Size size) {
    if (direction == Axis.horizontal) {
      Path path = Path()
        ..addPolygon(_generateHorizontalWavePath(size), false)
        ..lineTo(0.0, size.height)
        ..lineTo(0.0, 0.0)
        ..close();
      return path;
    }

    Path path = Path()
      ..addPolygon(_generateVerticalWavePath(size), false)
      ..lineTo(size.width, size.height)
      ..lineTo(0.0, size.height)
      ..close();
    return path;
  }

  List<Offset> _generateHorizontalWavePath(Size size) {
    final waveList = <Offset>[];
    for (int i = -2; i <= size.height.toInt() + 2; i++) {
      final waveHeight = (size.width / 20);
      final dx = math.sin((animationValue * 360 - i) % 360 * (math.pi / 180)) * waveHeight + (size.width * value!);
      waveList.add(Offset(dx, i.toDouble()));
    }
    return waveList;
  }

  List<Offset> _generateVerticalWavePath(Size size) {
    final waveList = <Offset>[];
    for (int i = -2; i <= size.width.toInt() + 2; i++) {
      final waveHeight = (size.height / 20);
      final dy =
          math.sin((animationValue * 360 - i) % 360 * (math.pi / 180)) * waveHeight +
          (size.height - (size.height * value!));
      waveList.add(Offset(i.toDouble(), dy));
    }
    return waveList;
  }

  @override
  bool shouldReclip(_WaveClipper oldClipper) => animationValue != oldClipper.animationValue;
}
