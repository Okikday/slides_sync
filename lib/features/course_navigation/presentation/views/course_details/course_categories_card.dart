import 'dart:math' as math;

import 'package:custom_widgets_toolkit/custom_widgets_toolkit.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:slides_sync/features/course_navigation/presentation/views/course_details/course_details_header/animated_shape.dart';
import 'package:slides_sync/shared/helpers/extension_helper.dart';
import 'package:slides_sync/shared/styles/colors.dart';

class CourseCategoriesCard extends ConsumerStatefulWidget {
  final bool isDarkMode;
  final String title;
  final int contentCount;
  final void Function() onTap;
  const CourseCategoriesCard({
    super.key,
    required this.isDarkMode,
    required this.title,
    required this.onTap,
    this.contentCount = 0,
  });

  @override
  ConsumerState<CourseCategoriesCard> createState() => _CourseCategoriesCardState();
}

class _CourseCategoriesCardState extends ConsumerState<CourseCategoriesCard> {
  final List<RoundedPolygon> shapes = List.from(materialShapes.map((e) => e.shape));
  late final RoundedPolygon shape;
  @override
  void initState() {
    super.initState();
    final randomIndex = math.Random().nextInt(shapes.length);
    shape = shapes[randomIndex];
  }

  @override
  Widget build(BuildContext context) {
    return InkWell(
      borderRadius: BorderRadius.circular(12),
      onTap: widget.onTap,
      child: DecoratedBox(
        decoration: BoxDecoration(
          color: ref.theme.bgSupportText.withAlpha(10),
          border: Border.all(color: ref.theme.bgSupportText.withAlpha(12)),
          borderRadius: BorderRadius.circular(12),
        ),
        child: Padding(
          padding: EdgeInsets.all(16),

          child: Row(
            children: [
              Container(
                width: 40,
                height: 40,
                clipBehavior: Clip.hardEdge,
                padding: EdgeInsets.all(1),
                decoration: BoxDecoration(
                  color: AppColors.primary(context).withValues(alpha: 0.1),
                  shape: BoxShape.circle,
                  border: Border.fromBorderSide(BorderSide(color: AppColors.primary(context).withAlpha(40), width: 1.0)),
                ),
                child: Padding(
              padding: const EdgeInsets.all(8.0),
              child: ClipPath(
                clipper: MorphClipper(path: shape.toPath(), size: Size(20, 20)),
                    child: ColoredBox(color: ref.theme.primaryColor),
              ),
            ),
              ),
              ConstantSizing.rowSpacingMedium,
              Expanded(
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  crossAxisAlignment: CrossAxisAlignment.start,
                  spacing: 4.0,
                  children: [
                    CustomText(
                      widget.title,
                      fontSize: 15,
                      color: ref.theme.primaryText,
                    ),
                    CustomText(
                      "${widget.contentCount == 0 ? "No" : "${widget.contentCount}"} ${widget.contentCount == 1 ? "item" : "items"}",
                      fontSize: 12,
                      color: ref.theme.secondaryText,
                    ),
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
