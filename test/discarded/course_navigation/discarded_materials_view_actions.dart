// import 'dart:developer';
// import 'dart:async';
// import 'dart:collection';

// import 'package:infinite_scroll_pagination/infinite_scroll_pagination.dart';
// import 'package:isar/isar.dart';
// import 'package:slides_sync/domain/models/course_model/sub/course_content.dart';
// import 'package:slides_sync/domain/repos/course_repo/course_content_repo.dart';

// enum ContentSortOption { titleAscending, titleDescending, dateCreated, dateModified, none }

// class MaterialsViewActions {
//   final String collectionId;
//   final ContentSortOption sortOption;

//   bool _isFetching = false;
//   final Queue<Completer<List<CourseContent>>> _waitingQueue = Queue();
//   dynamic lastItemSortId;

//   MaterialsViewActions._(this.collectionId, {required this.sortOption});

//   static MaterialsViewActions of(String collectionId, {ContentSortOption? sortOption}) =>
//       MaterialsViewActions._(collectionId, sortOption: sortOption ?? ContentSortOption.none);

//   Future<List<CourseContent>> fetchPage(int pageKey, int limit) async {
//     if (_isFetching) {
//       final completer = Completer<List<CourseContent>>();
//       _waitingQueue.add(completer);
//       return completer.future;
//     }

//     _isFetching = true;
//     try {
//       final result = await _doFetch(pageKey, limit, sortOption);

//       while (_waitingQueue.isNotEmpty) {
//         _waitingQueue.removeFirst().complete(result);
//       }

//       return result;
//     } catch (error) {
//       // Complete queued requests with error
//       while (_waitingQueue.isNotEmpty) {
//         _waitingQueue.removeFirst().completeError(error);
//       }
//       rethrow;
//     } finally {
//       _isFetching = false;
//     }
//   }

//   Future<List<CourseContent>> _doFetch(int pageKey, int limit, ContentSortOption sortOption) async {
//     final List<CourseContent> result;

//     switch (sortOption) {
//       case ContentSortOption.titleAscending:
//         result = await _fetchByTitle(pageKey, limit);
//         break;
//       case ContentSortOption.titleDescending:
//         result = await _fetchByTitle(pageKey, limit, false);
//         break;
//       case ContentSortOption.dateCreated:
//         result = await _fetchByDateCreated(pageKey, limit);
//         break;
//       case ContentSortOption.dateModified:
//         result = await _fetchByDateModified(pageKey, limit);
//         break;
//       default:
//         result = await _fetchDefault(pageKey, limit);
//     }

//     return result;
//   }

//   Future<List<CourseContent>> _fetchDefault(int pageKey, int limit) async {
//     lastItemSortId ??= (pageKey - 1) * limit;
//     log("lastItemSortId: $lastItemSortId");

//     final idGreaterThan = lastItemSortId;
//     log("Fetching page $pageKey with ID > $idGreaterThan");

//     final result =
//         await (await CourseContentRepo.filter)
//             .parentIdContains(collectionId)
//             .idGreaterThan(idGreaterThan)
//             .limit(limit)
//             .findAll();
//     log("result: $result");
//     if (result.isNotEmpty) {
//       lastItemSortId = result.last.id;
//       log(" new lastItemSortId: $lastItemSortId");
//     }
//     return result;
//   }

//   Future<List<CourseContent>> _fetchByTitle(int pageKey, int limit, [bool ascending = true]) async {
//     final offset = (pageKey - 1) * limit;
//     final filter = (await CourseContentRepo.filter).parentIdContains(collectionId);
//     return await (ascending
//         ? filter.sortByTitle().offset(offset).limit(limit).findAll()
//         : filter.sortByTitleDesc().offset(offset).limit(limit).findAll());
//   }

//   Future<List<CourseContent>> _fetchByDateCreated(int pageKey, int limit) async {
//     final offset = (pageKey - 1) * limit;
//     return await (await CourseContentRepo.filter)
//         .parentIdContains(collectionId)
//         .sortByCreatedAt()
//         .offset(offset)
//         .limit(limit)
//         .findAll();
//   }

//   Future<List<CourseContent>> _fetchByDateModified(int pageKey, int limit) async {
//     final offset = (pageKey - 1) * limit;
//     return await (await CourseContentRepo.filter)
//         .parentIdContains(collectionId)
//         .sortByLastModified()
//         .offset(offset)
//         .limit(limit)
//         .findAll();
//   }

//   static int? getNextPageKey(PagingState<int, CourseContent> state) {
//     return state.lastPageIsEmpty ? null : state.nextIntPageKey;
//   }

//   void clearQueue() {
//     while (_waitingQueue.isNotEmpty) {
//       _waitingQueue.removeFirst().completeError(StateError('Queue cleared'));
//     }
//   }

//   // Performance monitoring
//   int get queueLength => _waitingQueue.length;
//   bool get isBusy => _isFetching;
// }
