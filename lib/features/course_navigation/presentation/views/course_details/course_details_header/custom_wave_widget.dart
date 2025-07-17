import 'package:custom_widgets_toolkit/custom_widgets_toolkit.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:slides_sync/shared/helpers/extension_helper.dart';
import 'package:wave/config.dart';
import 'package:wave/wave.dart';

// class StarWaveFilledProgressWidget extends ConsumerWidget {
//   final double progress;
//   final double width;
//   final double height;
//   final Widget? backgroundWidget;
//   const StarWaveFilledProgressWidget({super.key, required this.progress, this.width = 100, this.height = 100, this.backgroundWidget});

//   @override
//   Widget build(BuildContext context, WidgetRef ref) {
//     return ClipPath(
//       clipper: StarClipper(StarBorder(points: 4, pointRounding: 0.7, valleyRounding: 0.3, innerRadiusRatio: 0.4)),
//       child: SizedBox(
//         width: width,
//         height: height,
//         child: Stack(
//           clipBehavior: Clip.hardEdge,
//           children: [

//             if(backgroundWidget != null) backgroundWidget!,

//             CustomWaveWidget(progress: progress),

//             Positioned.fill(
//               child: Align(
//                 alignment: Alignment.center,
//                 child: CustomText(
//                   "${(progress >= 0.0 && progress <= 1.0) ? (progress * 100.0).truncate() : 0}%",
//                   fontWeight: FontWeight.bold,
//                   textAlign: TextAlign.center,
//                 ),
//               ),
//             ),
//           ],
//         ),
//       ),
//     );
//   }
// }

class CustomShapeWaveFilledWidget extends StatelessWidget {
  final double progress;
  final Widget? backgroundWidget;
  final TextStyle? textStyle;
  const CustomShapeWaveFilledWidget({super.key, required this.progress, this.backgroundWidget, this.textStyle});

  @override
  Widget build(BuildContext context) {
    return Stack(
      children: [
        if (backgroundWidget != null) backgroundWidget!,
        CustomWaveWidget(progress: 0.56),

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
  const CustomWaveWidget({super.key, required this.progress});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final double fill;
    if (progress < 0.0 || progress > 1.0) {
      fill = 0.0;
    } else {
      fill = 1.0 - progress;
    }
    return WaveWidget(
      config: CustomConfig(
        colors: [context.theme.primaryColor.withAlpha(50), context.theme.primaryColor.withAlpha(80)],
        durations: [5000, 4000],
        heightPercentages: [fill - 0.01, fill + 0.01],
      ),
      backgroundColor: context.theme.colorScheme.secondary.withAlpha(40),
      size: Size(double.infinity, double.infinity),
      waveAmplitude: 10,
    );
  }
}

// /// Widget's clipped

// class StarClipper extends CustomClipper<Path> {
//   final StarBorder starBorder;

//   StarClipper(this.starBorder);

//   @override
//   Path getClip(Size size) {
//     return starBorder.getOuterPath(Rect.fromLTWH(0, 0, size.width, size.height));
//   }

//   @override
//   bool shouldReclip(covariant CustomClipper<Path> oldClipper) => false;
// }
