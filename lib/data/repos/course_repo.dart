import 'package:isar/isar.dart';
import 'package:slides_sync/core/data/isar_data/isar_data.dart';
import 'package:slides_sync/data/models/course_model/course_model.dart';

class CourseRepo {
  static final IsarData<CourseModel> isarData = IsarData.instance<CourseModel>();

  static Future<QueryBuilder<CourseModel, CourseModel, QAfterFilterCondition>> _queryById(String courseId) async {
    return (await isarData.query<CourseModel>((q) => q.idGreaterThan(0))).filter().courseIdEqualTo(courseId);
  }

  static Future<void> deleteCourseByDbId(int dbId) async => await isarData.deleteById(dbId);

  static Future<CourseModel?> getCourseByDbId(int dbId) => isarData.getById(dbId);

  static Stream<CourseModel?> watchCourseByDbId(int dbId) => isarData.watchById(dbId);

  static Future<int> addCourse(CourseModel course) async => await isarData.store(course);

  static Future<List<int>> addMultipleCourses(List<CourseModel> courses) async => await isarData.storeAll(courses);

  static Future<List<CourseModel>> getAllCourses() async => isarData.getAll();

  static Stream<List<CourseModel>> watchAllCourses() => isarData.watchAll();

  static Future<Stream<List<CourseModel>>> watchAllCoursesLazily() async => await isarData.watchAllLazily();

  // static Future<PageResponse<CourseModel>> fetchPagedCourses({required int page, required int limit}) async {
  //   final offset = page * limit;
  //   log("Resolved offset in fetching: $offset");

  //   final isar = await isarData.isarFuture;
  //   final items = await isar.courseModels.where().offset(offset).limit(limit).findAll();

  //   // null = last page reached
  //   final nextPageKey = items.length < limit ? null : page + 1;

  //   return PageResponse(items: items, nextPageKey: nextPageKey);
  // }

  static Future<CourseModel?> getCourseById(String courseId) async {
    final idQuery = await _queryById(courseId);
    return await idQuery.findFirst();
  }

  static Stream<CourseModel?> watchCourseById(String courseId) async* {
    final idQuery = await _queryById(courseId);
    yield* idQuery.watch(fireImmediately: true).map((list) => list.firstOrNull);
  }

  static Future<CourseModel?> deleteCourseById(String courseId) async {
    final isar = await isarData.isarFuture;

    return await isar.writeTxn<CourseModel?>(() async {
      final idQuery = await _queryById(courseId);
      final CourseModel? course = await idQuery.findFirst();
      if (course != null) await idQuery.deleteFirst();
      return course;
    });
  }
}
