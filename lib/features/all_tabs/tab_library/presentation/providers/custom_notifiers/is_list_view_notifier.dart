import 'dart:developer';

import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:slides_sync/core/storage/hive_data/app_hive_data.dart';

class CardViewTypeNotifier extends AutoDisposeAsyncNotifier<int> {
  CardViewTypeNotifier(this._key, this._maxType);

  final String _key;
  final int _maxType;

  @override
  Future<int> build() async {
    final value = await AppHiveData.instance.getData(key: _key);
    return value is int ? value : 0;
  }

  Future<void> toggle() async {
    final current = (state.value ?? 0) + 1;
    final toSet = current < 0 || current > (_maxType - 1) ? 0 : current;
    state = AsyncData(toSet);
    await AppHiveData.instance.setData(key: _key, value: toSet);
  }

  /// 0 for Grid, 1 for List, 2 for otherwise
  Future<int> updateType(int cb) async {
    final current = state.value ?? 0;
    if (current == cb) return cb;
    state = AsyncData(cb);
    await AppHiveData.instance.setData(key: _key, value: cb);
    return cb;
  }
}
