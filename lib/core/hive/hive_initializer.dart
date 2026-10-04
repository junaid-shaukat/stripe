import 'dart:typed_data';

import 'package:hive_ce_flutter/hive_flutter.dart';

import '../utils/console.dart';
import 'hive_boxes.dart';
import 'hive_encryption_key.dart';

class HiveInitializer {
  HiveInitializer._();

  static HiveCipher? _cipher;
  static Future<void>? _initialization;

  /// Hive box registry.
  ///
  /// `safeOpen` is a function that receives the encryption cipher.
  /// It is NOT executed when this list is initialized.
  static final List<Map<String, dynamic>> boxes = [
    {
      'name': HiveBoxes.preference,
      'safeOpen': (HiveCipher cipher) =>
          safeOpen<Box>(HiveBoxes.preference, cipher),
      'clear': () => Hive.box<Box>(HiveBoxes.preference).clear(),
    },
  ];
  // ============================================================
  // INITIALIZATION
  // ============================================================

  static Future<void> initialize() {
    return _initialization ??= _initialize();
  }

  static Future<void> _initialize() async {
    try {
      await Hive.initFlutter();

      final Uint8List encryptionKey = await HiveEncryptionKey.getOrCreate();

      _cipher = HiveAesCipher(encryptionKey);

      await _openBoxes(_cipher!);
    } catch (e, stackTrace) {
      console.error('Hive initialization failed: $e');

      console.error(stackTrace.toString());

      // Allow initialization to be retried.
      _initialization = null;

      rethrow;
    }
  }

  // ============================================================
  // OPEN BOXES
  // ============================================================

  static Future<void> _openBoxes(HiveCipher cipher) async {
    final entries = <Future<void>>[];

    for (final box in boxes) {
      final safeOpen = box['safeOpen'] as Future<void> Function(HiveCipher);

      entries.add(safeOpen(cipher));
    }

    await Future.wait(entries);
  }

  // ============================================================
  // SAFE OPEN
  // ============================================================

  static Future<void> safeOpen<T>(String name, HiveCipher? cipher) async {
    try {
      await Hive.openBox<T>(name, encryptionCipher: cipher);

      console.log('Hive box "$name" opened successfully.');
    } catch (e) {
      console.error('Hive box "$name" failed to open: $e');

      // --------------------------------------------------------
      // Close box if it is partially open.
      // --------------------------------------------------------

      try {
        if (Hive.isBoxOpen(name)) {
          await Hive.box<T>(name).close();
        }
      } catch (closeError) {
        console.error('Failed to close Hive box "$name": $closeError');
      }

      // --------------------------------------------------------
      // Delete and recreate corrupted box.
      // --------------------------------------------------------

      try {
        await Hive.deleteBoxFromDisk(name);

        console.log('Hive box "$name" deleted for recovery.');

        await Hive.openBox<T>(name, encryptionCipher: cipher);

        console.log('Hive box "$name" recovered successfully.');
      } catch (recoveryError) {
        console.error(
          'Failed to recover Hive box "$name": '
          '$recoveryError',
        );

        rethrow;
      }
    }
  }

  // ============================================================
  // GET CIPHER
  // ============================================================

  static HiveCipher get cipher {
    final value = _cipher;

    if (value == null) {
      throw StateError('HiveInitializer.initialize() must be called first.');
    }

    return value;
  }

  // ============================================================
  // STATUS
  // ============================================================

  static bool get isInitialized {
    return _cipher != null;
  }

  // ============================================================
  // CLEAR ALL BOX DATA
  // ============================================================

  /// Clears the data from all currently opened Hive boxes.
  ///
  /// The boxes themselves remain open.
  static Future<void> clearAllBoxes() async {
    for (final box in boxes) {
      final name = box['name'] as String;

      try {
        if (!Hive.isBoxOpen(name)) {
          continue;
        }

        final clear = box['clear'] as Future<dynamic> Function();

        await clear();

        console.log('Hive box "$name" cleared successfully.');
      } catch (e) {
        console.error('Failed to clear Hive box "$name": $e');
      }
    }
  }

  // ============================================================
  // CLEAR SINGLE BOX
  // ============================================================

  static Future<void> clearBox(String name) async {
    final box = boxes.cast<Map<String, dynamic>?>().firstWhere(
      (item) => item?['name'] == name,
      orElse: () => null,
    );

    if (box == null) {
      console.error('Hive box "$name" is not registered.');
      return;
    }

    try {
      if (!Hive.isBoxOpen(name)) {
        console.error('Hive box "$name" is not open.');
        return;
      }

      final clear = box['clear'] as Future<dynamic> Function();

      await clear();

      console.log('Hive box "$name" cleared successfully.');
    } catch (e) {
      console.error('Failed to clear Hive box "$name": $e');
    }
  }

  // ============================================================
  // CLOSE ALL BOXES
  // ============================================================

  static Future<void> closeAllBoxes() async {
    for (final box in boxes) {
      final name = box['name'] as String;

      try {
        if (Hive.isBoxOpen(name)) {
          await Hive.box(name).close();

          console.log('Hive box "$name" closed.');
        }
      } catch (e) {
        console.error('Failed to close Hive box "$name": $e');
      }
    }

    _cipher = null;
  }

  // ============================================================
  // DELETE ALL BOXES FROM DISK
  // ============================================================

  /// WARNING:
  /// Permanently deletes every registered Hive box from disk.
  static Future<void> deleteAllBoxes() async {
    for (final box in boxes) {
      final name = box['name'] as String;

      try {
        if (Hive.isBoxOpen(name)) {
          await Hive.box(name).close();
        }

        await Hive.deleteBoxFromDisk(name);

        console.log('Hive box "$name" deleted.');
      } catch (e) {
        console.error('Failed to delete Hive box "$name": $e');
      }
    }

    _cipher = null;
  }
}
