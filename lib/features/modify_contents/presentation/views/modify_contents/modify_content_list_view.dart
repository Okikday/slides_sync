import 'package:custom_widgets_toolkit/custom_widgets_toolkit.dart';
import 'package:flutter/material.dart';
import 'package:flutter_animate/flutter_animate.dart';
import 'package:slides_sync/core/models/file_location.dart';
import 'package:slides_sync/data/models/course_model/course_model.dart';
import 'package:slides_sync/features/modify_contents/presentation/views/modify_contents/mod_content_card_tile.dart';
import 'package:slides_sync/shared/helpers/extension_helper.dart';

class ModifyContentListView extends StatelessWidget {
  const ModifyContentListView({super.key});

  @override
  Widget build(BuildContext context) {
    

    return SliverPadding(
      padding: EdgeInsets.symmetric(horizontal: context.hPadding7),
      sliver: SliverList.builder(
        itemCount: 10,
        itemBuilder: (context, index) {
          return ModContentCardTile(
            content: CourseContent.create(title: "Last class recording", path: FileLocation(), courseContentType: CourseContentType.video),
          ).animate().slideY(
            begin: double.parse((0.5 * (index + (10 / 2) / 10)).toStringAsFixed(2)),
            end: 0,
            curve: CustomCurves.bouncySpring,
            duration: Durations.extralong4,
          );
        },
      ),
    );
  }
}
