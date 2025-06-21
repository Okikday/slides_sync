import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

import 'package:custom_widgets_toolkit/custom_widgets_toolkit.dart';
import 'package:flutter_animate/flutter_animate.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:iconsax_flutter/iconsax_flutter.dart';
import 'package:slides_sync/shared/components/dialogs/app_action_dialog.dart';
import 'package:slides_sync/shared/helpers/extension_helper.dart';

class AddContentsFAB extends ConsumerWidget {
  const AddContentsFAB({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    return FloatingActionButton(
      onPressed: () {
        CustomDialog.show(
          context,
          transitionDuration: Durations.short1,
          reverseTransitionDuration: Durations.short1,
          blurSigma: Offset(2, 2),
          child: AddContentsBottomSheet(),
        );
      },
      shape: CircleBorder(),
      child: Icon(Icons.add),
    );
  }
}

class AddContentsBottomSheet extends ConsumerStatefulWidget {
  const AddContentsBottomSheet({super.key});

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
                    child: CustomText(
                      "What kind of content do you want to add?",
                      fontSize: 16,
                      fontWeight: FontWeight.bold,
                      color: Colors.deepPurpleAccent,
                    ),
                  ),
                  // ConstantSizing.columnSpacingSmall,
                  Column(
                    children: [
                      SizedBox(
                        height: 200,
                        child: CupertinoPicker(
                          itemExtent: 60,
                          scrollController: fixedExtentScrollController,
                          onSelectedItemChanged: (index) {},
                          children: [
                            BuildPlainActionButton(title: "Visual Media", icon: Icon(Iconsax.image, color: Colors.deepPurple,)),
                            BuildPlainActionButton(title: "Auto", icon: Icon(Iconsax.autobrightness)),
                            BuildPlainActionButton(title: "Document", icon: Icon(Iconsax.document)),
                            BuildPlainActionButton(title: "Audio", icon: Icon(Iconsax.audio_square)),
                          ],
                        ),
                      ),

                      Padding(
                        padding: const EdgeInsets.only(left: 16, right: 16, bottom: 8),
                        child: CustomElevatedButton(
                          pixelHeight: 40,
                          backgroundColor: Colors.deepPurple,
                          contentPadding: EdgeInsets.symmetric(horizontal: 48, vertical: 8),
                          child: CustomText("Pick", fontWeight: FontWeight.bold,),
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
    ).animate().scaleY(alignment: Alignment.bottomCenter, duration: Durations.short4, curve: CustomCurves.defaultIosSpring).fadeIn();
  }
}
