import 'dart:typed_data';

import 'package:custom_widgets_toolkit/custom_widgets_toolkit.dart';
import 'package:flutter/material.dart';
import 'package:flutter_animate/flutter_animate.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:slides_sync/core/utils/result.dart';
import 'package:slides_sync/core/utils/ui_utils.dart';
import 'package:slides_sync/features/manage_all/manage_contents/presentation/actions/add_contents_actions.dart';
import 'package:slides_sync/shared/helpers/extension_helper.dart';

class BuildAddFromClipboardDialog extends ConsumerWidget {
  final void Function([bool]) closeOverlay;
  final AppClipboardData clipboardData;

  const BuildAddFromClipboardDialog({super.key, required this.closeOverlay, required this.clipboardData});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    // final theme = ref.theme;
    final contentType = clipboardData.contentType;

    switch (contentType) {
      case AppClipboardContentType.image || AppClipboardContentType.images:
        final Result result =
            contentType == AppClipboardContentType.image
                ? Result.tryRun<Uint8List>(() => clipboardData.data as Uint8List)
                : Result.tryRun<List<Uint8List>>(() => clipboardData.data as List<Uint8List>);
        if (!result.isSuccess || result.data == null || result.data!.isEmpty) {
          closeOverlay();
          return const SizedBox();
        }
        final List<Uint8List> imageList;
        if (contentType == AppClipboardContentType.image) {
          imageList = [result.data as Uint8List];
        } else {
          imageList = result.data as List<Uint8List>;
        }

        return _ImageDialog(
          title: "Add the following image${imageList.length > 1 ? 's' : ''} from your clipboard to this collection?",
          images: imageList,
          closeOverlay: closeOverlay,
        );

      // case AppClipboardContentType.file:
      //   final Result<String?> result = Result.tryRun<String>(() => clipboardData.data as String);
      //   if (!result.isSuccess || result.data == null || result.data!.isEmpty) {
      //     closeOverlay();
      //     return const SizedBox();
      //   }
      //   return _FileDialog(filePath: result.data!, closeOverlay: closeOverlay);

      // case AppClipboardContentType.files:
      //   final Result<List<String>?> result = Result.tryRun<List<String>>(() => clipboardData.data as List<String>);
      //   if (!result.isSuccess || result.data == null || result.data!.isEmpty) {
      //     closeOverlay();
      //     return const SizedBox();
      //   }
      //   return _MultiFileDialog(filePaths: result.data!, closeOverlay: closeOverlay);

      // case AppClipboardContentType.text:
      //   final Result<String?> result = Result.tryRun<String>(() => clipboardData.data as String);
      //   if (!result.isSuccess || result.data == null || result.data!.isEmpty) {
      //     closeOverlay();
      //     return const SizedBox();
      //   }
      //   return _TextDialog(textData: result.data!, closeOverlay: closeOverlay);

      // case AppClipboardContentType.html:
      //   final Result<String?> result = Result.tryRun<String>(() => clipboardData.data as String);
      //   if (!result.isSuccess || result.data == null || result.data!.isEmpty) {
      //     closeOverlay();
      //     return const SizedBox();
      //   }
      //   return _HtmlDialog(htmlData: result.data!, closeOverlay: closeOverlay);

      default:
        closeOverlay();
        return const SizedBox();
    }
  }
}

class _DialogScaffold extends ConsumerWidget {
  final Widget child;
  final void Function([bool inInitPostFrame]) closeOverlay;

  const _DialogScaffold({required this.child, required this.closeOverlay});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final theme = ref.theme;
    const double size = 400;
    return Material(
      color: Colors.transparent,
      child: Stack(
        alignment: Alignment.bottomCenter,
        children: [
          Positioned.fill(
            child: GestureDetector(
              onTap: () => closeOverlay(false),
              child: ColoredBox(color: Colors.black.withValues(alpha: 0.4)),
            ),
          ),
          AnimatedContainer(
            duration: Durations.medium2,
            height: 300,
            constraints: BoxConstraints(maxHeight: size, maxWidth: size),
            margin: EdgeInsets.fromLTRB(20, 0, 20, context.bottomPadding),
            decoration: BoxDecoration(
              color: theme.background,
              borderRadius: BorderRadius.circular(30),
              border: Border.fromBorderSide(BorderSide(color: theme.onBackground.withValues(alpha: 0.1))),
            ),
            padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 16),
            child: child,
          ).animate().fadeIn().scaleY(
            begin: 0.4,
            end: 1,
            alignment: Alignment.bottomRight,
            duration: Duration(milliseconds: 500),
            curve: CustomCurves.defaultIosSpring,
          ),
        ],
      ),
    );
  }
}

class _ImageDialog extends ConsumerWidget {
  final String title;
  final List<Uint8List> images;
  final void Function([bool]) closeOverlay;

  const _ImageDialog({required this.title, required this.images, required this.closeOverlay});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final theme = ref.theme;
    return _DialogScaffold(
      closeOverlay: closeOverlay,
      child: Column(
        mainAxisSize: MainAxisSize.min,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          CustomText(title, color: theme.onBackground, fontSize: 16, fontWeight: FontWeight.bold),
          const SizedBox(height: 20),
          Expanded(
            child: Center(
              child: ListView.builder(
                scrollDirection: Axis.horizontal,
                itemCount: images.length,
                shrinkWrap: true,
                itemBuilder: (context, index) {
                  return Container(
                    clipBehavior: Clip.antiAlias,
                    constraints: BoxConstraints(maxHeight: 120),
                    decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(8),
                      border: Border.fromBorderSide(BorderSide(color: theme.onBackground.withAlpha(20))),
                    ),
                    child: Image.memory(images[index], fit: BoxFit.contain),
                  );
                },
              ),
            ),
          ),
          const SizedBox(height: 20),
          _ActionButtons(closeOverlay: closeOverlay),
        ],
      ),
    );
  }
}

class _ActionButtons extends ConsumerWidget {
  final void Function([bool inInitPostFrame]) closeOverlay;

  const _ActionButtons({required this.closeOverlay});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final theme = ref.theme;
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceEvenly,
      children: [
        Expanded(
          child: CustomElevatedButton(
            backgroundColor: theme.altBackgroundPrimary,
            label: "Cancel",
            textColor: theme.primaryColor,
            pixelHeight: 40,
            borderRadius: 24,
            onClick: () => closeOverlay(),
          ),
        ),
        const SizedBox(width: 16),
        Expanded(
          child: CustomElevatedButton(
            backgroundColor: theme.primaryColor,
            label: "Save",
            textColor: theme.onPrimary,
            pixelHeight: 40,
            borderRadius: 24,
            onClick: () {
              closeOverlay();
              UiUtils.hideDialog(context);
            },
          ),
        ),
      ],
    );
  }
}
