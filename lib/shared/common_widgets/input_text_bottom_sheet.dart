import 'package:custom_widgets_toolkit/custom_widgets_toolkit.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:slides_sync/shared/helpers/extension_helper.dart';

class InputTextBottomSheet extends ConsumerStatefulWidget {
  final String title;
  final String hintText;
  final String? defaultText;
  final void Function(String text) onSubmitted;
  const InputTextBottomSheet({super.key, required this.title, required this.hintText, this.defaultText, required this.onSubmitted});

  @override
  ConsumerState<ConsumerStatefulWidget> createState() => _InputTextBottomSheetState();
}

class _InputTextBottomSheetState extends ConsumerState<InputTextBottomSheet> {
  late final FocusNode focusNode;
  late final TextEditingController textEditingController;
  @override
  void initState() {
    super.initState();
    focusNode = FocusNode();
    textEditingController = TextEditingController(text: widget.defaultText);
    WidgetsBinding.instance.addPostFrameCallback((_) {
      focusNode.requestFocus();
      textEditingController.selection = TextSelection(baseOffset: 0, extentOffset: textEditingController.text.length);
    });
  }

  @override
  void dispose() {
    focusNode.dispose();
    textEditingController.dispose();
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
                  child: CustomText(widget.title, fontSize: 13, color: context.theme.primaryColor, fontWeight: FontWeight.bold),
                ),
                ConstantSizing.columnSpacingSmall,
                CustomTextfield(
                  autoDispose: false,
                  controller: textEditingController,
                  hint: widget.hintText,
                  defaultText: widget.defaultText ?? '',
                  focusNode: focusNode,
                  onTapOutside: () {},
                  onSubmitted: widget.onSubmitted,
                  inputContentPadding: EdgeInsets.symmetric(horizontal: 12.0),
                  inputTextStyle: TextStyle(fontSize: 15, color: context.theme.colorScheme.tertiary),
                  cursorColor: context.theme.primaryColor,
                  backgroundColor: Colors.transparent,
                  border: UnderlineInputBorder(borderSide: BorderSide(color: context.theme.primaryColor)),
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
