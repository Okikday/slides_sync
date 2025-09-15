import 'dart:ui';

import 'package:custom_widgets_toolkit/custom_widgets_toolkit.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:iconsax_flutter/iconsax_flutter.dart';
import 'package:slides_sync/shared/helpers/extension_helper.dart';
import 'package:slides_sync/shared/styles/colors.dart';

class CollectionsViewSearchBar extends ConsumerStatefulWidget {
  final TextEditingController? searchController;
  final void Function() onTap;
  final void Function(FocusNode focusNode)? onTapOutside;
  const CollectionsViewSearchBar({super.key, this.searchController, required this.onTap, this.onTapOutside});

  @override
  ConsumerState<CollectionsViewSearchBar> createState() => _CollectionsViewSearchBarState();
}

class _CollectionsViewSearchBarState extends ConsumerState<CollectionsViewSearchBar> {
  late final FocusNode focusNode;
  @override
  void initState() {
    super.initState();
    focusNode = FocusNode();
  }

  @override
  void dispose() {
    focusNode.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final theme = ref.theme;
    return ClipRRect(
      child: ColoredBox(
        color: context.scaffoldBackgroundColor.withValues(alpha: 0.6),
        child: BackdropFilter(
          filter: ImageFilter.blur(sigmaX: 4.0, sigmaY: 4.0),
          child: Padding(
            padding: const EdgeInsets.only(left: 16.0, right: 16.0, bottom: 24.0, top: 12.0),
            child: Row(
              spacing: 12.0,
              children: [
                Expanded(
                  child: ClipRSuperellipse(
                    borderRadius: BorderRadius.circular(10.0),
                    child: CustomTextfield(
                      hint: "Search collections",
                      focusNode: focusNode,
                      controller: widget.searchController,
                      autoDispose: false,
                      hintStyle: TextStyle(color: theme.supportingText),
                      selectionHandleColor: theme.primaryColor,
                      inputTextStyle: TextStyle(fontSize: 15, color: theme.onBackground),
                      backgroundColor: theme.surface,
                      border: OutlineInputBorder(borderSide: BorderSide.none, borderRadius: BorderRadius.zero),
                      prefixIcon: Padding(
                        padding: const EdgeInsets.only(left: 12.0, right: 10.0, top: 12.0, bottom: 12.0),
                        child: Icon(Iconsax.search_normal_copy, size: 20, color: theme.supportingText),
                      ),
                      onTapOutside:
                          widget.onTapOutside == null
                              ? null
                              : () {
                                if (widget.onTapOutside != null) widget.onTapOutside!(focusNode);
                              },
                      ontap: widget.onTap,
                    ),
                  ),
                ),

                // CustomElevatedButton(
                //   pixelHeight: 48,
                //   shape: CircleBorder(),
                //   backgroundColor: theme.altBackgroundPrimary,
                //   child: Icon(Iconsax.filter_copy, size: 20, color: theme.supportingText),
                // ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
