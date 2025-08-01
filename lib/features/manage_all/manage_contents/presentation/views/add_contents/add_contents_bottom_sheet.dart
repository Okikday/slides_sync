import 'package:custom_widgets_toolkit/custom_widgets_toolkit.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter_animate/flutter_animate.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:iconsax_flutter/iconsax_flutter.dart';
import 'package:slides_sync/data/models/course_model/course.dart';
import 'package:slides_sync/features/manage_all/manage_contents/usecases/actions/add_contents_actions.dart';
import 'package:slides_sync/shared/components/dialogs/app_action_dialog.dart';
import 'package:slides_sync/shared/helpers/extension_helper.dart';
import 'package:slides_sync/shared/styles/colors.dart';

class AddContentsBottomSheet extends ConsumerStatefulWidget {
  final CourseCollection collection;
  const AddContentsBottomSheet({super.key, required this.collection});

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
            child: AddContentCardSection(fixedExtentScrollController: fixedExtentScrollController, collection: widget.collection),
          ),
        ),
      ],
    );
  }
}

class AddContentCardSection extends StatelessWidget {
  const AddContentCardSection({super.key, required this.fixedExtentScrollController, required this.collection});

  final FixedExtentScrollController fixedExtentScrollController;
  final CourseCollection collection;

  @override
  Widget build(BuildContext context) {
    final Map<int, CourseContentType> typeMap = {0: CourseContentType.unknown, 1: CourseContentType.image, 2: CourseContentType.document};
    return Container(
      width: context.deviceWidth,
      constraints: BoxConstraints(maxWidth: 500, maxHeight: 500),
      margin: EdgeInsets.only(bottom: context.bottomPadding + context.viewInsets.bottom, left: 24, right: 24),
      padding: EdgeInsets.only(bottom: 4.0),
      decoration: BoxDecoration(
        color: AppColors.bgBlendColor(context).withValues(alpha: 0.8),
        borderRadius: BorderRadius.circular(24),
        border: Border.fromBorderSide(BorderSide(color: context.theme.colorScheme.secondary.withAlpha(20))),
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
              color: AppColors.primary(context),
            ).animate().fadeIn().slideX(begin: -0.05),
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
                  onSelectedItemChanged: (index) async {},
                  children:
                      [
                        BuildPlainActionButton(
                          title: "Document",
                          icon: Icon(Iconsax.document, color: context.theme.primaryColor),
                          onTap:
                              () =>
                                  AddContentsActions.onClickToAddContent(context, collection: collection, type: typeMap[2] ?? typeMap[0]!),
                        ),

                        BuildPlainActionButton(
                          title: "Auto",
                          icon: Icon(Iconsax.autobrightness, color: context.theme.primaryColor),
                          onTap:
                              () =>
                                  AddContentsActions.onClickToAddContent(context, collection: collection, type: typeMap[0] ?? typeMap[0]!),
                        ),

                        BuildPlainActionButton(
                          title: "Image",
                          icon: Icon(Iconsax.image, color: context.theme.primaryColor),
                          onTap:
                              () =>
                                  AddContentsActions.onClickToAddContent(context, collection: collection, type: typeMap[1] ?? typeMap[0]!),
                        ),
                      ].map((e) => Padding(padding: EdgeInsets.symmetric(horizontal: 12), child: e)).toList(),
                ),
              ).animate().fadeIn().scaleX(begin: 0.95),

              Padding(
                padding: const EdgeInsets.only(left: 16, right: 16, bottom: 8),
                child: Row(
                  spacing: 8.0,
                  children: [
                    Flexible(
                      child: CustomElevatedButton(
                        backgroundColor: context.theme.colorScheme.onSurface,
                        pixelHeight: 40,
                        borderRadius: 16,
                        child: Row(
                          spacing: 4.0,
                          children: [
                            Icon(Iconsax.note_add, color: context.theme.colorScheme.onTertiary),
                            CustomText("Add note", color: AppColors.primaryText(context)),
                          ],
                        ),
                      ),
                    ),
                    Flexible(
                      child: CustomElevatedButton(
                        backgroundColor: context.theme.colorScheme.onSurface,
                        pixelHeight: 40,
                        borderRadius: 16,
                        child: Row(
                          spacing: 4.0,
                          children: [
                            Icon(Iconsax.link_circle, color: context.theme.colorScheme.onTertiary),
                            CustomText("Add link", color: AppColors.primaryText(context)),
                          ],
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
    );
  }
}
