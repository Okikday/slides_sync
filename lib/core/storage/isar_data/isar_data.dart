import 'dart:developer';
import 'package:isar/isar.dart';
import 'package:path_provider/path_provider.dart';
import 'package:slides_sync/domain/models/course_model/course.dart';

/// Utility class for generic Isar database operations.
/// Pass in the Isar CollectionSchema for your model to interact with the DB easily.
class IsarData<T> {
  // A cache of helpers, keyed by the model Type
  static final Map<Type, IsarData> _cache = {};

  // Static shared future for the database
  static Future<Isar>? _openDb;

  // Singleton accessor per type
  static IsarData<T> instance<T>() {
    if (!_cache.containsKey(T)) {
      _cache[T] = IsarData<T>._();
    }
    return _cache[T]! as IsarData<T>;
  }

  IsarData._();

  /// Initializes the shared database only once
  static Future<void> initialize({
    String dbName = 'default',
    List<CollectionSchema> collectionSchemas = const [],
    bool inspector = true,
  }) async {
    if (_openDb == null) {
      final dir = await getApplicationDocumentsDirectory();
      _openDb = Isar.open(collectionSchemas, directory: dir.path, name: dbName, inspector: inspector);
      log("Initialized Isar");
    }
  }

  /// Get the opened Isar instance (internal use)
  static Future<Isar> get isarFuture async => await _openDb!;

  /// Store or update a single object.
  Future<int> store(T object) async {
    final isar = await isarFuture;
    return await isar.writeTxn(() => isar.collection<T>().put(object));
  }

  /// Store or update multiple objects.
  Future<List<int>> storeAll(List<T> objects) async {
    final isar = await isarFuture;
    return await isar.writeTxn(() => isar.collection<T>().putAll(objects));
  }

  /// Retrieve an object by its ID.
  Future<T?> getById(int id) async {
    final isar = await isarFuture;
    return await isar.collection<T>().get(id);
  }

  /// Retrieve all objects in the collection.
  Future<List<T>> getAll() async {
    final isar = await isarFuture;
    return await isar.collection<T>().where().findAll();
  }

  /// Delete an object by its ID.
  Future<bool> deleteById(int id) async {
    final isar = await isarFuture;
    return await isar.writeTxn(() => isar.collection<T>().delete(id));
  }

  /// Delete multiple objects by their IDs.
  Future<int> deleteAll(List<int> ids) async {
    final isar = await isarFuture;
    return await isar.writeTxn(() => isar.collection<T>().deleteAll(ids));
  }

  /// Query builder: run a custom Isar Query.
  Future<QueryBuilder<T, R, QAfterWhereClause>> query<R>(
    QueryBuilder<T, R, QAfterWhereClause> Function(QueryBuilder<T, R, QWhereClause>) builder,
  ) async {
    final isar = await isarFuture;
    final queryBuilder = isar.collection<T>().where() as QueryBuilder<T, R, QWhereClause>;
    return builder(queryBuilder);
  }

  /// Stream all objects in the collection in real-time.
  Stream<List<T>> watchAll({bool fireImmediately = true}) async* {
    final isar = await isarFuture;
    yield* isar.collection<T>().where().watch(fireImmediately: fireImmediately);
  }

  Future<Stream<List<T>>> watchAllLazily() async {
    final isar = await isarFuture;
    return isar.collection<T>().where().watchLazy(fireImmediately: true).asyncMap((_) => getAll());
  }

  Future<Stream<void>> watchForChanges({bool fireImmediately = true}) async {
    final isar = await isarFuture;
    return isar.collection<T>().where().watchLazy(fireImmediately: fireImmediately);
  }

  Future<Stream<void>> watchForChangesById(String collectionId, {bool fireImmediately = true}) async {
    final isar = await isarFuture;
    return isar.courseCollections.filter().collectionIdEqualTo(collectionId).watchLazy();
  }

  /// Stream specific object by ID in real-time.
  Stream<T?> watchById(int id, {bool fireImmediately = true}) async* {
    final isar = await isarFuture;
    yield* isar.collection<T>().watchObject(id, fireImmediately: fireImmediately);
  }

  /// Stream query results in real-time.
  Stream<List<T>> watchQuery(
    QueryBuilder<T, T, QAfterWhereClause> Function(QueryBuilder<T, T, QWhereClause>) builder,
  ) async* {
    final isar = await isarFuture;
    final queryBuilder = isar.collection<T>().where();
    yield* builder(queryBuilder).watch(fireImmediately: true);
  }

  /// Close the database.
  static Future<void> close() async {
    final isar = await _openDb!;
    await isar.close();
    _openDb = null;
  }
}
