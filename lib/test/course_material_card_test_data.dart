import 'package:iconsax_flutter/iconsax_flutter.dart';
import 'package:slides_sync/features/course_navigation/presentation/models/course_materials_models/course_material_card_model.dart';

import 'dart:developer';

class CourseMaterialCardTestData {
  static final List<CourseMaterialCardModel> dummyCourseMaterials = [
    CourseMaterialCardModel(
      title: 'Introduction to Algebra',
      progress: 0.2,
      courseMaterialCardFunctionsModels: [
        CourseMaterialCardFunctionsModel(label: 'Open', icon: Iconsax.document, onTap: () => log('Open Algebra')),
        CourseMaterialCardFunctionsModel(label: 'Bookmark', icon: Iconsax.bookmark, onTap: () => log('Bookmark Algebra')),
        CourseMaterialCardFunctionsModel(label: 'Share', icon: Iconsax.share, onTap: () => log('Share Algebra')),
        CourseMaterialCardFunctionsModel(label: 'Details', icon: Iconsax.info_circle, onTap: () => log('Details Algebra')),
        CourseMaterialCardFunctionsModel(label: 'Remove', icon: Iconsax.trash, onTap: () => log('Remove Algebra')),
      ],
    ),
    CourseMaterialCardModel(
      title: 'Calculus 101',
      progress: 0.6,
      courseMaterialCardFunctionsModels: [
        CourseMaterialCardFunctionsModel(label: 'Open', icon: Iconsax.document, onTap: () => log('Open Calculus')),
        CourseMaterialCardFunctionsModel(label: 'Bookmark', icon: Iconsax.bookmark, onTap: () => log('Bookmark Calculus')),
        CourseMaterialCardFunctionsModel(label: 'Share', icon: Iconsax.share, onTap: () => log('Share Calculus')),
        CourseMaterialCardFunctionsModel(label: 'Details', icon: Iconsax.info_circle, onTap: () => log('Details Calculus')),
        CourseMaterialCardFunctionsModel(label: 'Remove', icon: Iconsax.trash, onTap: () => log('Remove Calculus')),
      ],
    ),
    CourseMaterialCardModel(
      title: 'Linear Algebra',
      progress: 0.9,

      courseMaterialCardFunctionsModels: [
        CourseMaterialCardFunctionsModel(label: 'Open', icon: Iconsax.document, onTap: () => log('Open Linear Algebra')),
        CourseMaterialCardFunctionsModel(label: 'Bookmark', icon: Iconsax.bookmark, onTap: () => log('Bookmark Linear Algebra')),
        CourseMaterialCardFunctionsModel(label: 'Share', icon: Iconsax.share, onTap: () => log('Share Linear Algebra')),
        CourseMaterialCardFunctionsModel(label: 'Details', icon: Iconsax.info_circle, onTap: () => log('Details Linear Algebra')),
        CourseMaterialCardFunctionsModel(label: 'Remove', icon: Iconsax.trash, onTap: () => log('Remove Linear Algebra')),
      ],
    ),
    CourseMaterialCardModel(
      title: 'Discrete Mathematics',
      progress: 0.1,

      courseMaterialCardFunctionsModels: [
        CourseMaterialCardFunctionsModel(label: 'Open', icon: Iconsax.document, onTap: () => log('Open Discrete Mathematics')),
        CourseMaterialCardFunctionsModel(label: 'Bookmark', icon: Iconsax.bookmark, onTap: () => log('Bookmark Discrete Mathematics')),
        CourseMaterialCardFunctionsModel(label: 'Share', icon: Iconsax.share, onTap: () => log('Share Discrete Mathematics')),
        CourseMaterialCardFunctionsModel(label: 'Details', icon: Iconsax.info_circle, onTap: () => log('Details Discrete Mathematics')),
        CourseMaterialCardFunctionsModel(label: 'Remove', icon: Iconsax.trash, onTap: () => log('Remove Discrete Mathematics')),
      ],
    ),
    CourseMaterialCardModel(
      title: 'Software Engineering',
      progress: 0.45,

      courseMaterialCardFunctionsModels: [
        CourseMaterialCardFunctionsModel(label: 'Open', icon: Iconsax.document, onTap: () => log('Open Software Engineering')),
        CourseMaterialCardFunctionsModel(label: 'Bookmark', icon: Iconsax.bookmark, onTap: () => log('Bookmark Software Engineering')),
        CourseMaterialCardFunctionsModel(label: 'Share', icon: Iconsax.share, onTap: () => log('Share Software Engineering')),
        CourseMaterialCardFunctionsModel(label: 'Details', icon: Iconsax.info_circle, onTap: () => log('Details Software Engineering')),
        CourseMaterialCardFunctionsModel(label: 'Remove', icon: Iconsax.trash, onTap: () => log('Remove Software Engineering')),
      ],
    ),
    CourseMaterialCardModel(
      title: 'Computer Networks',
      progress: 0.3,

      courseMaterialCardFunctionsModels: [
        CourseMaterialCardFunctionsModel(label: 'Open', icon: Iconsax.document, onTap: () => log('Open Computer Networks')),
        CourseMaterialCardFunctionsModel(label: 'Bookmark', icon: Iconsax.bookmark, onTap: () => log('Bookmark Computer Networks')),
        CourseMaterialCardFunctionsModel(label: 'Share', icon: Iconsax.share, onTap: () => log('Share Computer Networks')),
        CourseMaterialCardFunctionsModel(label: 'Details', icon: Iconsax.info_circle, onTap: () => log('Details Computer Networks')),
        CourseMaterialCardFunctionsModel(label: 'Remove', icon: Iconsax.trash, onTap: () => log('Remove Computer Networks')),
      ],
    ),
    CourseMaterialCardModel(
      title: 'Artificial Intelligence',
      progress: 0.75,

      courseMaterialCardFunctionsModels: [
        CourseMaterialCardFunctionsModel(label: 'Open', icon: Iconsax.document, onTap: () => log('Open Artificial Intelligence')),
        CourseMaterialCardFunctionsModel(label: 'Bookmark', icon: Iconsax.bookmark, onTap: () => log('Bookmark Artificial Intelligence')),
        CourseMaterialCardFunctionsModel(label: 'Share', icon: Iconsax.share, onTap: () => log('Share Artificial Intelligence')),
        CourseMaterialCardFunctionsModel(label: 'Details', icon: Iconsax.info_circle, onTap: () => log('Details Artificial Intelligence')),
        CourseMaterialCardFunctionsModel(label: 'Remove', icon: Iconsax.trash, onTap: () => log('Remove Artificial Intelligence')),
      ],
    ),
  ];
}
