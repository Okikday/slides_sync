import 'dart:developer';
import 'dart:ui';

import 'package:custom_widgets_toolkit/custom_widgets_toolkit.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter_animate/flutter_animate.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:iconsax_flutter/iconsax_flutter.dart';
import 'package:slides_sync/core/utils/result.dart';
import 'package:slides_sync/core/utils/ui_utils.dart';
import 'package:slides_sync/domain/models/course_model/course.dart';
import 'package:slides_sync/features/manage_all/manage_contents/presentation/providers/add_contents_bs_provider.dart';
import 'package:slides_sync/features/manage_all/manage_contents/presentation/views/add_contents/add_from_clipboard_dialog/add_from_clipboard_dialog.dart';
import 'package:slides_sync/features/manage_all/manage_contents/presentation/views/add_contents/add_link_bottom_sheet.dart';
import 'package:slides_sync/features/manage_all/manage_contents/presentation/actions/add_contents_actions.dart';
import 'package:slides_sync/shared/components/dialogs/app_action_dialog.dart';
import 'package:slides_sync/shared/helpers/extension_helper.dart';

class AddContentsBottomSheet extends ConsumerStatefulWidget {
  final CourseCollection collection;
  const AddContentsBottomSheet({super.key, required this.collection});

  @override
  ConsumerState<ConsumerStatefulWidget> createState() => _AddContentsBottomSheetState();
}

class _AddContentsBottomSheetState extends ConsumerState<AddContentsBottomSheet> {
  late final FixedExtentScrollController fixedExtentScrollController;
  bool isScanningClipboard = false;

  @override
  void initState() {
    super.initState();
    fixedExtentScrollController = FixedExtentScrollController(initialItem: 1);
    WidgetsBinding.instance.addPostFrameCallback((_) async {
      if (isScanningClipboard) return;
      isScanningClipboard = true;
      await Result.tryRunAsync(() async {
        if (!mounted) return;

        final lastClipboardDataProvider = ref.read(AddContentsBsProvider.lastClipboardData.notifier);
        final RootIsolateToken? rootIsolateToken = RootIsolateToken.instance;
        if (rootIsolateToken == null) return;
        final newClipboardData = await compute(AddContentsActions.scanClipboardForData, <String, dynamic>{
          'token': rootIsolateToken,
        });

        if (!mounted) return;

        if (lastClipboardDataProvider.state != null) {
          if (AddContentsActions.isDataEqual(
            lastClipboardDataProvider.state!,
            newClipboardData.data,
            newClipboardData.contentType,
          )) {
            return;
          } else {
            if (!mounted) return;
            lastClipboardDataProvider.update((cb) => newClipboardData);
          }
        } else {
          if (!mounted) return;
          lastClipboardDataProvider.update((cb) => newClipboardData);
        }

        if (!mounted) return;
        final overlayEntryProvider = ref.read(AddContentsBsProvider.addFromClipboardOverlayEntry.notifier);

        if (overlayEntryProvider.state != null) return;

        final OverlayEntry addFromClipboardOverlayEntry = OverlayEntry(
          builder: (context) => AddFromClipboardOverlay(clipboardData: newClipboardData),
        );

        if (!mounted) return;
        overlayEntryProvider.update((cb) => addFromClipboardOverlayEntry);

        if (mounted) {
          final OverlayState overlay = Overlay.of(context);
          overlay.insert(addFromClipboardOverlayEntry);
        }
      });
    });
  }

  @override
  void dispose() {
    fixedExtentScrollController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final canPop = ref.watch(AddContentsBsProvider.addFromClipboardOverlayEntry) == null;
    return PopScope(
      canPop: canPop,
      child: Stack(
        children: [
          Positioned.fill(child: GestureDetector(onTap: () => UiUtils.hideDialog(context))),
          Positioned(
            left: 0,
            right: 0,
            bottom: 8,
            child: Align(
              alignment: Alignment.bottomCenter,
              child: AddContentCardSection(
                fixedExtentScrollController: fixedExtentScrollController,
                collection: widget.collection,
              ).animate().scale(
                alignment: Alignment.bottomRight,
                begin: Offset(0.9, 0.6),
                end: Offset(1, 1),
                duration: Durations.extralong1,
                curve: CustomCurves.bouncySpring,
              ),
              // .scaleY(begin: canPop ? 0.8 : 1, end: canPop ? 1 : 0.8),
            ),
          ),
        ],
      ),
    );
  }
}

