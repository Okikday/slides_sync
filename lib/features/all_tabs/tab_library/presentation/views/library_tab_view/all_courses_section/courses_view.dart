
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:slides_sync/domain/models/course_model/course.dart';
import 'package:slides_sync/features/all_tabs/tab_library/presentation/views/library_tab_view/all_courses_section/union_course_card.dart';
import 'package:slides_sync/shared/helpers/extension_helper.dart';

class CoursesView extends ConsumerWidget {
  const CoursesView(
    this.isListView, {
    super.key,
    required this.scaleClickProviderFamily,
    required this.longPressTapDetailsProvider,
    required this.data,
    required this.onTap,
    required this.onLongPress,
  });

  final bool isListView;
  final AutoDisposeStateProviderFamily<bool, int> scaleClickProviderFamily;
  final StateProvider<Offset?> longPressTapDetailsProvider;
  final List<Course> data;
  final void Function(int index) onTap;
  final void Function(int index) onLongPress;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    // final double dimension = (context.deviceWidth > context.deviceHeight ? context.deviceWidth * 0.12 : context.deviceWidth * 0.12);
    
    if (isListView) {
      return SliverList.builder(
        itemCount: data.length,
        itemBuilder: (context, index) {
          return UnionCourseCard(
            data[index],
            false,
            scaleClickProvider: scaleClickProviderFamily(index),
            longPressTapDetailsProvider: longPressTapDetailsProvider,
            onTap: () => onTap(index),
            onLongPress: () => onLongPress(index),
          );
        }
      );
    } else {
      return SliverGrid.builder(
        gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
          crossAxisCount: context.deviceHeight > context.deviceWidth ? 2 : 3,
          
          crossAxisSpacing: 12,
        ),
        itemCount: data.length,
        itemBuilder: (context, index) {
          return UnionCourseCard(
            data[index],
            true,
            scaleClickProvider: scaleClickProviderFamily(index),
            longPressTapDetailsProvider: longPressTapDetailsProvider,
            onTap: () => onTap(index),
            onLongPress: () => onLongPress(index),
          );
        },
      );
    }
  }
}
