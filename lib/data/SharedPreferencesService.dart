import 'package:shared_preferences/shared_preferences.dart';


class SharedPreferencesService {
  SharedPreferences? _preferences;

  Future<void> _initialize() async {
    _preferences = await SharedPreferences.getInstance();
  }

  dynamic getFromDisk(String key) async {
    _preferences ?? await _initialize();
    var value = _preferences?.get(key);
    return value;
  }

  void saveToDisk<T>(String key, T content) async {
    print("Save to disk");
    _preferences ?? await _initialize();

    if (content is String) {
      _preferences?.setString(key, content);
    }

    if (content is bool) {
      _preferences?.setBool(key, content);
    }
    if (content is int) {
      _preferences?.setInt(key, content);
    }
    if (content is double) {
      _preferences?.setDouble(key, content);
    }
    if (content is List<String>) {
      _preferences?.setStringList(key, content);
    }
  }

  Future<bool> clearAll() async {
    _preferences ?? await _initialize();
    return await _preferences?.clear() ?? false;
  }
}
