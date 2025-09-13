import 'dart:async';
import 'dart:developer';

import 'package:custom_widgets_toolkit/custom_widgets_toolkit.dart';
import 'package:flutter/material.dart';
import 'package:flutter_animate/flutter_animate.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:iconsax_flutter/iconsax_flutter.dart';
import 'package:isar/isar.dart';
import 'package:slides_sync/domain/models/course_model/course.dart';
import 'package:slides_sync/domain/repos/course_repo/course_collection_repo.dart';
import 'package:slides_sync/domain/repos/course_repo/course_content_repo.dart';
import 'package:slides_sync/features/course_navigation/presentation/providers/course_materials_providers.dart';
import 'package:slides_sync/features/course_navigation/presentation/views/course_materials/content_card.dart';
import 'package:slides_sync/shared/helpers/extension_helper.dart';

class MaterialsView extends ConsumerStatefulWidget {
  final CourseCollection collection;
  final ScrollController scrollController;

  const MaterialsView({super.key, required this.collection, required this.scrollController});

  @override
  ConsumerState<ConsumerStatefulWidget> createState() => _MaterialsViewState();
}

class _MaterialsViewState extends ConsumerState<MaterialsView> {
  @override
  void initState() {
    super.initState();
  }

  @override
  void dispose() {
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final bool isListView = ref.watch(CourseMaterialsProviders.isListLayout).value ?? false;
    final isGrid = !isListView;
    final streamedContents = ref.watch(CourseMaterialsProviders.of(widget.collection.collectionId).watchContents);

    return SliverPadding(
      padding: EdgeInsetsGeometry.fromLTRB(16, 12, 16, 64 + context.bottomPadding + context.viewInsets.bottom),
      sliver: streamedContents.when(
        data: (items) {
          if (isGrid) {
            return SliverGrid(
              gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                crossAxisCount: context.deviceWidth ~/ 160,
                crossAxisSpacing: 12,
                mainAxisSpacing: 20,
              ),
              delegate: SliverChildBuilderDelegate((context, index) {
                final content = items[index];
                return ContentCard(content: content.content, progress: content.progress?.progress)
                    .animate()
                    .fadeIn(curve: CustomCurves.defaultIosSpring, duration: Durations.extralong1)
                    .slideY(begin: 0.1, end: 0, curve: CustomCurves.defaultIosSpring, duration: Durations.extralong4);
              }, childCount: items.length),
            );
          } else {
            return SliverList(
              delegate: SliverChildBuilderDelegate((context, index) {
                final content = items[index];
                return Padding(
                  padding: const EdgeInsets.only(bottom: 16),
                  child: ContentCard(content: content.content, progress: content.progress?.progress)
                      .animate()
                      .fadeIn(curve: CustomCurves.defaultIosSpring, duration: Durations.extralong1)
                      .slideY(begin: 0.1, end: 0, curve: CustomCurves.defaultIosSpring, duration: Durations.extralong4),
                );
              }, childCount: items.length),
            );
          }
        },
        error: (e, st) {
          return SliverToBoxAdapter();
        },
        loading: () => SliverToBoxAdapter(),
      ),
    );
  }
}
