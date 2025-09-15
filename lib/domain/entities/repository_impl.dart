// import 'package:isar/isar.dart';
// import 'package:slides_sync/core/storage/isar_data/isar_data.dart';

// abstract class RepositoryImpl<T> {
//   IsarData<T> get isarData;

//   Future<Isar> get isar async => await IsarData.isarFuture;

//   Future<int> add(T item) => isarData.store(item);
//   Future<List<int>> addAll(List<T> items) => isarData.storeAll(items);
//   Future<void> deleteByDbId(int dbId) => isarData.deleteById(dbId);
//   Future<T?> getByDbId(int dbId) => isarData.getById(dbId);
//   Stream<T?> watchByDbId(int dbId) => isarData.watchById(dbId);
//   Future<List<T>> getAll() => isarData.getAll();
//   Stream<List<T>> watchAll() => isarData.watchAll();
//   Future<Stream<List<T>>> watchAllLazily() => isarData.watchAllLazily();

//   Future<T?> getById(String id);

//   Future<T?> deleteById(String id);
// }
