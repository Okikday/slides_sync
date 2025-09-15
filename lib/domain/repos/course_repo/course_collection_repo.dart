import 'dart:developer';

import 'package:isar/isar.dart';
import 'package:slides_sync/core/storage/isar_data/isar_data.dart';
import 'package:slides_sync/domain/models/course_model/course.dart';
import 'package:slides_sync/domain/repos/course_repo/course_repo.dart';

class CourseCollectionRepo {
  static final IsarData<CourseCollection> _isarData = IsarData.instance<CourseCollection>();
  static Future<Isar> get _isar async => await IsarData.isarFuture;

  static IsarData<CourseCollection> get isarData => _isarData;

  static Future<QueryBuilder<CourseCollection, CourseCollection, QFilterCondition>> get filter async =>
      (await _isar).courseCollections.filter();

  static Future<void> deleteByDbId(int dbId) async => await _isarData.deleteById(dbId);

  static Future<CourseCollection?> getByDbId(int dbId) => _isarData.getById(dbId);

  static Stream<CourseCollection?> watchByDbId(int dbId) => _isarData.watchById(dbId);

  static Future<int> add(CourseCollection collection) async => await _isarData.store(collection);

  static Future<List<CourseCollection>> getAll() async => _isarData.getAll();

  static Stream<List<CourseCollection>> watchAll() => _isarData.watchAll();

  static Future<Stream<List<CourseCollection>>> watchAllLazily() async => await _isarData.watchAllLazily();

  static Future<CourseCollection?> getById(String collectionId) async {
    return await (await _isar).courseCollections.filter().collectionIdEqualTo(collectionId).findFirst();
  }

  static Stream<CourseCollection?> watchCollectionById(String collectionId) async* {
    yield* (await _isar).courseCollections
        .filter()
        .collectionIdEqualTo(collectionId)
        .watch(fireImmediately: true)
        .map((list) => list.firstOrNull);
  }

  static Future<CourseCollection?> deleteCollectionById(String collectionId) async {
    final isar = await _isar;
    final CourseCollection? collection = await getById(collectionId);
    return await isar.writeTxn<CourseCollection?>(() async {
      if (collection != null) {
        final idQuery = (await filter).collectionIdEqualTo(collectionId);
        await idQuery.deleteFirst();
      }
      return collection;
    });
  }

  static Future<CourseContent?> findFirstDuplicateContentByHash(CourseCollection collection, String contentHash) async {
    await collection.contents.load();
    return (collection.contents.where((content) => content.contentHash == contentHash)).firstOrNull;
  }

  static Future<bool> addContent(CourseContent content, [CourseCollection? collection]) async {
    try {
      final isar = (await _isar);
      // final CourseContent? getCurr = await isar.courseContents.get(content.id);
      CourseCollection? getCollection =
          collection != null
              ? (await isar.courseCollections.get(collection.id))
              : (await isar.courseCollections.filter().collectionIdEqualTo(content.parentId).findFirst());
      if (getCollection == null) return false;

      await getCollection.contents.load();
      if (getCollection.parentId.isEmpty) return false;
      final Course? course = await CourseRepo.getCourseById(getCollection.parentId);
      if (course == null) return false;

      await isar.writeTxn(() async {
        await isar.courseContents.put(content);

        //Add content to the collection
        getCollection.contents.add(content);

        // Load collections from the course
        await course.collections.load();
        await getCollection.contents.save();
        await isar.courseCollections.put(getCollection);
        course.collections.add(getCollection);
        await isar.courses.put(course.copyWith(lastUpdated: DateTime.now()));
        await course.collections.save();
      });

      return true;
    } catch (e) {
      log("$e");
      return false;
    }
  }

  static Future<bool> deleteContent(CourseContent content, [CourseCollection? collection]) async {
    try {
      final isar = (await _isar);
      CourseCollection? getCollection =
          collection != null
              ? (await isar.courseCollections.get(collection.id))
              : (await isar.courseCollections.filter().collectionIdEqualTo(content.parentId).findFirst());
      if (getCollection == null) return false;

      if (getCollection.parentId.isEmpty) return false; // redundant
      final course = await CourseRepo.getCourseById(getCollection.parentId);
      if (course == null) return false;

      await getCollection.contents.load();
      await course.collections.load();
      await isar.writeTxn(() async {
        getCollection.contents.remove(content);
        await isar.courseCollections.put(getCollection);
        await getCollection.contents.save();
        await isar.courseContents.delete(content.id);

        course.collections.add(getCollection);
        await isar.courses.put(course);
        await course.collections.save();
      });
      return true;
    } catch (e) {
      log("$e");
      return false;
    }
  }

