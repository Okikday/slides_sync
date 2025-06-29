import 'package:custom_widgets_toolkit/custom_widgets_toolkit.dart';
import 'package:flutter/material.dart';
import 'package:flutter_animate/flutter_animate.dart';
import 'package:iconsax_flutter/iconsax_flutter.dart';
import 'package:material_shapes/material_shapes.dart';
import 'package:page_transition/page_transition.dart';
import 'package:slides_sync/core/models/file_details.dart';
import 'package:slides_sync/core/utils/app_navigator.dart';
import 'package:slides_sync/data/models/course_model/course_model.dart';
import 'package:slides_sync/features/course_navigation/presentation/views/course_details/course_categories_card.dart';
import 'package:slides_sync/features/course_navigation/presentation/views/course_details/course_details_header/animated_shape.dart';
import 'package:slides_sync/features/course_navigation/presentation/views/course_materials_view.dart';
import 'package:slides_sync/features/modify_collections/presentation/views/modify_collections/create_collection_bottom_sheet.dart';
import 'package:slides_sync/features/modify_collections/presentation/views/modify_collections/empty_collections_view.dart';
import 'package:slides_sync/shared/helpers/extension_helper.dart';
import 'package:slides_sync/shared/widgets/build_image_path_widget.dart';

class CourseDetailsCollectionSection extends StatelessWidget {
  const CourseDetailsCollectionSection({super.key, required this.courseModel});

  final CourseModel courseModel;

  @override
  Widget build(BuildContext context) {
    final collections = courseModel.subCollections;

    if (collections.isEmpty) {
      return EmptyCollectionsView(
        onClickAddCollection: () async {
          AppNavigator.to(context).modifyCollectionsRoute(courseModel);
          await Future.delayed(Durations.short1);
          if (context.mounted) {
            CustomDialog.show(
              context,
              canPop: true,
              barrierColor: Colors.black.withAlpha(150),
              child: CreateCollectionBottomSheet(courseDbId: courseModel.id),
            );
          }
        },
      );
    }

    List<RoundedPolygon> shapes =
        materialShapes.map<RoundedPolygon>((({RoundedPolygon shape, String title}) record) => record.shape).toList();
    shapes.shuffle();

    return SliverList.builder(
      itemCount: collections.length,
      itemBuilder: (context, index) {
        return Padding(
          padding: const EdgeInsets.only(bottom: 16.0, left: 16.0, right: 16.0),
          child: CourseCategoriesCard(
            isDarkMode: context.isDarkMode,
            title: collections[index].collectionTitle,
            icon: Padding(
              padding: const EdgeInsets.all(8.0),
              child: ClipPath(
                clipper: MorphClipper(path: shapes[index.clamp(0, 30)].toPath(), size: Size(20, 20)),
                child: ColoredBox(color: context.theme.primaryColor),
              ),
            ),
            onTap: () {
              if (context.mounted) {
                Navigator.of(context).push(
                  PageTransition(
                    type: PageTransitionType.rightToLeftWithFade,
                    duration: Durations.extralong3,
                    reverseDuration: Durations.medium1,
                    curve: CustomCurves.snappySpring,
                    child: CourseMaterialsView(),
                  ),
                );
              }
            },
          ).animate().slideY(
            begin: double.parse((0.6 * (index + (collections.length / 2) / collections.length)).toStringAsFixed(2)),
            end: 0,
            curve: CustomCurves.bouncySpring,
            duration: Durations.extralong4,
          ),
        );
      },
    );
  }
}
