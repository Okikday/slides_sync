import 'package:custom_widgets_toolkit/custom_widgets_toolkit.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:wave/config.dart';
import 'package:wave/wave.dart';

class StarWaveFilledProgressWidget extends ConsumerWidget {
  final double progress;
  final double width;
  final double height;
  const StarWaveFilledProgressWidget({super.key, required this.progress, this.width = 100, this.height = 100});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final double fill;
    if (progress < 0.0 || progress > 1.0) {
      fill = 0.0;
    } else {
      fill = 1.0 - progress;
    }
    return SizedBox(
      width: width,
      height: height,
      child: Stack(
        clipBehavior: Clip.hardEdge,
        children: [
          ClipPath(
            clipper: StarClipper(StarBorder(points: 4, pointRounding: 0.7, valleyRounding: 0.3, innerRadiusRatio: 0.4)),
            child: ClipPath(
              clipBehavior: Clip.hardEdge,
              child: WaveWidget(
                config: CustomConfig(
                  colors: [Colors.deepPurple.withAlpha(50), Colors.deepPurple.withAlpha(80)],
                  durations: [5000, 4000],
                  heightPercentages: [fill - 0.01, fill + 0.01],
                ),
                backgroundColor: Colors.lightBlueAccent.withAlpha(40),
                size: Size(double.infinity, double.infinity),
                waveAmplitude: 10,
              ),
            ),
          ),

          Positioned.fill(
            child: Align(
              alignment: Alignment.center,
              child: CustomText(
                "${(progress >= 0.0 && progress <= 1.0) ? (progress * 100.0).truncate() : 0}%",
                fontWeight: FontWeight.bold,
                textAlign: TextAlign.center,
              ),
            ),
          ),
        ],
      ),
    );
  }
}

/// Widget's clipped

class StarClipper extends CustomClipper<Path> {
  final StarBorder starBorder;

  StarClipper(this.starBorder);

  @override
  Path getClip(Size size) {
    return starBorder.getOuterPath(Rect.fromLTWH(0, 0, size.width, size.height));
  }

  @override
  bool shouldReclip(covariant CustomClipper<Path> oldClipper) => false;
}
