import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:slides_sync/core/data/hive_data/app_hive_data.dart';

import '../../../../../../core/data/hive_data/hive_data_paths.dart';

class IsPlainViewNotifier extends AsyncNotifier<bool> {
  final String _key = "${HiveDataPaths.views}/library/manage_courses/modify_course/var/isListView";

  @override
  Future<bool> build() async {
    final value = await AppHiveData.instance.getData(key: _key);
    return value is bool ? value : true;
  }

  Future<void> toggle() async {
    final current = state.value ?? true;
    final updated = !current;
    state = AsyncData(updated);
    await AppHiveData.instance.setData(key: _key, value: updated);
  }
}
