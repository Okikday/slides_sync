import 'package:flutter/material.dart';
import 'package:iconsax_flutter/iconsax_flutter.dart';
import 'package:slides_sync/views/library/sub_pages/course_details/sub_pages/course_materials/course_material_card.dart';


class CourseMaterialCardTestData{
  static final List<CourseMaterialCardModel> dummyCourseMaterials = [
    CourseMaterialCardModel(
      title: 'Introduction to Algebra',
      progress: 0.2,
      courseMaterialCardFunctionsModels: [
        CourseMaterialCardFunctionsModel(label: 'Open', icon: Iconsax.document, onTap: () => print('Open Algebra')),
        CourseMaterialCardFunctionsModel(label: 'Bookmark', icon: Iconsax.bookmark, onTap: () => print('Bookmark Algebra')),
        CourseMaterialCardFunctionsModel(label: 'Share', icon: Iconsax.share, onTap: () => print('Share Algebra')),
        CourseMaterialCardFunctionsModel(label: 'Details', icon: Iconsax.info_circle, onTap: () => print('Details Algebra')),
        CourseMaterialCardFunctionsModel(label: 'Remove', icon: Iconsax.trash, onTap: () => print('Remove Algebra')),
      ],
    ),
    CourseMaterialCardModel(
      title: 'Calculus 101',
      progress: 0.6,
      courseMaterialCardFunctionsModels: [
        CourseMaterialCardFunctionsModel(label: 'Open', icon: Iconsax.document, onTap: () => print('Open Calculus')),
        CourseMaterialCardFunctionsModel(label: 'Bookmark', icon: Iconsax.bookmark, onTap: () => print('Bookmark Calculus')),
        CourseMaterialCardFunctionsModel(label: 'Share', icon: Iconsax.share, onTap: () => print('Share Calculus')),
        CourseMaterialCardFunctionsModel(label: 'Details', icon: Iconsax.info_circle, onTap: () => print('Details Calculus')),
        CourseMaterialCardFunctionsModel(label: 'Remove', icon: Iconsax.trash, onTap: () => print('Remove Calculus')),
      ],
    ),
    CourseMaterialCardModel(
      title: 'Linear Algebra',
      progress: 0.9,

      courseMaterialCardFunctionsModels: [
        CourseMaterialCardFunctionsModel(label: 'Open', icon: Iconsax.document, onTap: () => print('Open Linear Algebra')),
        CourseMaterialCardFunctionsModel(label: 'Bookmark', icon: Iconsax.bookmark, onTap: () => print('Bookmark Linear Algebra')),
        CourseMaterialCardFunctionsModel(label: 'Share', icon: Iconsax.share, onTap: () => print('Share Linear Algebra')),
        CourseMaterialCardFunctionsModel(label: 'Details', icon: Iconsax.info_circle, onTap: () => print('Details Linear Algebra')),
        CourseMaterialCardFunctionsModel(label: 'Remove', icon: Iconsax.trash, onTap: () => print('Remove Linear Algebra')),
      ],
    ),
    CourseMaterialCardModel(
      title: 'Discrete Mathematics',
      progress: 0.1,

      courseMaterialCardFunctionsModels: [
        CourseMaterialCardFunctionsModel(label: 'Open', icon: Iconsax.document, onTap: () => print('Open Discrete Mathematics')),
        CourseMaterialCardFunctionsModel(label: 'Bookmark', icon: Iconsax.bookmark, onTap: () => print('Bookmark Discrete Mathematics')),
        CourseMaterialCardFunctionsModel(label: 'Share', icon: Iconsax.share, onTap: () => print('Share Discrete Mathematics')),
        CourseMaterialCardFunctionsModel(label: 'Details', icon: Iconsax.info_circle, onTap: () => print('Details Discrete Mathematics')),
        CourseMaterialCardFunctionsModel(label: 'Remove', icon: Iconsax.trash, onTap: () => print('Remove Discrete Mathematics')),
      ],
    ),
    CourseMaterialCardModel(
      title: 'Software Engineering',
      progress: 0.45,

      courseMaterialCardFunctionsModels: [
        CourseMaterialCardFunctionsModel(label: 'Open', icon: Iconsax.document, onTap: () => print('Open Software Engineering')),
        CourseMaterialCardFunctionsModel(label: 'Bookmark', icon: Iconsax.bookmark, onTap: () => print('Bookmark Software Engineering')),
        CourseMaterialCardFunctionsModel(label: 'Share', icon: Iconsax.share, onTap: () => print('Share Software Engineering')),
        CourseMaterialCardFunctionsModel(label: 'Details', icon: Iconsax.info_circle, onTap: () => print('Details Software Engineering')),
        CourseMaterialCardFunctionsModel(label: 'Remove', icon: Iconsax.trash, onTap: () => print('Remove Software Engineering')),
      ],
    ),
    CourseMaterialCardModel(
      title: 'Computer Networks',
      progress: 0.3,

      courseMaterialCardFunctionsModels: [
        CourseMaterialCardFunctionsModel(label: 'Open', icon: Iconsax.document, onTap: () => print('Open Computer Networks')),
        CourseMaterialCardFunctionsModel(label: 'Bookmark', icon: Iconsax.bookmark, onTap: () => print('Bookmark Computer Networks')),
        CourseMaterialCardFunctionsModel(label: 'Share', icon: Iconsax.share, onTap: () => print('Share Computer Networks')),
        CourseMaterialCardFunctionsModel(label: 'Details', icon: Iconsax.info_circle, onTap: () => print('Details Computer Networks')),
        CourseMaterialCardFunctionsModel(label: 'Remove', icon: Iconsax.trash, onTap: () => print('Remove Computer Networks')),
      ],
    ),
    CourseMaterialCardModel(
      title: 'Artificial Intelligence',
      progress: 0.75,

      courseMaterialCardFunctionsModels: [
        CourseMaterialCardFunctionsModel(label: 'Open', icon: Iconsax.document, onTap: () => print('Open Artificial Intelligence')),
        CourseMaterialCardFunctionsModel(label: 'Bookmark', icon: Iconsax.bookmark, onTap: () => print('Bookmark Artificial Intelligence')),
        CourseMaterialCardFunctionsModel(label: 'Share', icon: Iconsax.share, onTap: () => print('Share Artificial Intelligence')),
        CourseMaterialCardFunctionsModel(label: 'Details', icon: Iconsax.info_circle, onTap: () => print('Details Artificial Intelligence')),
        CourseMaterialCardFunctionsModel(label: 'Remove', icon: Iconsax.trash, onTap: () => print('Remove Artificial Intelligence')),
      ],
    ),
  ];
}
