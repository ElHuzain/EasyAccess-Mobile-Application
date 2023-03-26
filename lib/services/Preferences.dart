// Shared preferences
// To store value in local storage.
import 'package:shared_preferences/shared_preferences.dart';

class Preferences {
  static Future<void> setPref(String key, dynamic value) async {
    final prefs = await SharedPreferences.getInstance();
    prefs.setString(key, value);
  }

  static Future<void> setPrefList(String key, List<String> value) async {
    final prefs = await SharedPreferences.getInstance();
    prefs.setStringList(key, value);
  }

// Retrieve previously stored value. If non, return null.
  static Future<dynamic> getPref(String key) async {
    final prefs = await SharedPreferences.getInstance();
    var value = await prefs.getString(key);
    if (value == null)
      return "null";
    else
      return value;
  }

  static Future<List<String>> getPrefList(String key) async {
    final prefs = await SharedPreferences.getInstance();
    List<String>? value = await prefs.getStringList(key);
    if (value == null)
      return [];
    else
      return value;
  }

// Remove key from local storage
  static Future<void> removePref(String key) async {
    final prefs = await SharedPreferences.getInstance();
    prefs.remove(key);
  }
}
