import 'package:shared_preferences/shared_preferences.dart';

class LocalStorage {
  final SharedPreferences? _sh;
  static LocalStorage? _instance;

// return the single instance of LocalStorage hence reduce the await call to get shared preference.
  static Future<LocalStorage> getInstance() async {
    if (_instance == null) {
      final sharedPreferences = await SharedPreferences.getInstance();
      _instance = LocalStorage._(sharedPreferences);
    }
    return _instance!;
  }

  LocalStorage._(SharedPreferences sharedPreferences) : _sh = sharedPreferences;

  Future setScore({required int tileCount, required int score}) async {
    return await _sh?.setInt(tileCount.toString(), score);
  }

  int? getScore(int tileCount) {
    return _sh?.getInt(tileCount.toString());
  }

  Future<bool?> clearAll() async {
    return _sh?.clear();
  }
}
