import 'dart:developer';
import 'dart:io';

import 'package:custom_widgets_toolkit/custom_widgets_toolkit.dart';
import 'package:flutter/material.dart';
import 'package:flutter_animate/flutter_animate.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:iconsax_flutter/iconsax_flutter.dart';
import 'package:image_picker/image_picker.dart';
import 'package:slides_sync/core/utils/ui_utils.dart';
import 'package:slides_sync/shared/styles/app_ui_context.dart';

class AddImageAvatar extends ConsumerWidget {
  final StateProvider<String?> courseImagePathProvider;
  const AddImageAvatar({super.key, required this.courseImagePathProvider});

  @override
  Widget build(BuildContext context, WidgetRef ref) {

    final String? courseImagePath = ref.watch(courseImagePathProvider);
    final double imgRadius = context.deviceHeight > context.deviceWidth ? context.deviceWidth * 0.4 : context.deviceHeight * 0.4;

    return Container(
      width: imgRadius,
      height: imgRadius,
      clipBehavior: Clip.hardEdge,
          decoration: BoxDecoration(shape: BoxShape.circle, color: Colors.lightBlueAccent.withAlpha(40)),
          child: InkWell(
            customBorder: CircleBorder(),
            onTap: () async {
              LoadingDialog.showLoadingDialog(
                context,
                msg: "Just a moment...",
                backgroundColor: context.scaffoldBackgroundColor.withAlpha(200),
              );
              ImagePicker imagePicker = ImagePicker();
              final XFile? pickedImage = await imagePicker.pickImage(source: ImageSource.gallery);
              if (context.mounted) LoadingDialog.hideLoadingDialog(context);
              if (pickedImage == null) return;

              ref.read(courseImagePathProvider.notifier).update((cb)=> pickedImage.path);

              if (context.mounted) UiUtils.showFlushBar(context, msg: "Selected course image!");

              // await FileUtils.storeFile(file: File(pickedImage.path), path: "path");
            },
            onLongPress: () {
              final currentPathNotifier = ref.read(courseImagePathProvider.notifier);
              if(courseImagePath == null){
                UiUtils.showFlushBar(context, msg: "No course image was selected!");
              }
              else{
                currentPathNotifier.update((cb) => null);
                UiUtils.showFlushBar(context, msg: "Removed selected image!");
              }
            },
            child: courseImagePath == null ? Icon(Iconsax.folder_add, size: 72) : Image.file(File(courseImagePath), fit: BoxFit.cover, width: imgRadius, height: imgRadius,)
                .animate()
                .scale(
                  begin: Offset(0.4, 0.4),
                  duration: Durations.extralong4,
                  delay: Durations.medium1,
                  curve: CustomCurves.bouncySpring,
                )
                .moveY(begin: -20, duration: Durations.extralong4, delay: Durations.medium1),
          ),
        )
        .animate()
        .moveY(begin: -20, duration: Durations.medium2, delay: Durations.medium1, curve: CustomCurves.decelerate)
        .fadeIn(begin: 0.3, duration: Durations.medium2, delay: Durations.medium1, curve: CustomCurves.decelerate);
  }
}
