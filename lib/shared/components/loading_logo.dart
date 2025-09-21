import 'package:custom_widgets_toolkit/custom_widgets_toolkit.dart';
import 'package:flutter/material.dart';
import 'package:flutter_animate/flutter_animate.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:lottie/lottie.dart';

class LoadingLogo extends ConsumerStatefulWidget {
  final double? size;
  final bool rotate;
  final Color? color;
  const LoadingLogo({super.key, this.size = 40, this.rotate = true, this.color});

  @override
  ConsumerState<ConsumerStatefulWidget> createState() => _LoadingLogoState();
}

class _LoadingLogoState extends ConsumerState<LoadingLogo> with SingleTickerProviderStateMixin {
  late final AnimationController controller;
  late final Animation<double> anim;
  late final Animation<double> scaleAnim;
  late final Animation<double> fadeAnim;
  late final CurvedAnimation _curvedAnim;
  @override
  void initState() {
    super.initState();
    controller = AnimationController(
      vsync: this,
      duration: Duration(milliseconds: 800),
      reverseDuration: Duration(milliseconds: 800),
    );
    _curvedAnim = CurvedAnimation(
      parent: controller,
      curve: CustomCurves.easeInOutSine,
      reverseCurve: CustomCurves.decelerate,
    );
    anim = Tween<double>(begin: 1, end: 0).animate(_curvedAnim);
    scaleAnim = Tween<double>(begin: 0.9, end: 1).animate(_curvedAnim);
    fadeAnim = Tween<double>(begin: 0.5, end: 1).animate(_curvedAnim);
    controller.repeat(reverse: true);
  }

  @override
  void dispose() {
    controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final lottieChild = LottieBuilder.asset(
      "assets/icons/animated_jsons/experimental_loading.json",
      reverse: true,
      controller: anim,
    );
    final child = SizedBox.square(
      dimension: widget.size,
      child: FadeTransition(
        opacity: fadeAnim,
        child: ScaleTransition(
          scale: scaleAnim,
          child: widget.color == null
              ? lottieChild
              : ImageFiltered(imageFilter: ColorFilter.mode(widget.color!, BlendMode.srcIn), child: lottieChild),
        ),
      ),
    );
    if (widget.rotate) {
      return child
          .animate(onPlay: (controller) => controller.repeat())
          .rotate(duration: Duration(milliseconds: 1800), curve: CustomCurves.bouncySpring);
    }
    return child;
  }
}
