import 'dart:developer';

import 'package:flutter/material.dart';
import 'package:flutter_animate/flutter_animate.dart';
import 'package:slides_sync/domain/models/course_model/course.dart';
import 'package:slides_sync/features/manage_all/manage_contents/presentation/providers/modify_contents_view_providers.dart';
import 'package:slides_sync/features/manage_all/manage_contents/presentation/views/modify_contents/mod_content_card_tile.dart';
import 'package:slides_sync/shared/helpers/extension_helper.dart';

class ModifyContentListView extends StatelessWidget {
  final int courseDbId;
  final String collectionId;
  final List<CourseContent> contentList;
  final ModifyContentsViewProviders mcvp;
  const ModifyContentListView({
    super.key,
    required this.courseDbId,
    required this.collectionId,
    required this.contentList,
    required this.mcvp,
  });

  @override
  Widget build(BuildContext context) {
    return SliverPadding(
      padding: EdgeInsets.symmetric(horizontal: context.hPadding7),
      sliver: SliverList.builder(
        itemCount: contentList.length,
        itemBuilder: (context, index) {
          final content = contentList[index];
          return ValueListenableBuilder(
            valueListenable: mcvp.selectedContentsNotifier,
            
            builder: (context, value, child) {
              final lookUp = value.lookup(content);
              return ModContentCardTile(
                content: content,
                isSelected: value.isEmpty ? null : (value.isNotEmpty && lookUp != null ? true : false),
                onTap: () {
                  if (value.isNotEmpty) {
                    final check = value.lookup(content);
                    if (check != null) {
                      mcvp.removeContent(content);
                    } else {
                      mcvp.selectContent(content);
                    }
                  } else {
                    // Normal action
                  }
                },
                onSelected: () {
                  final check = value.lookup(content);
                  if (check != null) {
                    mcvp.removeContent(content);
                  } else {
                    mcvp.selectContent(content);
                  }
                },
              ).animate().fadeIn().slideY(
                begin: (index / contentList.length + 1) * 0.4,
                end: 0,
                curve: Curves.fastEaseInToSlowEaseOut,
                duration: Durations.extralong2,
              );
            }
          );
        },
      ),
    );
  }
}
