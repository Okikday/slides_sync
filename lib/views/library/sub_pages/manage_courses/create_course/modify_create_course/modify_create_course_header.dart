import 'package:custom_widgets_toolkit/custom_widgets_toolkit.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:iconsax_flutter/iconsax_flutter.dart';


class ModifyCreateCourseHeader extends ConsumerWidget {
  final String title;
  final String description;

  const ModifyCreateCourseHeader({super.key, required this.title, required this.description});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    return  SliverToBoxAdapter(
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                ConstantSizing.columnSpacingMedium,
                CustomText(title, fontSize: 24, fontWeight: FontWeight.bold),
                CustomTextButton(
                  contentPadding: EdgeInsets.zero,
                  onClick: () {},
                  borderRadius: 4,
                  child: CustomText("Add description", color: Colors.deepPurple),
                ),
              ],
            ),
          ),
          ConstantSizing.rowSpacingLarge,
          CircleAvatar(radius: 35, child: Icon(Iconsax.book)),
        ],
      ),
    );
  }
}