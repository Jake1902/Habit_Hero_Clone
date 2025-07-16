import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import 'habit_repository.dart';
import 'models/habit.dart';
import 'preferences_service.dart';

final habitRepoProvider = Provider<HabitRepository>((ref) => HabitRepository());

final habitListProvider = StreamProvider<List<Habit>>(
  (ref) => ref.watch(habitRepoProvider).watchHabits(),
);

final newRecordProvider = StreamProvider<String>(
  (ref) => ref.watch(habitRepoProvider).newRecordStream(),
);

class ThemeModeNotifier extends StateNotifier<ThemeMode> {
  ThemeModeNotifier() : super(ThemeMode.system) {
    _load();
  }

  Future<void> _load() async {
    state = await PreferencesService.getThemeMode();
  }

  Future<void> setTheme(ThemeMode mode) async {
    state = mode;
    await PreferencesService.setThemeMode(mode);
  }
}

final themeModeProvider =
    StateNotifierProvider<ThemeModeNotifier, ThemeMode>((ref) {
  return ThemeModeNotifier();
});
