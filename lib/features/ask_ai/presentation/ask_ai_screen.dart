import 'dart:developer';

import 'package:custom_widgets_toolkit/custom_widgets_toolkit.dart';
import 'package:firebase_ai/firebase_ai.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_animate/flutter_animate.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:iconsax_flutter/iconsax_flutter.dart';
import 'package:markdown_widget/markdown_widget.dart';
import 'package:slides_sync/features/ask_ai/domain/services/ai_gen_client.dart';
import 'package:slides_sync/features/ask_ai/presentation/quick_ai_scroll_widget.dart';
import 'package:slides_sync/features/content_viewer/presentation/controllers/doc_viewer_controllers/pdf_doc_viewer_controller.dart';
import 'package:slides_sync/shared/components/loading_logo.dart';
import 'package:slides_sync/shared/helpers/extension_helper.dart';
import 'package:dotted_border/dotted_border.dart';
import 'package:slides_sync/shared/styles/theme/app_theme_model.dart';

class AskAiScreen extends ConsumerStatefulWidget {
  const AskAiScreen({super.key});

  @override
  ConsumerState<ConsumerStatefulWidget> createState() => _AskAiScreenState();
}

class _AskAiScreenState extends ConsumerState<AskAiScreen> {
  late final ValueNotifier<Uint8List?> imageNotifier;
  late final ValueNotifier<String?> aiResponseNotifier;
  late final TextEditingController textEditingController;
  bool isProcessing = false;
  @override
  void initState() {
    super.initState();
    imageNotifier = ValueNotifier(null);
    aiResponseNotifier = ValueNotifier(null);
    textEditingController = TextEditingController();
  }

