import 'package:custom_widgets_toolkit/custom_widgets_toolkit.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:iconsax_flutter/iconsax_flutter.dart';


class ModifyCourseHeader extends ConsumerWidget {
  final String title;
  final String description;

  final VoidCallback onClickAddDescription;

  const ModifyCourseHeader({super.key, required this.title, required this.description, required this.onClickAddDescription});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    return  SliverPadding(
      padding: EdgeInsets.symmetric(horizontal: 16.0),
      sliver: SliverToBoxAdapter(
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
                    onClick: onClickAddDescription,
                    borderRadius: 4,
                    child: CustomText(description.isEmpty ? "Add description" : description, color: Colors.deepPurple),
                  ),
                ],
              ),
            ),
            ConstantSizing.rowSpacingLarge,
            CircleAvatar(radius: 35, child: Icon(Iconsax.book)),
          ],
        ),
      ),
    );
  }
}