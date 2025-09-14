import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:slides_sync/core/routes/app_route_navigator.dart';
import 'package:slides_sync/core/storage/hive_data/app_hive_data.dart';
import 'package:slides_sync/core/storage/hive_data/hive_data_paths.dart';
import 'package:slides_sync/core/utils/result.dart';
import 'package:slides_sync/core/utils/ui_utils.dart';
import 'package:slides_sync/domain/repos/course_repo/course_content_repo.dart';

class RecentDialogActions {
  final WidgetRef ref;
  RecentDialogActions._(this.ref);
  static RecentDialogActions of(WidgetRef ref) => RecentDialogActions._(ref);

  Future<void> onRemoveFromRecents(String contentId) async {
    final context = ref.context;
    // final contentId = contentId;
    if (context.mounted) UiUtils.hideDialog(context);
    final resultRemoveFromRecents = await removeIdFromRecents(contentId);
    if (context.mounted) {
      if (resultRemoveFromRecents) {
        await UiUtils.showFlushBar(context, msg: "Removed from recent reads!", vibe: FlushbarVibe.none);
      } else {
        await UiUtils.showFlushBar(context, msg: "Unable to remove from recents", vibe: FlushbarVibe.error);
      }
    }
  }

  static Future<bool> removeIdFromRecents(String contentId) async {
    return (await Result.tryRunAsync(() async {
          final hiveInstance = AppHiveData.instance;
          final rawOldRecents = (await hiveInstance.getData(key: HiveDataPaths.recentContentsIds)) as List<String>?;
          if (rawOldRecents == null) {
            return false;
          } else {
            List<String> recents = List.from(rawOldRecents);
            if (recents.contains(contentId)) {
              recents.remove(contentId);
              await hiveInstance.setData(key: HiveDataPaths.recentContentsIds, value: recents);
              return true;
            }
            return false;
          }
        })).data ??
        false;
  }

  Future<void> onContinueReading(String contentId) async {
    final context = ref.context;
    final newContent = await CourseContentRepo.getByContentId(contentId);
    if (context.mounted) UiUtils.hideDialog(context);
    if (newContent == null) {
      if (context.mounted) {
        UiUtils.showFlushBar(context, msg: "Unable to open material");
      }
      return;
    }
    if (context.mounted) AppRouteNavigator.to(context).contentViewGateRoute(newContent);
  }
}
