import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:slides_sync/core/storage/hive_data/app_hive_data.dart';

class ToggleNotifier extends AutoDisposeAsyncNotifier<bool> {
  ToggleNotifier(this._key, {this.defaultValue = false});

  final String _key;
  final bool defaultValue;

  @override
  Future<bool> build() async {
    final value = await AppHiveData.instance.getData(key: _key);
    return value is bool ? value : defaultValue;
  }

  Future<void> toggle() async {
    final current = !(state.value ?? defaultValue);
    state = AsyncData(current);
    await AppHiveData.instance.setData(key: _key, value: current);
  }

  Future<bool> updateType(bool Function(bool? state) cb) async {
    final current = state.value ?? defaultValue;
    if (current == cb(state.value)) return cb(state.value);
    state = AsyncData(cb(state.value));
    await AppHiveData.instance.setData(key: _key, value: cb);
    return cb(state.value);
  }
}