  @override
  void dispose() {
    imageNotifier.dispose();
    aiResponseNotifier.dispose();
    textEditingController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    SystemChrome.setPreferredOrientations([DeviceOrientation.portraitUp]);
    final theme = ref.theme;
    return Scaffold(
      backgroundColor: Colors.transparent,
      body: Align(
        alignment: Alignment.bottomCenter,
        child: Stack(
          alignment: Alignment.bottomCenter,
          children: [
            RepaintBoundary(child: OrganicBackgroundEffect()),
            SingleChildScrollView(
              child: SizedBox(
                width: context.deviceWidth,
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.end,

                  spacing: 40,
                  children: [
                    ValueListenableBuilder(
                      valueListenable: imageNotifier,
                      builder: (context, value, child) {
                        if (value != null) return const SizedBox();
                        return DottedBorder(
                          options: RoundedRectDottedBorderOptions(
                            radius: Radius.circular(8),
                            color: theme.onBackground,
                            padding: EdgeInsets.symmetric(vertical: 12, horizontal: 16),
                            strokeCap: StrokeCap.round,
                          ),
                          child: GestureDetector(
                            onTap: () async {
                              final pixelRatio = MediaQuery.devicePixelRatioOf(context);
                              imageNotifier.value = await PdfDocViewerController.screenshotController.capture(
                                pixelRatio: pixelRatio,
                              );
                            },
                            child: CustomText("Capture screen content behind"),
                          ),
                        );
                      },
                    ),

                    ValueListenableBuilder(
                      valueListenable: imageNotifier,
                      builder: (context, value, child) {
                        if (value == null) return const SizedBox();
                        return Container(
                          width: 100,
                          height: 100,
                          color: Colors.orange.withAlpha(20),
                          child: Image.memory(value),
                        );
                      },
                    ),
                    QuickAiScrollWidget(),
                    // Main box
                    Container(
                          width: context.deviceWidth - ((32 - context.viewInsets.bottom).clamp(0, 40)).clamp(0, 32),
                          clipBehavior: Clip.hardEdge,
                          margin: EdgeInsets.only(bottom: context.bottomPadding),
                          height: 100.0.clamp(context.deviceWidth, context.deviceHeight * 0.7),
                          constraints: BoxConstraints(maxWidth: 500),
                          decoration: BoxDecoration(
                            color: theme.background,
                            borderRadius: BorderRadius.only(
                              bottomLeft: Radius.circular((40 - context.viewInsets.bottom).clamp(0, 40)),
                              bottomRight: Radius.circular((40 - context.viewInsets.bottom).clamp(0, 40)),
                              topLeft: Radius.circular(32),
                              topRight: Radius.circular(32),
                            ),
                          ),
                          child: Align(
                            alignment: Alignment.bottomCenter,
                            child: SingleChildScrollView(
                              child: Column(
                                mainAxisAlignment: MainAxisAlignment.end,
                                spacing: 20,
                                children: [
                                  ValueListenableBuilder(
                                    valueListenable: aiResponseNotifier,
                                    builder: (context, value, child) {
                                      if (value == null) return SizedBox(child: Icon(Iconsax.computing, size: 32,),);
                                      return Container(
                                        height: 160,
                                        width: context.deviceWidth,
                                        margin: EdgeInsets.symmetric(horizontal: 20),
                                        padding: EdgeInsets.symmetric(horizontal: 12),
                                        decoration: BoxDecoration(
                                          color: theme.surface,
                                          borderRadius: BorderRadius.circular(8),
                                        ),
                                        child: MarkdownWidget(data: value, padding: EdgeInsets.zero),
                                      );
                                    },
                                  ),
                              
                                  Visibility(
                                    visible: isProcessing,
                                    child: Padding(
                                      padding: const EdgeInsets.only(bottom: 40),
                                      child: LoadingLogo(size: 64, color: theme.primary),
                                    ),
                                  ),
                                  CustomText("You can only ask one question at a time..", color: theme.onBackground.withAlpha(100)),
                                  CustomText("AI response may contain mistake.\nPowered by Gemini.", color: theme.onBackground.withAlpha(100), fontSize: 8, fontWeight: FontWeight.bold, textAlign: TextAlign.center,),
                              
                                  Padding(
                                        padding: EdgeInsets.only(left: 16.0, right: 16.0, bottom: 20),
                                        child: CustomTextfield(
                                          controller: textEditingController,
                                          autoDispose: false,
                                          hint: "What would you like to ask?",
                                          hintStyle: TextStyle(color: theme.onBackground.withValues(alpha: 0.6)),
                                          inputTextStyle: TextStyle(fontSize: 16),
                                          inputContentPadding: EdgeInsets.only(left: 12, bottom: 20, top: 20),
                                          backgroundColor: theme.background.blendColor(ref.isDarkMode ? 0.2 : 0.8),
                                          maxLines: 4,
                                          border: OutlineInputBorder(
                                            borderSide: BorderSide.none,
                                            borderRadius: BorderRadius.circular(40),
                                          ),
                                          alwaysShowSuffixIcon: true,
                                          suffixIcon: Padding(
                                            padding: const EdgeInsets.only(right: 12.0),
                                            child: CustomElevatedButton(
                                              onClick: () async {
                                                if (textEditingController.text.isEmpty) return;
                                                final imageBytes = imageNotifier.value;
                                                final message = textEditingController.text;
                                                textEditingController.clear();
                                                if (isProcessing) return;
                                                aiResponseNotifier.value = null;
                                                setState(() {
                                                  isProcessing = true;
                                                });
                                                log("Sending message to model");
                                                final result = await AiGenClient.instance.chatAnon([
                                                  Content.multi([
                                                    TextPart(message),
                                                    if (imageBytes != null) InlineDataPart("image/png", imageBytes),
                                                  ]),
                                                ]);
                              
                                                log("Result: $result");
                                                aiResponseNotifier.value = result;
                                                setState(() {
                                                  isProcessing = false;
                                                });
                                              },
                                              shape: CircleBorder(),
                                              contentPadding: EdgeInsets.all(12.0),
                                              backgroundColor: Colors.white.withAlpha(20),
                                              child: Icon(
                                                Iconsax.send_2_copy,
                                                size: 22,
                                                color: context.isDarkMode ? Colors.white : Colors.white,
                                              ),
                                            ),
                                          ),
                                        ),
                                      )
                                      .animate()
                                      .scaleXY(begin: 0.8, end: 1.0, alignment: Alignment.bottomCenter)
                                      .fadeIn(duration: Durations.medium3),
                                ],
                              ),
                            ),
                          ),
                        )
                        .animate()
                        .scaleY(
                          begin: 0.2,
                          end: 1.0,
                          alignment: Alignment.bottomRight,
                          duration: Durations.extralong2,
                          curve: CustomCurves.bouncySpring,
                        )
                        .fadeIn(),
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
