import 'package:custom_widgets_toolkit/custom_widgets_toolkit.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:heroine/heroine.dart';
import 'package:iconsax_flutter/iconsax_flutter.dart';
import 'package:slides_sync/core/models/file_details.dart';

import 'package:slides_sync/features/tab_home/presentation/viewmodels/recent_dialog_model.dart';
import 'package:slides_sync/shared/components/dialogs/app_action_dialog.dart';
import 'package:slides_sync/shared/helpers/extension_helper.dart';
import 'package:slides_sync/shared/widgets/build_image_path_widget.dart';

class RecentDialog extends ConsumerStatefulWidget {
  final String heroTag;
  final RecentDialogModel recentDialogModel;

  const RecentDialog({super.key, required this.heroTag, required this.recentDialogModel});

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
    final Color? currThemeColor = CustomText("").effectiveStyle(context).color;
    var divider = Divider(color: Colors.blueGrey.withAlpha(40), height: 0);
    return GestureDetector(
      onTap: () => Navigator.of(context).pop(),
      child: ColoredBox(
        color: Colors.transparent,
        child: Center(
          child: GestureDetector(
            onTap: () {},
            child: Heroine(
              tag: widget.heroTag,
              spring: Spring.defaultIOS.copyWith(durationSeconds: 0.35),
              child: Container(
                clipBehavior: Clip.hardEdge,
                margin: EdgeInsets.symmetric(horizontal: 32, vertical: context.deviceHeight > context.deviceWidth ? 0 : 32),
                width: context.deviceHeight > context.deviceWidth ? context.deviceWidth : context.deviceWidth * 0.5,
                height: context.deviceHeight > context.deviceWidth ? (context.deviceWidth * 1.25) - 64 : context.deviceHeight * 0.9,
                constraints: BoxConstraints(maxHeight: 320, maxWidth: 320),
                decoration: BoxDecoration(
                  color: context.scaffoldBackgroundColor,
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
                    child: SingleChildScrollView(
                      primary: false,
                      controller: _scrollController,
                      physics: BouncingScrollPhysics(),
                      child: Column(
                        children: [
                          ConstantSizing.columnSpacing(24),

                          Padding(
                            padding: const EdgeInsets.symmetric(horizontal: 12.0),
                            child: Row(
                              children: [
                                Container(
                                  width: 80,
                                  height: 80,
                                  margin: EdgeInsets.only(left: 12),
                                  decoration: BoxDecoration(
                                    color: Colors.lightBlueAccent.withAlpha(40),
                                    borderRadius: BorderRadius.circular(16),
                                  ),
                                  child: BuildImagePathWidget(fileDetails: FileDetails()),
                                ),
                                Expanded(
                                  child: Row(
                                    mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                                    children: [
                                      CustomElevatedButton(
                                        backgroundColor: Colors.lightBlueAccent.withAlpha(40),
                                        shape: CircleBorder(),
                                        contentPadding: EdgeInsets.all(12),
                                        child: Icon(Iconsax.star_copy, size: 26, color: currThemeColor),
                                      ),
                                      CustomElevatedButton(
                                        backgroundColor: Colors.lightBlueAccent.withAlpha(40),
                                        shape: CircleBorder(),
                                        contentPadding: EdgeInsets.all(12),
                                        child: Icon(Iconsax.note_add_copy, size: 26, color: currThemeColor),
                                      ),
                                    ],
                                  ),
                                ),
                              ],
                            ),
                          ),

                          ConstantSizing.columnSpacingLarge,

                          Align(
                            alignment: Alignment.centerLeft,
                            child: Padding(
                              padding: const EdgeInsets.only(left: 24.0, right: 12.0),
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  CustomText(widget.recentDialogModel.title, fontSize: 17, fontWeight: FontWeight.bold),
                                  ConstantSizing.columnSpacingSmall,
                                  CustomText("Short detail", fontSize: 12.0, color: Colors.grey),
                                ],
                              ),
                            ),
                          ),

                          if (widget.recentDialogModel.description.isNotEmpty) ConstantSizing.columnSpacingSmall,

                          if (widget.recentDialogModel.description.isNotEmpty)
                            Padding(
                              padding: const EdgeInsets.symmetric(horizontal: 12.0),
                              child: Divider(color: Colors.blueGrey.withAlpha(40)),
                            ),

                          if (widget.recentDialogModel.description.isNotEmpty)
                            Align(
                              alignment: Alignment.centerLeft,
                              child: Padding(
                                padding: const EdgeInsets.only(left: 24, top: 8.0, right: 12.0),
                                child: Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    CustomText("Description", fontSize: 15, fontWeight: FontWeight.bold),
                                    ConstantSizing.columnSpacingSmall,
                                    CustomText(
                                      widget.recentDialogModel.description
                                          .substring(0, widget.recentDialogModel.description.length.clamp(0, 128))
                                          .padRight(3, "."),
                                      fontSize: 13,
                                      color: Colors.grey,
                                    ),
                                  ],
                                ),
                              ),
                            ),

                          ConstantSizing.columnSpacingMedium,

                          Column(
                            mainAxisSize: MainAxisSize.min,
                            children: [

                              divider,

                              BuildPlainActionButton(
                                title: "Continue reading",
                                icon: Icon(Iconsax.play_copy, size: 24, color: currThemeColor),
                                textStyle: TextStyle(fontSize: 16, color: currThemeColor),
                                onTap: () {},
                              ),

                              divider,

                              BuildPlainActionButton(
                                title: "Share",
                                icon: Icon(Icons.share_outlined, size: 24, color: currThemeColor),
                                textStyle: TextStyle(fontSize: 16, color: currThemeColor),
                                onTap: () {},
                              ),

                              divider,

                              BuildPlainActionButton(
                                title: "Remove from recents",
                                icon: Icon(Iconsax.box_remove_copy, size: 24, color: Colors.redAccent),
                                textStyle: TextStyle(fontSize: 16, color: currThemeColor),
                                onTap: () {},
                              ),

                              // BuildPlainActionButton(
                              //   title: "Delete",
                              //   icon: Icon(Iconsax.trash_copy, size: 24, color: Colors.redAccent),
                              //   textStyle: TextStyle(fontSize: 16, color: Colors.redAccent),
                              //   onTap: () {},
                              // ),
                              divider,
                            ],
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
    );
  }
}
