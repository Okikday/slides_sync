import 'dart:developer';

import 'package:infinite_scroll_pagination/infinite_scroll_pagination.dart';
import 'package:isar/isar.dart';
import 'package:slides_sync/domain/models/course_model/sub/course_content.dart';
import 'package:slides_sync/domain/repos/course_repo/course_content_repo.dart';

class MaterialsViewActions {
  
  static Future<List<CourseContent>> fetchPage(int pageKey, int limit, String collectionId, ) async {
    
    final list = await (await CourseContentRepo.filter).parentIdContains(collectionId).idGreaterThan((pageKey - 1) * limit).limit(limit).findAll();
    // log("pageKey: $pageKey");
    // log("Got: ${list}");
    return list;
  }

  static int? getNextPageKey(PagingState<int, CourseContent> state) {
    // log("${state.nextIntPageKey}");
    return state.lastPageIsEmpty ? null : state.nextIntPageKey;
  }
}