  static Future<bool> addMultipleContents(List<CourseContent> contents, [CourseCollection? collection]) async {
    try {
      final isar = (await _isar);
      final List<CourseContent?> existingContents = (await isar.courseContents.getAll([
        for (final i in contents) i.id,
      ]));
      final existingIds = existingContents.whereType<CourseContent>().map((e) => e.id).toSet();
      final newContents = contents.where((c) => !existingIds.contains(c.id)).toList();
      if (newContents.isEmpty) return true;

      final Map<String, String> parentIds = {};

      for (final e in newContents) {
        if (!parentIds.containsKey(e.parentId)) {
          parentIds[e.parentId] = e.parentId;
        }
      }
      if (parentIds.isEmpty) return false;

      if (parentIds.length == 1) {
        CourseCollection? getCollection =
            collection != null
                ? (await isar.courseCollections.get(collection.id))
                : (await isar.courseCollections.filter().collectionIdEqualTo(newContents.first.parentId).findFirst());
        if (getCollection == null) return false;
        // final CourseContent? sameHashedContent = await isar.courseContents.filter().contentHashEqualTo(content.contentHash).findFirst();

        final course = await CourseRepo.getCourseById(getCollection.parentId);
        if (course == null) return false;

        await getCollection.contents.load();
        await course.collections.load();
        await isar.writeTxn(() async {
          await isar.courseContents.putAll(newContents);
          getCollection.contents.addAll(newContents);
          await isar.courseCollections.put(getCollection);
          await getCollection.contents.save();

          course.collections.add(getCollection);
          await isar.courses.put(course);
          await course.collections.save();
        });
        return true;
      } else {
        final Map<CourseCollection, CourseContent> cache = {};

        for (final newContent in newContents) {
          CourseCollection? getCollection =
              collection != null
                  ? (await isar.courseCollections.get(collection.id))
                  : (await isar.courseCollections.filter().collectionIdEqualTo(newContent.parentId).findFirst());
          if (getCollection == null) continue;
          final course = await CourseRepo.getCourseById(getCollection.parentId);
          if (course == null) continue;

          cache[getCollection] = newContent;
        }

        for (final collection in cache.keys) {
          final content = cache[collection];
          if (content == null) continue;
          await collection.contents.load();
          collection.contents.add(content);
          await CourseRepo.addCollection(collection);
        }
        return true;
      }
    } catch (e) {
      log("$e");
      return false;
    }
  }

  // check issue here
  static Future<bool> deleteMultipleContents(List<CourseContent> contents, [CourseCollection? collection]) async {
    try {
      final isar = await _isar;

      // Get existing contents by IDs (using the auto-increment id)
      final List<CourseContent?> existingContents = await isar.courseContents.getAll([
        for (final content in contents) content.id,
      ]);
      final existingIds = existingContents.whereType<CourseContent>().map((e) => e.id).toSet();

      // Filter only contents that actually exist in DB
      final contentsToDelete = contents.where((c) => existingIds.contains(c.id)).toList();
      if (contentsToDelete.isEmpty) return true;

      // Group contents by parentId (collectionId)
      final Map<String, List<CourseContent>> contentsByParent = {};
      for (final content in contentsToDelete) {
        contentsByParent.putIfAbsent(content.parentId, () => []).add(content);
      }

      if (contentsByParent.isEmpty) return false;

      // If only one collection involved
      if (contentsByParent.length == 1) {
        final parentId = contentsByParent.keys.first;
        CourseCollection? getCollection =
            collection != null && collection.collectionId == parentId
                ? collection
                : await isar.courseCollections.filter().collectionIdEqualTo(parentId).findFirst();

        if (getCollection == null) return false;

        // Load the course for relationship updates
        final course = await CourseRepo.getCourseById(getCollection.parentId);
        if (course == null) return false;

        await getCollection.contents.load();
        await course.collections.load();

        await isar.writeTxn(() async {
          // Delete all contents in batch
          await isar.courseContents.deleteAll(contentsByParent[parentId]!.map((c) => c.id).toList());

          // Remove from collection's links
          for (final content in contentsByParent[parentId]!) {
            getCollection.contents.remove(content);
          }

          // Save updated collection
          await isar.courseCollections.put(getCollection);
          await getCollection.contents.save();

          // Update course relationship
          course.collections.add(getCollection);
          await isar.courses.put(course);
          await course.collections.save();
        });
        return true;
      } else {
        // Multiple collections involved
        await isar.writeTxn(() async {
          for (final entry in contentsByParent.entries) {
            final parentId = entry.key;
            final contentsList = entry.value;

            CourseCollection? getCollection =
                collection != null && collection.collectionId == parentId
                    ? collection
                    : await isar.courseCollections.filter().collectionIdEqualTo(parentId).findFirst();

            if (getCollection == null) continue;

            // Load relationships
            await getCollection.contents.load();

            final course = await CourseRepo.getCourseById(getCollection.parentId);
            if (course != null) {
              await course.collections.load();
            }

            // Delete contents
            await isar.courseContents.deleteAll(contentsList.map((c) => c.id).toList());

            // Remove from collection links
            for (final content in contentsList) {
              getCollection.contents.remove(content);
            }

            // Save updated collection
            await isar.courseCollections.put(getCollection);
            await getCollection.contents.save();

            // Update course relationship if course exists
            if (course != null) {
              course.collections.add(getCollection);
              await isar.courses.put(course);
              await course.collections.save();
            }
          }
        });
        return true;
      }
    } catch (e) {
      log("deleteMultipleContents error: $e");
      return false;
    }
  }

  
  static Future<bool> deleteAllContents(CourseCollection collection) async {
    try {
      final isar = await _isar;
      await collection.contents.load();

      final contentIds = collection.contents.map((c) => c.id).toList();
      await isar.writeTxn(() async {
        await isar.courseContents.deleteAll(contentIds);
        collection.contents.clear();
        await isar.courseCollections.put(collection);
        await collection.contents.save();
      });

      return true;
    } catch (e) {
      log("Error deleting all contents: $e");
      return false;
    }
  }
}
