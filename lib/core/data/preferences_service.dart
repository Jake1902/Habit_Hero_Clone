import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';

class PreferencesService {
  static const _firstLaunchKey = 'firstLaunch';
  static const _themeModeKey = 'themeMode';
  static const _longestPrefix = 'streak_longest_';
  static late SharedPreferences _prefs;

  static Future<void> init() async {
    _prefs = await SharedPreferences.getInstance();
  }

  static Future<bool> isFirstLaunch() async {
    return _prefs.getBool(_firstLaunchKey) ?? true;
  }

  static Future<void> setFirstLaunchFalse() async {
    await _prefs.setBool(_firstLaunchKey, false);
  }

  static Future<ThemeMode> getThemeMode() async {
    final value = _prefs.getString(_themeModeKey);
    switch (value) {
      case 'light':
        return ThemeMode.light;
      case 'dark':
        return ThemeMode.dark;
      default:
        return ThemeMode.system;
    }
  }

  static Future<void> setThemeMode(ThemeMode mode) async {
    String value = 'system';
    if (mode == ThemeMode.light) value = 'light';
    if (mode == ThemeMode.dark) value = 'dark';
    await _prefs.setString(_themeModeKey, value);
  }

  static List<Map<String, dynamic>> readHabitListJson() {
    final str = _prefs.getString('habits');
    if (str == null || str.isEmpty) return [];
    final List list = jsonDecode(str) as List;
    return List<Map<String, dynamic>>.from(list);
  }

  static Future<void> saveHabitListJson(List<Map<String, dynamic>> list) async {
    await _prefs.setString('habits', jsonEncode(list));
  }

  static Map<String, dynamic> readCompletionsJson(String habitId) {
    final str = _prefs.getString('completions_$habitId');
    if (str == null || str.isEmpty) return {};
    return Map<String, dynamic>.from(jsonDecode(str) as Map);
  }

  static Future<void> saveCompletionsJson(
      String habitId, Map<String, dynamic> map) async {
    await _prefs.setString('completions_$habitId', jsonEncode(map));
  }

  static int getLongestStreak(String habitId) =>
      _prefs.getInt('$_longestPrefix$habitId') ?? 0;

  static Future<void> setLongestStreak(String habitId, int v) =>
      _prefs.setInt('$_longestPrefix$habitId', v);
}
