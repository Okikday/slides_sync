import 'package:custom_widgets_toolkit/custom_widgets_toolkit.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:slides_sync/shared/helpers/extension_helper.dart';

class InputCourseTitleField extends ConsumerWidget {
  const InputCourseTitleField({
    super.key,
    required this.courseNameController,
    required this.isCourseCodeFieldVisible,
    this.viewScrollController,
  });
  final AutoDisposeStateProvider<bool> isCourseCodeFieldVisible;
  final TextEditingController courseNameController;
  final ScrollController? viewScrollController;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    return CustomTextfield(
      controller: courseNameController,
      backgroundColor: context.theme.colorScheme.onSurface,
      cursorColor: context.theme.colorScheme.tertiary,
      selectionHandleColor: context.theme.primaryColor,
      border: OutlineInputBorder(
        borderRadius: BorderRadius.circular(8.0),
        borderSide: BorderSide(color: context.isDarkMode ? Colors.lightBlueAccent.withAlpha(80) : context.theme.primaryColor.withAlpha(20)),
      ),
      pixelWidth: context.deviceWidth,
      pixelHeight: 60,
      inputContentPadding: EdgeInsets.symmetric(horizontal: 12, vertical: 18),
      hint: "Enter course title",
      inputTextStyle: TextStyle(fontSize: 16, color: context.theme.colorScheme.tertiary),
      onTapOutside: () {},
      autoDispose: false,
      suffixIcon: CustomElevatedButton(
        pixelWidth: 50,
        pixelHeight: 50,
        borderRadius: 12,
        overlayColor: context.theme.primaryColor.withAlpha(40),
        onClick: () async {
          final bool isCourseCodeVisible = ref.read(isCourseCodeFieldVisible.notifier).state;
          if (isCourseCodeVisible) FocusScope.of(context).unfocus();
          ref.read(isCourseCodeFieldVisible.notifier).update((cb) => !ref.read(isCourseCodeFieldVisible.notifier).state);
          if (FocusScope.of(context).hasFocus && viewScrollController != null) {
            viewScrollController?.animateTo(
              viewScrollController!.position.maxScrollExtent + 150,
              duration: Durations.extralong1,
              curve: CustomCurves.decelerate,
            );
          }
        },
        backgroundColor: Colors.transparent,
        child: Tooltip(
          message: "Add Optional Course code",
          triggerMode: TooltipTriggerMode.longPress,
          child: Icon(ref.watch(isCourseCodeFieldVisible) ? Icons.keyboard_arrow_up_rounded : Icons.keyboard_arrow_down_rounded, size: 30),
        ),
      ),
      alwaysShowSuffixIcon: true,
    );
  }
}
