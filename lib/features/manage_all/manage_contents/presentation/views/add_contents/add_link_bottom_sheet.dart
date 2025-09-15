import 'package:custom_widgets_toolkit/custom_widgets_toolkit.dart';
import 'package:flutter/material.dart';
import 'package:flutter_animate/flutter_animate.dart';
import 'package:flutter_link_previewer/flutter_link_previewer.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:slides_sync/core/routes/routes.dart';
import 'package:slides_sync/core/utils/ui_utils.dart';
import 'package:slides_sync/domain/models/course_model/course.dart';
import 'package:slides_sync/domain/models/file_details.dart';
import 'package:slides_sync/features/manage_all/manage_contents/presentation/actions/add_contents_actions.dart';
import 'package:slides_sync/features/manage_all/manage_contents/presentation/actions/add_link_actions.dart';
import 'package:slides_sync/features/manage_all/manage_contents/domain/repos/get_content_repo/get_content_repo.dart';
import 'package:slides_sync/shared/common_widgets/input_text_bottom_sheet.dart';
import 'package:slides_sync/shared/helpers/extension_helper.dart';
import 'package:slides_sync/shared/widgets/build_image_path_widget.dart';



class AddLinkBottomSheet extends ConsumerStatefulWidget {
  final CourseCollection collection;
  const AddLinkBottomSheet({super.key, required this.collection});

  @override
  ConsumerState<AddLinkBottomSheet> createState() => _AddLinkBottomSheetState();
}

class _AddLinkBottomSheetState extends ConsumerState<AddLinkBottomSheet> {
  late final TextEditingController linkInputController;
  late final ValueNotifier<String?> previewDataNotifier;
  late final ValueNotifier<PreviewLinkDetails> additionalDetails;

  @override
  void initState() {
    super.initState();
    linkInputController = TextEditingController();
    previewDataNotifier = ValueNotifier(null);
    additionalDetails = ValueNotifier((title: null, description: null, previewUrl: null));
    linkInputController.addListener(updateLinkInput);
  }

  void updateLinkInput() => previewDataNotifier.value = linkInputController.text;

  @override
  void dispose() {
    linkInputController.dispose();
    previewDataNotifier.dispose();
    additionalDetails.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Stack(
      children: [
        InputTextBottomSheet(
          title: "Add link",
          hintText: "https.youtube.com/learn",
          textEditingController: linkInputController,
          onSubmitted: (String text) async {
            if (text.isEmpty || text.length < 4 || text.length > 256) {
              UiUtils.showFlushBar(context, msg: "Invalid link input!");
              return;
            }
            rootNavigatorKey.currentContext?.pop();

            final bool result = await AddLinkActions.onClickToAddLinkContent(
              text,
              collection: widget.collection,
              previewLinkDetails: additionalDetails.value,
            );
            if (result) {
              if (context.mounted) UiUtils.showFlushBar(context, msg: "Successfully added link");
            } else {
              if (context.mounted) UiUtils.showFlushBar(context, msg: "Couldn't add link to collections");
            }
          },
        ),
        Positioned(
          left: 24,
          bottom: context.bottomPadding + 120,
          child: Container(
            width: 100,
            height: 100,
            clipBehavior: Clip.antiAlias,
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(16),
              boxShadow: [BoxShadow(color: ref.theme.onBackground.withValues(alpha: 0.2))],
            ),
            child: ValueListenableBuilder(
              valueListenable: previewDataNotifier,
              builder: (context, value, child) {
                return FutureBuilder(
                  future: GetContentRepo.getLinkPreviewData(value),
                  builder: (context, snapshot) {
                    if (snapshot.hasData &&
                        snapshot.data != null &&
                        !snapshot.data!.isEmpty &&
                        snapshot.data?.previewUrl != null) {
                      final previewData = snapshot.data;
                      final prevDetails = additionalDetails.value;
                      additionalDetails.value = (
                        title: previewData?.title ?? prevDetails.title,
                        description: previewData?.description ?? prevDetails.description,
                        previewUrl: previewData?.previewUrl ?? prevDetails.previewUrl,
                      );
                      return BuildImagePathWidget(
                        fileDetails: FileDetails(urlPath: snapshot.data!.previewUrl!),
                        fit: BoxFit.cover,
                        width: 100,
                        height: 100,
                      );
                    } else {
                      return const SizedBox();
                    }
                  },
                );
              },
            ),
          ).animate(onComplete: (controller) => controller.repeat()).shimmer(duration: Durations.extralong4),
        ),
        Positioned(
          right: 12,
          bottom: context.bottomPadding + 120,
          child: CustomElevatedButton(
            label: "Paste from Clipboard",
            backgroundColor: ref.theme.altBackgroundPrimary,
            textColor: ref.theme.primaryColor,
            onClick: () => AddLinkActions.pasteFromClipboard(linkInputController),
          ),
        ),
      ],
    ).animate().fadeIn().slideY(
      begin: .4,
      end: 0,
      duration: Duration(milliseconds: 200),
      curve: CustomCurves.decelerate,
    );
  }
}
