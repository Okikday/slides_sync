import 'dart:developer';

import 'package:custom_widgets_toolkit/custom_widgets_toolkit.dart';
import 'package:flutter/material.dart';
import 'package:flutter_animate/flutter_animate.dart';
import 'package:iconsax_flutter/iconsax_flutter.dart';
import 'package:slides_sync/core/models/file_details.dart';
import 'package:slides_sync/core/utils/ui_utils.dart';
import 'package:slides_sync/data/models/course_model/course_model.dart';
import 'package:slides_sync/features/modify_all/modify_contents/domain/usecases/modify_content_uc.dart';
import 'package:slides_sync/features/modify_all/modify_contents/presentation/views/modify_contents/mod_content_card_tile.dart';
import 'package:slides_sync/shared/helpers/extension_helper.dart';

class ModifyContentListView extends StatelessWidget {
  final int courseDbId;
  final String collectionId;
  final List<CourseContent> contentList;
  const ModifyContentListView({super.key, required this.courseDbId, required this.collectionId, required this.contentList});

  @override
  Widget build(BuildContext context) {
    final mcu = ModifyContentUc();
    return SliverPadding(
      padding: EdgeInsets.symmetric(horizontal: context.hPadding7),
      sliver: SliverList.builder(
        itemCount: contentList.length,
        itemBuilder: (context, index) {
          final actions = <ModContentCardTileAction>[
            (title: "Select", iconData: Iconsax.tick_circle, onTap: () {}),
            (title: "Rename", iconData: Iconsax.edit, onTap: () {}),
            (
              title: "Delete",
              iconData: Iconsax.trash,
              onTap: () async {
                log("Tapped delete");
                final outcome = await mcu.onDeleteContent(contentList[index], collectionId: collectionId);
                if (context.mounted) {
                  if (outcome == null) {
                    UiUtils.showFlushBar(context, msg: "Successfully added course!", vibe: FlushbarVibe.success);
                  } else if (outcome.contains("error")) {
                    UiUtils.showFlushBar(context, msg: outcome, vibe: FlushbarVibe.error);
                  } else {
                    UiUtils.showFlushBar(context, msg: outcome, vibe: FlushbarVibe.warning);
                  }
                }
              },
            ),
          ];
          return ModContentCardTile(content: contentList[index], actions: actions).animate().slideY(
            begin: double.parse((0.2 * (index + (10 / 2) / 10)).toStringAsFixed(2)),
            end: 0,
            curve: CustomCurves.bouncySpring,
            duration: Durations.extralong1,
          );
        },
      ),
    );
  }
}
