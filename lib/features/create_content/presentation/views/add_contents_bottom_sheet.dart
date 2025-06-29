import 'package:custom_widgets_toolkit/custom_widgets_toolkit.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_animate/flutter_animate.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:iconsax_flutter/iconsax_flutter.dart';
import 'package:slides_sync/core/utils/ui_utils.dart';
import 'package:slides_sync/data/models/course_model/course_model.dart';
import 'package:slides_sync/features/create_content/domain/usecases/add_contents_uc/add_contents_uc.dart';
import 'package:slides_sync/features/create_content/domain/usecases/add_contents_uc/select_contents_uc.dart';
import 'package:slides_sync/routes/routes.dart';
import 'package:slides_sync/shared/components/dialogs/app_action_dialog.dart';
import 'package:slides_sync/shared/helpers/extension_helper.dart';

class AddContentsBottomSheet extends ConsumerStatefulWidget {
  final CourseSubCollection? collection;
  const AddContentsBottomSheet({super.key, this.collection});

  @override
  ConsumerState<ConsumerStatefulWidget> createState() => _AddContentsBottomSheetState();
}

class _AddContentsBottomSheetState extends ConsumerState<AddContentsBottomSheet> {
  late final FixedExtentScrollController fixedExtentScrollController;
  @override
  void initState() {
    super.initState();
    fixedExtentScrollController = FixedExtentScrollController(initialItem: 1);
  }

  @override
  void dispose() {
    fixedExtentScrollController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Stack(
          children: [
            Positioned.fill(child: GestureDetector(onTap: () => CustomDialog.hide(context))),
            Positioned(
              left: 0,
              right: 0,
              bottom: 8,
              child: Align(
                alignment: Alignment.bottomCenter,
                child: Container(
                  width: context.deviceWidth,
                  constraints: BoxConstraints(maxWidth: 500, maxHeight: 500),
                  margin: EdgeInsets.only(bottom: context.bottomPadding + context.viewInsets.bottom, left: 24, right: 24),
                  padding: EdgeInsets.only(bottom: 4.0),
                  decoration: BoxDecoration(
                    color: context.scaffoldBackgroundColor,
                    borderRadius: BorderRadius.circular(24),
                    border: Border.fromBorderSide(BorderSide(color: Colors.lightBlueAccent.withAlpha(20))),
                  ),
                  child: Column(
                    mainAxisSize: MainAxisSize.min,
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      ConstantSizing.columnSpacing(4.0),
                      Padding(
                        padding: const EdgeInsets.only(left: 16.0, right: 16.0, top: 16.0),
                        child: CustomText("What kind of content do you want to add?", fontSize: 16, fontWeight: FontWeight.bold),
                      ),
                      // ConstantSizing.columnSpacingSmall,
                      Column(
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          SizedBox(
                            height: 200,
                            child: CupertinoPicker(
                              itemExtent: 60,
                              offAxisFraction: -0.1,
                              scrollController: fixedExtentScrollController,
                              onSelectedItemChanged: (index) async {
                                final Map<int, ContentType> typeMap = {
                                  0: ContentType.auto,
                                  1: ContentType.media,
                                  2: ContentType.document,
                                  3: ContentType.audio,
                                };
                                if (widget.collection == null) {
                                  await UiUtils.showFlushBar(context, msg: "Successfully added course contents!");
                                  return;
                                }
                                await AddContentsUc.addToCollection(
                                  rootNavigatorKey.currentContext!,
                                  collection: widget.collection!,
                                  type: typeMap[index] ?? typeMap[0]!,
                                );
                                await UiUtils.showFlushBar(rootNavigatorKey.currentContext!, msg: "Successfully added course contents!");
                              },
                              children: [
                                // BuildPlainActionButton(title: "Link", icon: Icon(Iconsax.link, color: context.theme.primaryColor)),
                                BuildPlainActionButton(
                                  title: "Auto",
                                  icon: Icon(Iconsax.autobrightness, color: context.theme.primaryColor),
                                ),
                                BuildPlainActionButton(title: "Media", icon: Icon(Iconsax.image, color: context.theme.primaryColor)),
                                BuildPlainActionButton(title: "Document", icon: Icon(Iconsax.document, color: context.theme.primaryColor)),
                                BuildPlainActionButton(
                                  title: "Audio",
                                  icon: Icon(Iconsax.autobrightness, color: context.theme.primaryColor),
                                ),
                              ],
                            ),
                          ),

                          Padding(
                            padding: const EdgeInsets.only(left: 16, right: 16, bottom: 8),
                            child: Row(
                              spacing: 8.0,
                              children: [
                                Flexible(
                                  child: CustomElevatedButton(
                                    backgroundColor: context.theme.cardColor.withAlpha(100),
                                    pixelHeight: 40,
                                    child: Row(
                                      spacing: 4.0,
                                      children: [Icon(Iconsax.note_add, color: context.theme.cardColor), CustomText("Add note")],
                                    ),
                                  ),
                                ),
                                Flexible(
                                  child: CustomElevatedButton(
                                    backgroundColor: context.theme.cardColor.withAlpha(100),
                                    pixelHeight: 40,
                                    child: Row(
                                      spacing: 4.0,
                                      children: [Icon(Iconsax.link_circle, color: context.theme.cardColor), CustomText("Add link(s)")],
                                    ),
                                  ),
                                ),
                              ],
                            ),
                          ),
                        ],
                      ),

                      // BuildPlainActionButton(title: "Auto", icon: Icon(Iconsax.safe_home), onTap: (){}),
                      // BuildPlainActionButton(title: "Visual Media", icon: Icon(Iconsax.safe_home), onTap: (){}),
                      // BuildPlainActionButton(title: "Document", icon: Icon(Iconsax.safe_home), onTap: (){}),
                      // BuildPlainActionButton(title: "Audio", icon: Icon(Iconsax.safe_home), onTap: (){})
                    ],
                  ),
                ),
              ),
            ),
          ],
        )
        .animate()
        .flipV(begin: -.2, end: 0, duration: Durations.medium4, curve: CustomCurves.bouncySpring)
        .scaleY(alignment: Alignment.bottomCenter, begin: 0, duration: Durations.medium4, curve: CustomCurves.bouncySpring)
        .fadeIn();
  }
}
