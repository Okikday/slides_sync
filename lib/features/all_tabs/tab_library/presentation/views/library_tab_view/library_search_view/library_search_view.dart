import 'dart:developer';

import 'package:custom_widgets_toolkit/custom_widgets_toolkit.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:iconsax_flutter/iconsax_flutter.dart';
import 'package:isar/isar.dart';
import 'package:slides_sync/domain/models/course_model/course.dart';
import 'package:slides_sync/domain/repos/course_repo/course_repo.dart';
import 'package:slides_sync/features/all_tabs/tab_library/presentation/views/library_tab_view/courses_view/course_card.dart';
import 'package:slides_sync/shared/helpers/extension_helper.dart';

class LibrarySearchView extends ConsumerStatefulWidget {
  const LibrarySearchView({super.key});

  @override
  ConsumerState<LibrarySearchView> createState() => _LibrarySearchViewState();
}

class _LibrarySearchViewState extends ConsumerState<LibrarySearchView> {
  @override
  Widget build(BuildContext context) {
    final theme = ref.theme;
    return Scaffold(
      body: Container(
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 16),
          child: Column(
            children: [
              ConstantSizing.columnSpacing(context.topPadding + kToolbarHeight),
              SearchAnchor(builder: (context, controller){
                return 
                Container(
                clipBehavior: Clip.antiAlias,
                decoration: BoxDecoration(borderRadius: BorderRadius.circular(16),
                // border: Border.fromBorderSide(BorderSide(color: theme.supportingText.withAlpha(10))),
                 boxShadow: [
                  BoxShadow( color: theme.supportingText, blurRadius: 6, spreadRadius: -8, blurStyle: BlurStyle.normal)
                ]),
                child: CustomTextfield(
                  controller: controller,
                    backgroundColor: theme.surface.withValues(alpha: 0.8),
                    cursorColor: theme.primaryColor,
                    selectionHandleColor: theme.primaryColor,
                    border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(20.0),
                      borderSide: BorderSide(color: theme.altBackgroundPrimary.withAlpha(150)),
                    ),
                    focusedBorder: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(20.0),
                      borderSide: BorderSide(color: theme.primaryColor),
                    ),
                    autoDispose: false,
                    onTapOutside: () {},
                    onchanged: (text) {
                      if(text.isEmpty){
                        log("Text is empty, outta here");
                        controller.closeView(text);
                        return;
                      }
                      controller.openView();
                    },
                    pixelHeight: 60,
                    inputContentPadding: EdgeInsets.symmetric(horizontal: 12, vertical: 18),
                    hint: "Search a course",
                    inputTextStyle: TextStyle(fontSize: 16, color: theme.onBackground),
                    prefixIcon: Padding(
                        padding: const EdgeInsets.only(left: 20.0, right: 10.0, top: 12.0, bottom: 12.0),
                        child: Icon(Iconsax.search_normal_copy, size: 20, color: theme.supportingText),
                      ),
                  ),
              );
              }, suggestionsBuilder: (context, controller) async{
                log("Searching");
                final List<Course> searchResults = await (await CourseRepo.filter).courseTitleContains(controller.text, caseSensitive: false).findAll();
                log("Done searching");
                log("Search result: $searchResults");
                return [
                  for(int i = 0; i < searchResults.length; i++)
                  CourseCard(searchResults[i], false)
                ];
              })
              
            ],
          ),
        ),
      ),
    );
  }
}