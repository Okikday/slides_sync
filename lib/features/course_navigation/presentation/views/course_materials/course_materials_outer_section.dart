import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:iconsax_flutter/iconsax_flutter.dart';
import 'package:slides_sync/data/models/course_model/course_model.dart';
import 'package:slides_sync/features/course_navigation/presentation/views/course_materials/course_material_card.dart';

class CourseMaterialsOuterSection extends ConsumerStatefulWidget {
  final CourseSubCollection collection;
  const CourseMaterialsOuterSection({super.key, required this.collection});

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
      itemCount: widget.collection.courseContents.length,
      itemBuilder: (context, index) {
        return CourseMaterialCard(
          courseContent: widget.collection.courseContents[index],
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
