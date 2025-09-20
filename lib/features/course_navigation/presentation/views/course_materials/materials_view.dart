import 'dart:async';
import 'dart:developer';

import 'package:custom_widgets_toolkit/custom_widgets_toolkit.dart';
import 'package:flutter/material.dart';
import 'package:flutter_animate/flutter_animate.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:iconsax_flutter/iconsax_flutter.dart';
import 'package:isar/isar.dart';
import 'package:skeletonizer/skeletonizer.dart';
import 'package:slides_sync/domain/models/course_model/course.dart';
import 'package:slides_sync/domain/models/file_details.dart';
import 'package:slides_sync/domain/repos/course_repo/course_collection_repo.dart';
import 'package:slides_sync/domain/repos/course_repo/course_content_repo.dart';
import 'package:slides_sync/features/course_navigation/presentation/providers/course_materials_providers.dart';
import 'package:slides_sync/features/course_navigation/presentation/views/course_materials/content_card.dart';
import 'package:slides_sync/shared/helpers/extension_helper.dart';

class MaterialsView extends ConsumerStatefulWidget {
  final CourseCollection collection;

  const MaterialsView({super.key, required this.collection});

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
    final int cardViewType = ref.watch(CourseMaterialsProviders.cardViewType).value ?? 0;
    final isGrid = cardViewType == 0 ? true : false;
    final streamedContents = ref.watch(CourseMaterialsProviders.watchContents(widget.collection.collectionId));

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
                return ContentCard(
                  content: content.content,
                  progress: content.progress?.progress,
                ).animate().fadeIn().slideY(
                  begin: (index / items.length + 1) * 0.4,
                  end: 0,
                  curve: Curves.fastEaseInToSlowEaseOut,
                  duration: Durations.extralong2,
                );
                // .animate()
                // .fadeIn(curve: CustomCurves.defaultIosSpring, duration: Durations.extralong1)
                // .slideY(begin: 0.1, end: 0, curve: CustomCurves.defaultIosSpring, duration: Durations.extralong4);
              }, childCount: items.length),
            );
          } else {
            return SliverList(
              delegate: SliverChildBuilderDelegate((context, index) {
                final content = items[index];
                return Padding(
                  padding: const EdgeInsets.only(bottom: 16),
                  child: ContentCard(
                    content: content.content,
                    progress: content.progress?.progress,
                  ).animate().fadeIn().slideY(
                    begin: (index / items.length + 1) * 0.4,
                    end: 0,
                    curve: Curves.fastEaseInToSlowEaseOut,
                    duration: Durations.extralong2,
                  ),
                  // .animate()
                  // .fadeIn(curve: CustomCurves.defaultIosSpring, duration: Durations.extralong1)
                  // .slideY(begin: 0.1, end: 0, curve: CustomCurves.defaultIosSpring, duration: Durations.extralong4),
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

class ListMaterialCardLoadingShimmer extends ConsumerWidget {
  final int itemCount;
  const ListMaterialCardLoadingShimmer({super.key, this.itemCount = 2});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    return ListView.builder(
      physics: NeverScrollableScrollPhysics(),
      itemCount: itemCount,
      shrinkWrap: true,
      itemBuilder:
          (context, index) => Skeletonizer(
            child: Padding(padding: const EdgeInsets.only(bottom: 8.0), child: ContentCard(content: defaultContent)),
          ),
    );
  }
}
