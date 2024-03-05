import 'package:shared_preferences/shared_preferences.dart';

class Prefs {
  static late SharedPreferences prefs;

  // call this method from iniState() function of mainApp().
  static Future<SharedPreferences> init() async {
    prefs = await SharedPreferences.getInstance();
    return prefs;
  }

  //sets
  static Future<bool> setBool(String key, bool value) async =>
      await prefs.setBool(key, value);

  static Future<bool> setDouble(String key, double value) async =>
      await prefs.setDouble(key, value);

  static Future<bool> setInt(String key, int value) async =>
      await prefs.setInt(key, value);

  static Future<bool> setString(String key, String value) async =>
      await prefs.setString(key, value);

  static Future<bool> setStringList(String key, List<String> value) async =>
      await prefs.setStringList(key, value);

  //gets
  static bool getBool(String key) => prefs.getBool(key)!;

  static double getDouble(String key) => prefs.getDouble(key)!;

  static int getInt(String key) => prefs.getInt(key)!;

  static String getString(String key) => prefs.getString(key)!;

  static List<String> getStringList(String key) => prefs.getStringList(key)!;

  //deletes..
  static Future<bool> remove(String key) async => await prefs.remove(key);

  static Future<bool> clear() async => await prefs.clear();
}


