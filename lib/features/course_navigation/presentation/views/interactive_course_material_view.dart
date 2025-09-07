import 'dart:io';
import 'dart:ui';

import 'package:custom_widgets_toolkit/custom_widgets_toolkit.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:iconsax_flutter/iconsax_flutter.dart';
import 'package:slides_sync/domain/models/file_details.dart';
import 'package:slides_sync/core/utils/ui_utils.dart';
import 'package:slides_sync/domain/models/course_model/sub/course_collection.dart';
import 'package:slides_sync/shared/helpers/extension_helper.dart';
import 'package:slides_sync/shared/styles/colors.dart';

class InteractiveCourseMaterialView extends ConsumerWidget {
  final CourseCollection collection;
  const InteractiveCourseMaterialView({super.key, required this.collection});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final double boxDimension =
        context.deviceHeight > context.deviceWidth ? context.deviceWidth.clamp(120, 250) : context.deviceHeight.clamp(120, 250);

    return AnnotatedRegion(
      value: UiUtils.getSystemUiOverlayStyle(AppColors.backgroundColor(context).withValues(alpha: 0.4), context.isDarkMode),
      child: Scaffold(
        backgroundColor: AppColors.backgroundColor(context).withValues(alpha: 0.4),
        body: BackdropFilter(
          filter: ImageFilter.blur(sigmaX: 4, sigmaY: 4),
          child: Column(
            children: [
              ConstantSizing.columnSpacing(kToolbarHeight + context.topPadding),
              CustomText(
                collection.collectionTitle,
                fontWeight: FontWeight.bold,
                fontSize: 16,
                color: ref.theme.onBackground,
              ),
              Expanded(
                child: Center(
                  child: CupertinoPicker(
                    itemExtent: boxDimension,
                    selectionOverlay: null,
                    offAxisFraction: -0.1,
                    onSelectedItemChanged: (index) async {},
                    children: List.generate(4, (index) {
                      return InkWell(
                        onTap: () {
                          // Navigator.of(context).push(
                          //   PageAnimation.pageRouteBuilder(
                          //     DocumentViewer(),
                          //     type: TransitionType.rightToLeft,
                          //     duration: Durations.extralong3,
                          //     opaque: false,
                          //     reverseDuration: Durations.medium1,
                          //     curve: CustomCurves.snappySpring,
                          //   ),
                          // );
                        },
                        child: Container(
                          width: boxDimension,
                          height: boxDimension,
                          clipBehavior: Clip.antiAlias,
                          decoration: BoxDecoration(
                            color: ref.theme.altBackgroundPrimary,
                            borderRadius: BorderRadius.circular(24),
                          ),
                          child: Stack(
                            children: [
                              Positioned.fill(
                                child: Opacity(
                                  opacity: 0.1,
                                  child: Image.file(
                                    File(collection.contents.isEmpty ? '' : collection.contents.first.path.filePath),
                                    fit: BoxFit.cover,
                                  ),
                                ),
                              ),
                              Positioned.fill(
                                child: BackdropFilter(filter: ImageFilter.blur(sigmaX: 4, sigmaY: 4), child: SizedBox.expand()),
                              ),
                            ],
                          ),
                        ),
                      );
                    }),
                  ),
                ),
              ),

              Row(
                children: [
                  ConstantSizing.rowSpacing(12),
                  CustomElevatedButton(
                    shape: const CircleBorder(),
                    pixelHeight: 56,
                    pixelWidth: 56,
                    child: Icon(Iconsax.edit_copy, color: ref.theme.onBackground),
                  ),
                ],
              ),

              ConstantSizing.columnSpacing(kToolbarHeight / 2 + context.bottomPadding),
            ],
          ),
        ),
      ),
    );
  }
}
