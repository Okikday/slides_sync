import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:slides_sync/data/hive_data/app_hive_data.dart';

import '../../../../../data/hive_data/hive_data_paths.dart';

class IsListViewNotifier extends AsyncNotifier<bool> {
  final String _key = "${HiveDataPaths.views}/library/all_courses_section/var/isListView";

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