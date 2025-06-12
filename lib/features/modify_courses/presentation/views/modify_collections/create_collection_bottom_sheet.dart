import 'dart:developer';

import 'package:custom_widgets_toolkit/custom_widgets_toolkit.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:iconsax_flutter/iconsax_flutter.dart';
import 'package:slides_sync/core/utils/ui_utils.dart';
import 'package:slides_sync/data/models/course_model/course_model.dart';
import 'package:slides_sync/data/repos/course_repo.dart';
import 'package:slides_sync/shared/styles/app_ui_context.dart';

class CreateCollectionBottomSheet extends ConsumerStatefulWidget {
  final int courseDbId;
  const CreateCollectionBottomSheet({super.key, required this.courseDbId});

  @override
  ConsumerState<ConsumerStatefulWidget> createState() => _CreateCollectionBottomSheetState();
}

class _CreateCollectionBottomSheetState extends ConsumerState<CreateCollectionBottomSheet> {
  late final FocusNode focusNode;
  @override
  void initState() {
    super.initState();
    focusNode = FocusNode();
    WidgetsBinding.instance.addPostFrameCallback((_) => focusNode.requestFocus());
  }

  @override
  void dispose() {
    focusNode.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Stack(
      children: [
        Positioned.fill(child: GestureDetector(onTap: () => CustomDialog.hide(context))),
        Align(
          alignment: Alignment.bottomCenter,
          child: Container(
            margin: EdgeInsets.only(bottom: context.bottomPadding + context.viewInsets.bottom),
            padding: EdgeInsets.only(left: 16.0, right: 16.0, top: 16.0, bottom: 4.0),
            color: context.scaffoldBackgroundColor,
            child: Column(
              mainAxisSize: MainAxisSize.min,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Padding(
                  padding: const EdgeInsets.only(left: 12.0),
                  child: CustomText("New Collection", fontSize: 13, color: Colors.deepPurple, fontWeight: FontWeight.bold),
                ),
                ConstantSizing.columnSpacingSmall,
                CustomTextfield(
                  autoDispose: false,
                  hint: "Enter a Collection name",
                  focusNode: focusNode,
                  onTapOutside: () {},
                  onSubmitted: (text) async {
                    if (text.isNotEmpty && text.length > 4 && text.length < 256) {
                      try {
                        final CourseModel? courseModel = await CourseRepo.getCourseById(widget.courseDbId);
                        if (courseModel == null) {
                          if (context.mounted) CustomDialog.hide(context);
                          return;
                        }
                        CourseRepo.addCourse(courseModel.copyWith(subCollections: [
                          CourseSubCollection.create(collectionTitle: text),
                          ...courseModel.subCollections,
                        ]));
                        if (context.mounted) {
                          CustomDialog.hide(context);
                          await UiUtils.showFlushBar(context, msg: "Added $text to Collections");
                        }
                      } catch (e) {
                        log("$e");
                        if (context.mounted) {
                          CustomDialog.hide(context);
                          await UiUtils.showFlushBar(context, msg: "An error occured while adding to collections");
                        }
                      }
                    }
                  },
                  inputContentPadding: EdgeInsets.symmetric(horizontal: 12.0),
                  inputTextStyle: TextStyle(fontSize: 15),
                  backgroundColor: Colors.transparent,
                  border: UnderlineInputBorder(borderSide: BorderSide(color: Colors.deepPurple)),
                  alwaysShowSuffixIcon: true,
                  suffixIcon: Padding(
                    padding: const EdgeInsets.only(left: 8.0, right: 10.0),
                    child: CustomElevatedButton(
                      onClick: () {},
                      backgroundColor: Colors.deepPurple,
                      contentPadding: EdgeInsets.all(2.0),
                      shape: CircleBorder(),
                      child: Icon(Iconsax.add_circle, size: 20, color: context.isDarkMode ? Colors.white : Colors.white),
                    ),
                  ),
                ),
                ConstantSizing.columnSpacing(4.0),
              ],
            ),
          ),
        ),
      ],
    );
  }
}