class AddContentCardSection extends ConsumerWidget {
  const AddContentCardSection({super.key, required this.fixedExtentScrollController, required this.collection});

  final FixedExtentScrollController fixedExtentScrollController;
  final CourseCollection collection;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final Map<int, CourseContentType> typeMap = {
      0: CourseContentType.unknown,
      1: CourseContentType.image,
      2: CourseContentType.document,
    };
    final theme = ref.theme;
    return Container(
      width: context.deviceWidth,
      constraints: BoxConstraints(maxWidth: 400, maxHeight: 340),
      margin: EdgeInsets.only(bottom: context.bottomPadding + context.viewInsets.bottom, left: 20, right: 20),
      padding: EdgeInsets.symmetric(horizontal: 4, vertical: 4),
      clipBehavior: Clip.antiAlias,
      decoration: BoxDecoration(
        color: theme.background,
        borderRadius: BorderRadius.circular(30),
        border: Border.fromBorderSide(BorderSide(color: theme.onBackground.withAlpha(20))),
      ),
      child: BackdropFilter(
        filter: ImageFilter.blur(sigmaX: 2, sigmaY: 2),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Padding(
              padding: const EdgeInsets.only(left: 16.0, right: 16.0, top: 16.0),
              child: CustomText(
                "What kind of content would you like to add?",
                fontSize: 16,
                fontWeight: FontWeight.bold,
                color: theme.onBackground,
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
                            icon: Icon(Iconsax.document, color: theme.primaryColor),
                            onTap:
                                () => AddContentsActions.onClickToAddContent(
                                  ref,
                                  collection: collection,
                                  type: typeMap[2] ?? typeMap[0]!,
                                ),
                          ),

                          BuildPlainActionButton(
                            title: "Auto",
                            icon: Icon(Iconsax.autobrightness, color: theme.primaryColor),
                            onTap:
                                () => AddContentsActions.onClickToAddContent(
                                  ref,
                                  collection: collection,
                                  type: typeMap[0] ?? typeMap[0]!,
                                ),
                          ),

                          BuildPlainActionButton(
                            title: "Image",
                            icon: Icon(Iconsax.image, color: theme.primaryColor),
                            onTap:
                                () => AddContentsActions.onClickToAddContent(
                                  ref,
                                  collection: collection,
                                  type: typeMap[1] ?? typeMap[0]!,
                                ),
                          ),
                        ].map((e) => Padding(padding: EdgeInsets.symmetric(horizontal: 12), child: e)).toList(),
                  ),
                ).animate().fadeIn().scaleX(begin: 0.95),

                Padding(
                  padding: const EdgeInsets.only(left: 16, right: 16, bottom: 8),
                  child: Row(
                    spacing: 8.0,
                    mainAxisAlignment: MainAxisAlignment.end,
                    children: [
                      // Flexible(
                      //   child: CustomElevatedButton(
                      //     onClick: () async {
                      //       // CustomDialog.hide(context);
                      //       // final createdNote = await AddContentsUc.createNote(collection);
                      //       // log("created note: ${createdNote.toString()}");
                      //     },
                      //     backgroundColor: theme.altBackgroundSecondary,
                      //     pixelHeight: 40,
                      //     borderRadius: 16,
                      //     child: Row(
                      //       spacing: 8.0,
                      //       children: [
                      //         Icon(Iconsax.note_add, color: theme.supportingText),
                      //         CustomText("Add note", color: theme.onBackground),
                      //       ],
                      //     ),
                      //   ),
                      // ),
                      Flexible(
                        child: CustomElevatedButton(
                          onClick: () {
                            UiUtils.hideDialog(context);
                            UiUtils.showCustomDialog(
                              context,
                              transitionType: TransitionType.fade,
                              child: AddLinkBottomSheet(collection: collection),
                            );
                          },
                          backgroundColor: theme.altBackgroundPrimary,
                          pixelHeight: 44,
                          borderRadius: 16,
                          child: Padding(
                            padding: const EdgeInsets.symmetric(horizontal: 12),
                            child: Row(
                              spacing: 8.0,
                              mainAxisSize: MainAxisSize.min,
                              mainAxisAlignment: MainAxisAlignment.center,
                              children: [
                                Icon(Iconsax.link_circle, color: theme.supportingText),
                                CustomText("Add link", color: theme.onBackground),
                                const SizedBox(width: 4),
                              ],
                            ),
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}
