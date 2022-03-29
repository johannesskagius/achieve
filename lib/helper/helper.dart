import 'package:flutter/cupertino.dart';
import 'package:shared_preferences/shared_preferences.dart';

class Helper {
  static String _getToday() {
    final now = DateTime.now();
    String month = now.month.toString();
    if (now.month < 10) {
      month = '0' + now.month.toString();
    }
    return now.day.toString() + month + now.year.toString();
  }

  static void saveString(String _key, String _value) async {
    final _shared = await SharedPreferences.getInstance();
    _shared.setString(_key, _value);
  }

  static Future<String?> getString(String _key) async {
    final _shared = await SharedPreferences.getInstance();
    return _shared.getString(_key);
  }

  static void unFocus(){
    WidgetsBinding.instance?.focusManager.primaryFocus?.unfocus();
  }
}
