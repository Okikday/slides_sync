import 'dart:convert';
import 'dart:math';
import 'dart:typed_data';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:hive_flutter/hive_flutter.dart';

class AppHiveData {
  static AppHiveData instance = AppHiveData._internal();

  static late Box _box;
  static late Box _secureBox;

  final List<int> _generateHiveKey = List<int>.generate(32, (i) => Random.secure().nextInt(256));

  final FlutterSecureStorage _secureStorage = const FlutterSecureStorage();

  AppHiveData._internal();

  /// Initialize HiveData instance
  initialize() async {
    await _initHiveData();
    await _initSecureHiveData();
  }

  // Initialize regular Hive box
  Future<void> _initHiveData() async {
    _box = await Hive.openBox("box");
  }

  // Initialize secure Hive box with encryption
  Future<void> _initSecureHiveData() async {
    final String? savedHiveKey = await _secureStorage.read(key: 'hiveKey');

    //If savedHiveKey exists
    if (savedHiveKey != null) {
      final Uint8List hiveKey = base64Url.decode(savedHiveKey);
      _secureBox = await Hive.openBox("secureBox", encryptionCipher: HiveAesCipher(hiveKey));
    } else {
      final List<int> hiveKey = _generateHiveKey;
      await _secureStorage.write(key: 'hiveKey', value: base64Url.encode(hiveKey));
      _secureBox = await Hive.openBox("secureBox", encryptionCipher: HiveAesCipher(hiveKey));
    }
  }

  Future<dynamic> getData({required String key}) async => await _box.get(key);

  Future<void> setData({required String key, required dynamic value}) async => await _box.put(key, value);

  Future<void> deleteData({required String key}) async => await _box.delete(key);

  Stream<dynamic> watchChanges<T>({required String key}) async* {
    yield* _box.watch(key: key);
  }

  Stream<T> watchData<T>({required String key}) async* {
    yield (await getData(key: key)) as T;
    yield* _box.watch(key: key).asyncMap((_) async {
      return (await getData(key: key)) as T;
    });
  }

  Future<void> setSecureData({required String key, required dynamic value}) async {
    final String? savedHiveKey = await _secureStorage.read(key: 'hiveKey');
    if (savedHiveKey != null) {
      if (_secureBox.isOpen) {
        await _secureBox.put(key, value);
      } else {
        final hiveKey = base64Url.decode(savedHiveKey);
        _secureBox = await Hive.openBox("secureBox", encryptionCipher: HiveAesCipher(hiveKey));
        await _secureBox.put(key, value);
      }
    }
  }

  Future<dynamic> getSecureData({required String key}) async {
    final String? savedHiveKey = await _secureStorage.read(key: 'hiveKey');
    if (savedHiveKey != null) {
      if (_secureBox.isOpen) {
        return _secureBox.get(key);
      } else {
        final hiveKey = base64Url.decode(savedHiveKey);
        _secureBox = await Hive.openBox("secureBox", encryptionCipher: HiveAesCipher(hiveKey));
        return _secureBox.get(key);
      }
    }
    return null;
  }
}
