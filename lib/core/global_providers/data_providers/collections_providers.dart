import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:slides_sync/domain/models/course_model/sub/course_collection.dart';
import 'package:slides_sync/domain/repos/course_repo/course_collection_repo.dart';

final defaultCollection = CourseCollection.create(parentId: '_', collectionTitle: "_");
final StateProvider<String?> _activeCollectionIdProvider = StateProvider<String?>((ref) => null);
final AutoDisposeStreamProviderFamily<CourseCollection?, String> _syncCourseStreamProvider =
    AutoDisposeStreamProviderFamily<CourseCollection?, String>((ref, arg) {
      // ref.onDispose(() => log("Disposed StreamProvider ${arg}"));
      // can improve by putting ref.keepAlive()
      return CourseCollectionRepo.watchCollectionById(arg);
    });
final AsyncNotifierProvider<CollectionNotifier, CourseCollection> _collectionProvider = AsyncNotifierProvider(
  CollectionNotifier.new,
);

class CollectionsProviders {
  static AsyncNotifierProvider<CollectionNotifier, CourseCollection> get courseProvider => _collectionProvider;
}

class CollectionNotifier extends AsyncNotifier<CourseCollection> {
  @override
  Future<CourseCollection> build() async {
    final String? collectionId = ref.watch(_activeCollectionIdProvider);
    if (collectionId == null) {
      return defaultCollection;
    } else {
      final asyncCourse = ref.watch(_syncCourseStreamProvider(collectionId));

      return asyncCourse.when(
        data: (data) => data ?? defaultCollection,
        error: (e, st) => defaultCollection,
        loading: () => defaultCollection,
      );
    }
  }

  void updateCourse(CourseCollection value) async {
    ref.read(_activeCollectionIdProvider.notifier).update((cb) => value.collectionId);
  }
}
