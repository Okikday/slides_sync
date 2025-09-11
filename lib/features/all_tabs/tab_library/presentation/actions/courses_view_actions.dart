import 'dart:developer';
import 'dart:async';
import 'dart:collection';

import 'package:infinite_scroll_pagination/infinite_scroll_pagination.dart';
import 'package:isar/isar.dart';
import 'package:slides_sync/domain/models/course_model/course.dart';
import 'package:slides_sync/domain/repos/course_repo/course_repo.dart';

enum CourseSortOption { ascending, descending, dateCreated, dateModified, none }

class CoursesViewActions {
  final CourseSortOption sortOption;

  // Ultra-fast concurrency control with queue system
  bool _isFetching = false;
  final Queue<Completer<List<Course>>> _waitingQueue = Queue();
  dynamic lastItemSortId;

  CoursesViewActions._({required this.sortOption});

  static CoursesViewActions of({CourseSortOption? sortOption}) =>
      CoursesViewActions._(sortOption: sortOption ?? CourseSortOption.none);

  Future<List<Course>> fetchPage(int pageKey, int limit) async {
    // If already fetching, queue this request
    if (_isFetching) {
      final completer = Completer<List<Course>>();
      _waitingQueue.add(completer);
      return completer.future;
    }

    _isFetching = true;
    try {
      final result = await _doFetch(pageKey, limit, sortOption);

      while (_waitingQueue.isNotEmpty) {
        _waitingQueue.removeFirst().complete(result);
      }

      return result;
    } catch (error) {
      while (_waitingQueue.isNotEmpty) {
        _waitingQueue.removeFirst().completeError(error);
      }
      rethrow;
    } finally {
      _isFetching = false;
    }
  }

  Future<List<Course>> _doFetch(int pageKey, int limit, CourseSortOption sortOption) async {
    final List<Course> result;

    switch (sortOption) {
      case CourseSortOption.ascending:
        result = await _fetchByTitle(pageKey, limit);
        break;
      case CourseSortOption.descending:
        result = await _fetchByTitle(pageKey, limit, false);
        break;
      case CourseSortOption.dateCreated:
        result = await _fetchByDateCreated(pageKey, limit);
        break;
      case CourseSortOption.dateModified:
        result = await _fetchByDateModified(pageKey, limit);
        break;
      default:
        result = await _fetchDefault(pageKey, limit);
    }

    return result;
  }

  Future<List<Course>> _fetchDefault(int pageKey, int limit) async {
    lastItemSortId ??= (pageKey - 1) * limit;

    final idGreaterThan = lastItemSortId;
    log("Fetching page $pageKey with ID > $idGreaterThan");

    final result = await (await CourseRepo.filter).idGreaterThan(idGreaterThan).limit(limit).findAll();

    if (result.isNotEmpty) {
      lastItemSortId = result.last.id;
    }

    return result;
  }

  Future<List<Course>> _fetchByTitle(int pageKey, int limit, [bool ascending = true]) async {
    final offset = (pageKey - 1) * limit;
    final filter = (await CourseRepo.filter);
    return await (ascending
        ? filter.idGreaterThan(0).sortByCourseTitle().offset(offset).limit(limit).findAll()
        : filter.idGreaterThan(0).sortByCourseTitle().offset(offset).limit(limit).findAll());
  }

  Future<List<Course>> _fetchByDateCreated(int pageKey, int limit) async {
    final offset = (pageKey - 1) * limit;
    return await (await CourseRepo.filter).idGreaterThan(0).sortByCreatedAt().offset(offset).limit(limit).findAll();
  }

  Future<List<Course>> _fetchByDateModified(int pageKey, int limit) async {
    final offset = (pageKey - 1) * limit;
    return await (await CourseRepo.filter).idGreaterThan(0).sortByLastUpdated().offset(offset).limit(limit).findAll();
  }

  static int? getNextPageKey(PagingState<int, Course> state) {
    return state.lastPageIsEmpty ? null : state.nextIntPageKey;
  }
  
  // Performance optimization: clear queue if needed
  void clearQueue() {
    while (_waitingQueue.isNotEmpty) {
      _waitingQueue.removeFirst().completeError(StateError('Queue cleared'));
    }
  }
  
  // Performance monitoring
  int get queueLength => _waitingQueue.length;
  bool get isBusy => _isFetching;
}
