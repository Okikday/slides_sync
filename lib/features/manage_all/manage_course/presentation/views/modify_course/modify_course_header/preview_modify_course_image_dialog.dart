import 'package:custom_widgets_toolkit/custom_widgets_toolkit.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:heroine/heroine.dart';
import 'package:iconsax_flutter/iconsax_flutter.dart';
import 'package:slides_sync/domain/models/file_details.dart';
import 'package:slides_sync/shared/helpers/extension_helper.dart';
import 'package:slides_sync/shared/widgets/build_image_path_widget.dart';

class PreviewModifyCourseImageDialog extends ConsumerWidget {
  final String imagePath;
  const PreviewModifyCourseImageDialog({super.key, required this.imagePath});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final double dimension = context.deviceHeight > context.deviceWidth ? context.deviceWidth * 0.75 : context.deviceHeight * 0.75;
    return Padding(
      padding: const EdgeInsets.all(8.0),
      child: Heroine(
        tag: "PreviewModifyCourseImageDialog => $imagePath",
        child: Stack(
          alignment: Alignment.center,
          children: [
            Positioned.fill(child: GestureDetector(onTap: () => CustomDialog.hide(context))),
            Positioned(
              width: dimension > 300 ? 300 : dimension,
              height: dimension > 300 ? 300 : dimension,
              child: BuildImagePathWidget(
                fileDetails: imagePath.fileDetails,
                fit: BoxFit.contain,
                width: dimension,
                fallbackWidget: Icon(
                  Iconsax.document,
                  color:
                      context.isDarkMode
                          ? ref.theme.primaryColor
                          : ref.theme.primaryColor,
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
