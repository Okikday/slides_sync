import 'dart:developer';
import 'dart:ui';

import 'package:custom_widgets_toolkit/custom_widgets_toolkit.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:heroine/heroine.dart';
import 'package:iconsax_flutter/iconsax_flutter.dart';
import 'package:slides_sync/app/models/app_ui_model.dart';


class RecentDialog extends ConsumerStatefulWidget {
  final Color scaffoldBgColor;
  final AppUiModel appUiModel;
  final String heroTag;
  final RecentDialogModel recentDialogModel;


  const RecentDialog({super.key, required this.scaffoldBgColor, required this.appUiModel, required this.heroTag, required this.recentDialogModel});

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
                    vertical: widget.appUiModel.deviceHeight > widget.appUiModel.deviceWidth ? 0 : 32,
                  ),
                  width:
                      widget.appUiModel.deviceHeight > widget.appUiModel.deviceWidth
                          ? widget.appUiModel.deviceWidth
                          : widget.appUiModel.deviceWidth * 0.5,
                  height:
                      widget.appUiModel.deviceHeight > widget.appUiModel.deviceWidth
                          ? (widget.appUiModel.deviceWidth * 1.25) - 64
                          : widget.appUiModel.deviceHeight * 0.9,
                  decoration: BoxDecoration(
                    color: widget.scaffoldBgColor,
                    borderRadius: BorderRadius.circular(24),
                    border: Border.all(color: Colors.blueAccent.withAlpha(50)),
                  ),
                  child: ScrollbarTheme(
                    data: ScrollbarThemeData(
                      mainAxisMargin: 10,
                      thumbColor: WidgetStatePropertyAll(Colors.grey.withAlpha(60)),
                    ),
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
                                          child: Icon(Iconsax.heart_copy, size: 32, color: CustomText("").effectiveStyle(context).color),
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

                              ConstantSizing.columnSpacingMedium,

                              Divider(color: Colors.blueGrey.withAlpha(40)),

                              ConstantSizing.columnSpacingSmall,

                              Align(
                                alignment: Alignment.centerLeft,
                                child: Padding(
                                  padding: const EdgeInsets.only(left: 12),
                                  child: Row(
                                    children: [
                                      Expanded(child: CustomText("Title", fontSize: 15, fontWeight: FontWeight.bold)),
                                      CustomTextButton(
                                        pixelHeight: 28,
                                        borderRadius: 16.0,
                                        contentPadding: EdgeInsets.symmetric(horizontal: 12.0, vertical: 4.0),
                                        backgroundColor: Colors.lightBlueAccent.withAlpha(40),
                                        child: CustomText("pdf", fontWeight: FontWeight.bold, fontSize: 15),
                                      ),
                                    ],
                                  ),
                                ),
                              ),

                              ConstantSizing.columnSpacingMedium,

                              Align(
                                alignment: Alignment.centerLeft,
                                child: Padding(
                                  padding: const EdgeInsets.only(left: 12),
                                  child: CustomText("Introduction to Java Programming"),
                                ),
                              ),

                              ConstantSizing.columnSpacingMedium,

                              Divider(color: Colors.blueGrey.withAlpha(40)),

                              ConstantSizing.columnSpacingSmall,

                              Align(
                                alignment: Alignment.centerLeft,
                                child: Padding(
                                  padding: const EdgeInsets.only(left: 12),
                                  child: CustomText("Tags", fontSize: 15, fontWeight: FontWeight.bold),
                                ),
                              ),

                              ConstantSizing.columnSpacingMedium,

                              Align(
                                alignment: Alignment.centerLeft,
                                child: Padding(
                                  padding: const EdgeInsets.only(left: 12),
                                  child: Wrap(
                                    crossAxisAlignment: WrapCrossAlignment.center,
                                    spacing: 12.0,
                                    children: [
                                      CustomTextButton(
                                        pixelHeight: 28,
                                        borderRadius: 16.0,
                                        contentPadding: EdgeInsets.symmetric(horizontal: 12.0, vertical: 4.0),
                                        backgroundColor: Colors.lightBlueAccent.withAlpha(40),
                                        child: CustomText("none", fontWeight: FontWeight.bold, fontSize: 15),
                                      ),
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

class RecentDialogModel {
  final Widget? imagePreview;
  final bool isStarred;
  final bool hasNote;
  final String title;
  final String fileType;
  final List<String> tags;
  final bool canShare;
  final bool canDelete;
  final void Function()? onLike;
  final void Function()? onNote;
  final void Function()? onShare;
  final void Function()? onDelete;

  RecentDialogModel({
    this.imagePreview,
    required this.isStarred,
    required this.hasNote,
    required this.title,
    required this.fileType,
    required this.tags,
    required this.canShare,
    required this.canDelete,
    this.onShare,
    this.onDelete,
    this.onLike,
    this.onNote,
  });


  RecentDialogModel copyWith({
    Widget? imagePreview,
    bool? isStarred,
    bool? hasNote,
    String? title,
    String? fileType,
    List<String>? tags,
    bool? canShare,
    bool? canDelete,
    void Function()? onLike,
    void Function()? onNote,
    void Function()? onShare,
    void Function()? onDelete,
  }) {
    return RecentDialogModel(
      imagePreview: imagePreview ?? this.imagePreview,
      isStarred: isStarred ?? this.isStarred,
      hasNote: hasNote ?? this.hasNote,
      title: title ?? this.title,
      fileType: fileType ?? this.fileType,
      tags: tags ?? List.from(this.tags),
      canShare: canShare ?? this.canShare,
      canDelete: canDelete ?? this.canDelete,
      onLike: onLike ?? this.onLike,
      onNote: onNote ?? this.onNote,
      onShare: onShare ?? this.onShare,
      onDelete: onDelete ?? this.onDelete,
    );
  }
}
