import 'dart:developer';

import 'package:isar/isar.dart';
import 'package:slides_sync/core/storage/isar_data/isar_data.dart';
import 'package:slides_sync/domain/models/course_model/course.dart';

class CourseRepo {
  static final IsarData<Course> _isarData = IsarData.instance<Course>();
  static Future<Isar> get _isar async => await IsarData.isarFuture;
  static Future<Isar> get isar async => await _isar;
  static IsarData<Course> get isarData => _isarData;

  static Future<QueryBuilder<Course, Course, QFilterCondition>> get filter async=> (await _isar).courses.filter();

  static Future<QueryBuilder<Course, Course, QAfterFilterCondition>> _queryById(String courseId) async {
    return (await _isarData.query<Course>((q) => q.idGreaterThan(0))).filter().courseIdEqualTo(courseId);
  }

  static Future<void> deleteCourseByDbId(int dbId) async => await _isarData.deleteById(dbId);

  static Future<Course?> getCourseByDbId(int dbId) => _isarData.getById(dbId);

  static Stream<Course?> watchCourseByDbId(int dbId) => _isarData.watchById(dbId);

  static Future<int> addCourse(Course course) async => await _isarData.store(course);

  static Future<List<int>> addMultipleCourses(List<Course> courses) async => await _isarData.storeAll(courses);

  static Future<List<Course>> getAllCourses() async => _isarData.getAll();

  static Stream<List<Course>> watchAllCourses() => _isarData.watchAll();

  static Future<Stream<List<Course>>> watchAllCoursesLazily() async => await _isarData.watchAllLazily();

  static Future<Course?> getCourseById(String courseId) async {
    return await (await _isar).courses.filter().courseIdEqualTo(courseId).findFirst();
  }

  static Stream<Course?> watchCourseById(String courseId) async* {
    yield* (await _isar).courses.filter().courseIdEqualTo(courseId).watch(fireImmediately: true).map((list) => list.firstOrNull);
  }

  static Future<Course?> deleteCourseById(String courseId) async {
    final isar = await _isar;
    final Course? course = await getCourseById(courseId);
    return await isar.writeTxn<Course?>(() async {
      if (course != null) {
        final idQuery = await _queryById(courseId);
        await idQuery.deleteFirst();
      }
      return course;
    });
  }

  static Future<bool> addCollection(CourseCollection collection) async {
    try {
      if (collection.parentId.isEmpty) return false;
      final Course? course = await getCourseById(collection.parentId);
      if (course == null) return false;

      final Isar isar = (await _isar);

      await course.collections.load();
      
      await isar.writeTxn(() async {
        await isar.courseCollections.put(collection);
        course.collections.add(collection);
        await course.collections.save();
        await isar.courses.put(course.copyWith(lastUpdated: DateTime.now()));
      });
      return true;
    } catch (e) {
      log("$e");
      return false;
    }
  }

  static Future<bool> deleteCollection(CourseCollection collection) async {
    try {
      if (collection.collectionId.isEmpty) return false;
      final Course? course = await getCourseById(collection.parentId);
      if (course == null) return false;
      
      final isar = (await _isar);

      await course.collections.load();
      
      await isar.writeTxn(() async {
        // TODO: bE MORE ACCURATE
        collection.contents.clear();
        await collection.contents.save();
        if (!(await isar.courseCollections.delete(collection.id))) {
          await isar.courseCollections.filter().collectionIdEqualTo(collection.collectionId).deleteFirst();
        }
        course.collections.remove(collection);
        
        await course.collections.save();
        await isar.courses.put(course.copyWith(lastUpdated: DateTime.now()));
      });
      return true;
    } catch (e) {
      log("$e");
      return false;
    }
  }

  static Future<String?> addCollectionNoDuplicateTitle(CourseCollection collection) async {
    final isar = (await _isar);
    final CourseCollection? duplicate =
        await (isar.courseCollections
            .filter()
            .collectionTitleEqualTo(collection.collectionTitle)
            .parentIdEqualTo(collection.parentId)
            .findFirst());
    if (duplicate != null) return "Collection title already exists, try using a different name";
    final bool result = await addCollection(collection);
    if (result) return null;
    return "An error occured while adding collection";
  }
}
