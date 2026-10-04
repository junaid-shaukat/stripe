import 'dart:convert';
import 'dart:typed_data';

import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:hive_ce_flutter/hive_flutter.dart';

class HiveEncryptionKey {
  HiveEncryptionKey._();

  static const String _key = 'seyanah_hive_encryption_key';

  static const FlutterSecureStorage _storage = FlutterSecureStorage();

  static Future<Uint8List> getOrCreate() async {
    final storedKey = await _storage.read(key: _key);

    if (storedKey != null && storedKey.isNotEmpty) {
      final key = base64Url.decode(storedKey);

      _validateKey(key);

      return Uint8List.fromList(key);
    }

    final key = Hive.generateSecureKey();

    _validateKey(key);

    await _storage.write(key: _key, value: base64UrlEncode(key));

    return Uint8List.fromList(key);
  }

  static void _validateKey(List<int> key) {
    if (key.length != 32) {
      throw StateError(
        'Invalid Hive encryption key. '
        'Expected 32 bytes, got ${key.length}.',
      );
    }
  }

  static Future<void> delete() async {
    await _storage.delete(key: _key);
  }
}
