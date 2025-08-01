import 'package:custom_widgets_toolkit/custom_widgets_toolkit.dart';
import 'package:flutter/material.dart';
import 'package:flutter_animate/flutter_animate.dart';
import 'package:material_shapes/material_shapes.dart';
import 'package:slides_sync/core/models/file_details.dart';
import 'package:slides_sync/features/course_navigation/presentation/views/course_details/course_details_header/animated_shape.dart';
import 'package:slides_sync/features/course_navigation/presentation/views/course_details/course_details_header/custom_wave_widget.dart';
import 'package:slides_sync/shared/helpers/extension_helper.dart';
import 'package:slides_sync/shared/widgets/build_image_path_widget.dart';

class ProgressShapeAnimatedWidget extends StatefulWidget {
  const ProgressShapeAnimatedWidget({super.key, required this.shapeSize, required this.progress, required this.fileDetails});
  final double progress;
  final double shapeSize;
  final FileDetails fileDetails;

  @override
  State<ProgressShapeAnimatedWidget> createState() => _ProgressShapeAnimatedWidgetState();
}

class _ProgressShapeAnimatedWidgetState extends State<ProgressShapeAnimatedWidget> {
  final List<RoundedPolygon> shapes = List.from(materialShapes.map((e) => e.shape));
  late final RoundedPolygon shape;
  @override
  void initState() {
    super.initState();
    shapes.shuffle();
    shape = shapes.first;
  }

  @override
  Widget build(BuildContext context) {
    return Builder(
      builder: (context) {
        return ClipRRect(
          child: MaterialShapedWidget(
            shape: shape,
            size: Size.square(widget.shapeSize),
            child: CustomShapeWaveFilledWidget(
              progress: widget.progress,
              waveSize: Size.square(widget.shapeSize),
              textStyle: TextStyle(fontWeight: FontWeight.bold, fontSize: 13, color: context.theme.primaryColor),
              backgroundWidget: BuildImagePathWidget(
                fileDetails: widget.fileDetails,
                fallbackWidget: const SizedBox(),
              ).animate().fade(begin: 1.0, end: 0.15, duration: Durations.extralong1, curve: CustomCurves.decelerate),
            ),
          ),
        );
      },
    );
  }
}
