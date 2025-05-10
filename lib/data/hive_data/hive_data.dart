import 'package:hive_flutter/hive_flutter.dart';

class HiveData {
  late final String _boxName;
  late Box _box;
  bool _isInitialized = false;

  HiveData(this._boxName);

  Future<void> _initialize() async {
    if (!_isInitialized) {
      _box = await Hive.openBox(_boxName);
      _isInitialized = true;
    }
  }

  Future<dynamic> getData({required String key}) async {
    await _initialize();
    return _box.get(key);
  }

  Future<void> setData({required String key, required dynamic value}) async {
    await _initialize();
    await _box.put(key, value);
  }

  Future<void> deleteData({required String key}) async {
    await _initialize();
    await _box.delete(key);
  }
}
