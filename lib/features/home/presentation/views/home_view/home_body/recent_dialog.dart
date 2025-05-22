import 'package:custom_widgets_toolkit/custom_widgets_toolkit.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:heroine/heroine.dart';
import 'package:iconsax_flutter/iconsax_flutter.dart';

import 'package:slides_sync/core/models/app_ui_model.dart';
import 'package:slides_sync/features/home/presentation/viewmodels/home_vm/models/recent_dialog_model.dart';
import 'package:slides_sync/shared/styles/app_ui_context.dart';

class RecentDialog extends ConsumerStatefulWidget {
  final Color scaffoldBgColor;
  final String heroTag;
  final RecentDialogModel recentDialogModel;

  const RecentDialog({
    super.key,
    required this.scaffoldBgColor,
    required this.heroTag,
    required this.recentDialogModel,
  });

  @override
  ConsumerState createState() => _RecentDialogState();
}

class _RecentDialogState extends ConsumerState<RecentDialog> {
  late final ScrollController _scrollController;
  @override
  void initState() {
    super.initState();
    _scrollController = ScrollController();
  }

  @override
  void dispose() {
    _scrollController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () => Navigator.of(context).pop(),
      child: ColoredBox(
        color: Colors.transparent,
        child: Center(
          child: GestureDetector(
            onTap: () {},
            child: Heroine(
              tag: widget.heroTag,
              child: FittedBox(
                child: Container(
                  clipBehavior: Clip.hardEdge,
                  padding: EdgeInsets.only(right: 4),
                  margin: EdgeInsets.symmetric(
                    horizontal: 32,
                    vertical: context.deviceHeight > context.deviceWidth ? 0 : 32,
                  ),
                  width:
                      context.deviceHeight > context.deviceWidth
                          ? context.deviceWidth
                          : context.deviceWidth * 0.5,
                  height:
                      context.deviceHeight > context.deviceWidth
                          ? (context.deviceWidth * 1.25) - 64
                          : context.deviceHeight * 0.9,
                  decoration: BoxDecoration(
                    color: widget.scaffoldBgColor,
                    borderRadius: BorderRadius.circular(24),
                    border: Border.all(color: Colors.blueAccent.withAlpha(50)),
                  ),
                  child: ScrollbarTheme(
                    data: ScrollbarThemeData(mainAxisMargin: 10, thumbColor: WidgetStatePropertyAll(Colors.grey.withAlpha(60))),
                    child: Scrollbar(
                      // thumbVisibility: true,
                      radius: Radius.circular(12),
                      controller: _scrollController,
                      thickness: 8,
                      interactive: true,
                      child: Padding(
                        padding: EdgeInsets.only(left: 16, right: 20),
                        child: SingleChildScrollView(
                          primary: false,
                          controller: _scrollController,
                          physics: BouncingScrollPhysics(),
                          child: Column(
                            children: [
                              ConstantSizing.columnSpacing(24),

                              Row(
                                children: [
                                  Container(
                                    width: 100,
                                    height: 100,
                                    margin: EdgeInsets.only(left: 12),
                                    decoration: BoxDecoration(
                                      color: Colors.lightBlueAccent.withAlpha(40),
                                      borderRadius: BorderRadius.circular(16),
                                    ),
                                  ),
                                  Expanded(
                                    child: Row(
                                      mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                                      children: [
                                        CustomElevatedButton(
                                          backgroundColor: Colors.lightBlueAccent.withAlpha(40),
                                          shape: CircleBorder(),
                                          contentPadding: EdgeInsets.all(12),
                                          child: Icon(Iconsax.star_copy, size: 32, color: CustomText("").effectiveStyle(context).color),
                                        ),
                                        CustomElevatedButton(
                                          backgroundColor: Colors.lightBlueAccent.withAlpha(40),
                                          shape: CircleBorder(),
                                          contentPadding: EdgeInsets.all(12),
                                          child: Icon(Iconsax.note_add_copy, size: 32, color: CustomText("").effectiveStyle(context).color),
                                        ),
                                      ],
                                    ),
                                  ),
                                ],
                              ),


                              ConstantSizing.columnSpacingLarge,

                              Align(
                                alignment: Alignment.centerLeft,
                                child: Padding(
                                  padding: const EdgeInsets.only(left: 12),
                                  child: Column(
                                    crossAxisAlignment: CrossAxisAlignment.start,
                                    children: [
                                      CustomText(widget.recentDialogModel.title, fontSize: 18, fontWeight: FontWeight.bold,),
                                      ConstantSizing.columnSpacingSmall,
                                      CustomText("Slide 10 - 20 pages", color: Colors.grey,)
                                    ],
                                  ),
                                ),
                              ),

                              if(widget.recentDialogModel.description.isNotEmpty) ConstantSizing.columnSpacingMedium,

                              if(widget.recentDialogModel.description.isNotEmpty) Divider(color: Colors.blueGrey.withAlpha(40)),

                              if(widget.recentDialogModel.description.isNotEmpty) Align(
                                alignment: Alignment.centerLeft,
                                child: Padding(
                                  padding: const EdgeInsets.only(left: 12, top: 8.0),
                                  child: Column(
                                    crossAxisAlignment: CrossAxisAlignment.start,
                                    children: [
                                      CustomText("Description", fontSize: 16, fontWeight: FontWeight.bold,),
                                      ConstantSizing.columnSpacingSmall,
                                      CustomText(widget.recentDialogModel.description, color: Colors.grey,)
                                    ],
                                  ),
                                ),
                              ),

                              ConstantSizing.columnSpacingMedium,

                              Divider(color: Colors.blueGrey.withAlpha(40)),

                              CustomElevatedButton(
                                onClick: () {},
                                contentPadding: EdgeInsets.only(left: 16, right: 12, top: 12, bottom: 12),
                                overlayColor: Colors.lightBlueAccent.withAlpha(40),
                                borderRadius: 0,
                                backgroundColor: Colors.transparent,

                                child: Row(
                                  spacing: 8.0,
                                  children: [
                                    Icon(Icons.share_outlined, size: 24, color: CustomText("").effectiveStyle(context).color),
                                    Expanded(child: CustomText("Share", fontSize: 16)),
                                  ],
                                ),
                              ),

                              Divider(color: Colors.blueGrey.withAlpha(40)),

                              CustomElevatedButton(
                                onClick: () {},
                                contentPadding: EdgeInsets.only(left: 16, right: 12, top: 12, bottom: 12),
                                overlayColor: Colors.redAccent.withAlpha(40),
                                borderRadius: 0,
                                backgroundColor: Colors.transparent,
                                child: Row(
                                  spacing: 8.0,
                                  children: [
                                    Icon(Iconsax.trash_copy, size: 24, color: Colors.redAccent),
                                    Expanded(child: CustomText("Delete", fontSize: 16, color: Colors.redAccent)),
                                  ],
                                ),
                              ),

                              Divider(color: Colors.blueGrey.withAlpha(40)),

                              ConstantSizing.columnSpacing(24),
                            ],
                          ),
                        ),
                      ),
                    ),
                  ),
                ),
              ),
            ),
          ),
        ),
      ),
    );
  }
}

