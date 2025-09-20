import 'dart:developer';
import 'dart:async';
import 'dart:collection';

import 'package:infinite_scroll_pagination/infinite_scroll_pagination.dart';
import 'package:isar/isar.dart';
import 'package:slides_sync/domain/models/course_model/course.dart';
import 'package:slides_sync/domain/repos/course_repo/course_repo.dart';

enum CourseSortOption { nameAsc, nameDesc, dateCreatedAsc, dateCreatedDesc, dateModifiedAsc, dateModifiedDesc, none }
enum PlainCourseSortOption { name, dateCreated, dateModified, none }

class CoursesViewActions {
  final CourseSortOption sortOption;

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
      case CourseSortOption.nameAsc:
        result = await _fetchByTitle(pageKey, limit);
        break;
      case CourseSortOption.nameDesc:
        result = await _fetchByTitle(pageKey, limit, false);
        break;
      case CourseSortOption.dateCreatedAsc:
        result = await _fetchByDateCreated(pageKey, limit);
        break;
      case CourseSortOption.dateCreatedDesc:
        result = await _fetchByDateCreated(pageKey, limit, false);
        break;
      case CourseSortOption.dateModifiedAsc:
        result = await _fetchByDateModified(pageKey, limit);
        break;
      case CourseSortOption.dateModifiedDesc:
        result = await _fetchByDateModified(pageKey, limit, false);
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
        : filter.idGreaterThan(0).sortByCourseTitleDesc().offset(offset).limit(limit).findAll());
  }

  Future<List<Course>> _fetchByDateCreated(int pageKey, int limit, [bool ascending = true]) async {
    final offset = (pageKey - 1) * limit;
    final filter = (await CourseRepo.filter);
    return await (ascending
        ? filter.idGreaterThan(0).sortByCreatedAt().offset(offset).limit(limit).findAll()
        : filter.idGreaterThan(0).sortByCreatedAtDesc().offset(offset).limit(limit).findAll());
  }

  Future<List<Course>> _fetchByDateModified(int pageKey, int limit, [bool ascending = true]) async {
    final offset = (pageKey - 1) * limit;
    final filter = (await CourseRepo.filter);
    return await (ascending
        ? filter.idGreaterThan(0).sortByLastUpdated().offset(offset).limit(limit).findAll()
        : filter.idGreaterThan(0).sortByLastUpdatedDesc().offset(offset).limit(limit).findAll());
  }

  static int? getNextPageKey(PagingState<int, Course> state) {
    return state.lastPageIsEmpty ? null : state.nextIntPageKey;
  }

  void clearQueue() {
    while (_waitingQueue.isNotEmpty) {
      _waitingQueue.removeFirst().completeError(StateError('Queue cleared'));
    }
  }

  void dispose() {
    clearQueue();
  }

  int get queueLength => _waitingQueue.length;
  bool get isBusy => _isFetching;
}



extension CourseSortX on CourseSortOption {
  PlainCourseSortOption toPlain() {
    final n = name;
    final core = n.endsWith('Asc')
        ? n.substring(0, n.length - 3)
        : n.endsWith('Desc')
            ? n.substring(0, n.length - 4)
            : n;
    switch (core) {
      case 'name':
        return PlainCourseSortOption.name;
      case 'dateCreated':
        return PlainCourseSortOption.dateCreated;
      case 'dateModified':
        return PlainCourseSortOption.dateModified;
      default:
        return PlainCourseSortOption.none;
    }
  }

  String get label {
    switch (this) {
      case CourseSortOption.nameAsc:
        return 'Name (Ascending)';
      case CourseSortOption.nameDesc:
        return 'Name (Descending)';
      case CourseSortOption.dateCreatedAsc:
        return 'Date Created (Ascending)';
      case CourseSortOption.dateCreatedDesc:
        return 'Date Created (Descending)';
      case CourseSortOption.dateModifiedAsc:
        return 'Date Modified (Ascending)';
      case CourseSortOption.dateModifiedDesc:
        return 'Date Modified (Descending)';
      case CourseSortOption.none:
        return 'None';
    }
  }
}

