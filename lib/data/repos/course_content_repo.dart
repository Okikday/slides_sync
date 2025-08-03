import 'package:isar/isar.dart';
import 'package:slides_sync/core/data/isar_data/isar_data.dart';
import 'package:slides_sync/data/models/course_model/sub/course_content.dart';

class CourseContentRepo {
  static final IsarData<CourseContent> _isarData = IsarData.instance<CourseContent>();
  static Future<Isar> get _isar async => await IsarData.isarFuture;

  static Future<QueryBuilder<CourseContent, CourseContent, QAfterFilterCondition>> _queryById(String contentHash) async {
    return (await _isarData.query<CourseContent>((q) => q.idGreaterThan(0))).filter().contentHashEqualTo(contentHash);
  }

  static Future<void> deleteByDbId(int dbId) async => await _isarData.deleteById(dbId);

  static Future<CourseContent?> getByDbId(int dbId) => _isarData.getById(dbId);

  static Stream<CourseContent?> watchByDbId(int dbId) => _isarData.watchById(dbId);

  static Future<int> add(CourseContent content) async => await _isarData.store(content);

  // static Future<List<int>> addMultiple(List<CourseContent> courses) async => await _isarData.storeAll(courses);

  static Future<List<CourseContent>> getAll() async => _isarData.getAll();

  static Stream<List<CourseContent>> watchAll() => _isarData.watchAll();

  static Future<Stream<List<CourseContent>>> watchAllLazily() async => await _isarData.watchAllLazily();

  static Future<CourseContent?> getByHash(String contentHash) async {
    return await (await _isar).courseContents.filter().contentHashEqualTo(contentHash).findFirst();
  }

  // static Stream<CourseContent?> watchCourseById(String contentHash) async* {
  //   yield* (await _isar).courseContents
  //       .filter()
  //       .contentHashEqualTo(contentHash)
  //       .watch(fireImmediately: true)
  //       .map((list) => list.firstOrNull);
  // }

  static Future<CourseContent?> deleteByHash(String contentHash) async {
    final isar = await _isar;
    final CourseContent? collection = await getByHash(contentHash);
    return await isar.writeTxn<CourseContent?>(() async {
      if (collection != null) {
        final idQuery = await _queryById(contentHash);
        await idQuery.deleteFirst();
      }
      return collection;
    });
  }

  /// Gets Duplicate Coursecontents, or contents with same hash
  static Future<List<CourseContent>> getAllDuplicatesByHash(String contentHash) async {
    return await (await _isar).courseContents.filter().contentHashEqualTo(contentHash).findAll();
  }
}
