import 'dart:developer';

import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:iconsax_flutter/iconsax_flutter.dart';
import 'package:slides_sync/core/models/file_location.dart';
import 'package:slides_sync/core/utils/ui_utils.dart';
import 'package:slides_sync/data/models/course_model/course_model.dart';
import 'package:slides_sync/shared/components/app_bar_container.dart';
import 'package:slides_sync/shared/components/app_bar_container_child.dart';
import 'package:slides_sync/shared/helpers/extension_helper.dart';

import 'course_materials/course_material_card.dart';

class CourseMaterialsView extends ConsumerStatefulWidget {
  const CourseMaterialsView({super.key});

  @override
  ConsumerState<CourseMaterialsView> createState() => _CourseMaterialsViewState();
}

class _CourseMaterialsViewState extends ConsumerState<CourseMaterialsView> {
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
    return AnnotatedRegion(
      value: UiUtils.getSystemUiOverlayStyle(context.scaffoldBackgroundColor, context.isDarkMode),
      child: Scaffold(
        appBar: AppBarContainer(
          appBarHeight: kToolbarHeight + 12,
          padding: EdgeInsets.zero,
          child: AppBarContainerChild(context.isDarkMode, title: "Course Materials", trailing: Icon(Iconsax.filter),),
        ),

        body: CourseMaterialsOuterSection(),
      ),
    );
  }
}

class CourseMaterialsOuterSection extends ConsumerStatefulWidget {
  const CourseMaterialsOuterSection({super.key});

  @override
  ConsumerState<ConsumerStatefulWidget> createState() => _CourseMaterialsOuterSectionState();
}

class _CourseMaterialsOuterSectionState extends ConsumerState<CourseMaterialsOuterSection> {
  late final AutoDisposeStateProviderFamily<bool, int> isCourseMaterialCardExpandedFamily;

  final List<CourseMaterialCardActionModel> simList = [
    CourseMaterialCardActionModel(label: 'Open', icon: Iconsax.document, onTap: () {}),
    CourseMaterialCardActionModel(label: 'Bookmark', icon: Iconsax.bookmark, onTap: () {}),
    CourseMaterialCardActionModel(label: 'Share', icon: Iconsax.share, onTap: () {}),
    CourseMaterialCardActionModel(label: 'Details', icon: Iconsax.info_circle, onTap: () {}),
    CourseMaterialCardActionModel(label: 'Remove', icon: Iconsax.trash, onTap: () {}),
  ];

  @override
  void initState() {
    super.initState();
    isCourseMaterialCardExpandedFamily = AutoDisposeStateProviderFamily((ref, index) => false);
  }

  @override
  Widget build(BuildContext context) {
    return ListView.builder(
      padding: EdgeInsets.only(top: 8),
      physics: BouncingScrollPhysics(),
      itemCount: 10,
      itemBuilder: (context, index) {
        return CourseMaterialCard(
          courseContent: CourseContent.create(
            title: "Last Days in Forcado",
            path: FileLocation(),
            courseContentType: CourseContentType.audio,
          ),
          courseMaterialCardActionModels: simList,
          isCourseMaterialCardExpandedProvider: isCourseMaterialCardExpandedFamily(index),
          onTapCard: () {
            for (int i = 0; i < 10; i++) {
              final isExpandedNotifier = ref.read(isCourseMaterialCardExpandedFamily(i).notifier);
              if (i == index) {
                isExpandedNotifier.update((cb) => !isExpandedNotifier.state);
              } else {
                if (isExpandedNotifier.state) {
                  isExpandedNotifier.update((cb) => false);
                }
              }
              // log("$i. ${isExpandedNotifier.state}");
            }
          },
          onLongPressed: () {},
        );
      },
    );
  }
}
