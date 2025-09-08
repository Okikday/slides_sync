import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:slides_sync/core/storage/hive_data/app_hive_data.dart';

class IsListViewNotifier extends AutoDisposeAsyncNotifier<bool> {
  IsListViewNotifier(this._key);

  final String _key;

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
