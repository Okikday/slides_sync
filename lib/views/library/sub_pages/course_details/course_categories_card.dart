import 'package:custom_widgets_toolkit/custom_widgets_toolkit.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:iconsax_flutter/iconsax_flutter.dart';
import 'package:slides_sync/app/models/app_ui_model.dart';
import 'package:slides_sync/use_cases/library/library_ui_funcs.dart';

class CourseCategoriesCard extends ConsumerWidget {
  final bool isDarkMode;
  final String title;
  final IconData icon;
  final void Function() onTap;
  const CourseCategoriesCard({super.key, required this.isDarkMode, required this.title, required this.onTap, this.icon = Iconsax.note});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    return InkWell(
      borderRadius: BorderRadius.circular(12),
      onTap: onTap,
      child: Container(
        padding: EdgeInsets.all(12),
        decoration: LibraryUiFuncs.getBoxDecorationStyle(isDarkMode),
        child: Row(
          children: [
            CircleAvatar(child: Icon(icon)),
            ConstantSizing.rowSpacingMedium,
            Expanded(child: CustomText(title, fontSize: 14)),
            CustomText("15", fontSize: 10, color: Colors.grey,),
          ],
        ),
      ),
    );
  }
}
