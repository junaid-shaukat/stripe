import '/core/app_export.dart';

class Preference {
  Preference._();
  late Box box;

  static Preference instance = Preference._();

  static String baseUrl = 'http://192.168.1.11:8000';

  String? get publishableKey => box.get('publishable_key');
  String? get merchantIdentifier => box.get('merchant_identifier');
  String? get urlScheme => box.get('url_scheme');

  String? get become => box.get('become');
  String? get accessToken => box.get('access_token');
  String? get countryCode => box.get('country_code');
  String? get refreshToken => box.get('refresh_token');
  String? get languageCode => box.get('language_code');
  String? get currencyCode => box.get('currency_code');
  String? get currencySymbol => box.get('currency_symbol');
  String? get countryPhoneCode => box.get('country_phone_code');
  bool get onboarding => box.get('onboarding', defaultValue: true);

  /// Initialises the Hive box and loads all data (if not already loaded).
  Future<void> init() async {
    box = await Hive.openBox('preferences');
  }

  /// Returns the value for a given key (auto‑init).
  dynamic getKey(dynamic key, {dynamic defaultValue}) {
    return box.get(key, defaultValue: defaultValue);
  }

  /// Clears all data (Hive + cache).
  Future<void> clear() async {
    await box.clear();
  }

  /// Reads all key‑value pairs from Hive into the cache.
  Future<void> readAll() async {
    await init();
  }

  /// Saves a single key. If value is null, deletes the key.
  Future<void> saveKey(dynamic key, dynamic value) async {
    if (value == null) {
      await box.delete(key);
    } else {
      await box.put(key, value);
    }
  }

  /// Saves multiple keys at once and refreshes the cache.
  Future<void> saveKeys(Map<String, dynamic>? entries) async {
    if (entries == null) return;
    for (final entry in entries.entries) {
      if (entry.value == null) {
        await box.delete(entry.key);
      } else {
        await box.put(entry.key, entry.value);
      }
    }
  }

  /// Deletes a specific key.
  Future<void> deleteKey(dynamic key) async {
    await box.delete(key);
  }

  void toJson() {
    console.log(box.toMap(), name: 'Preference');
  }
}
