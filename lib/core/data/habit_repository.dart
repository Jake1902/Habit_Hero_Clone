import 'dart:async';

import 'models/habit.dart';
import 'preferences_service.dart';

class HabitRepository {
  final _controller = StreamController<List<Habit>>.broadcast();
  List<Habit> _cache = [];

  HabitRepository() {
    _load();
  }

  void _emit() {
    _controller.add(List.unmodifiable(_cache));
  }

  Future<void> _load() async {
    final jsonList = PreferencesService.readHabitListJson();
    _cache = jsonList.map((e) => Habit.fromJson(e)).toList();
    _emit();
  }

  Future<void> _save() async {
    await PreferencesService
        .saveHabitListJson(_cache.map((e) => e.toJson()).toList());
    _emit();
  }

  Future<List<Habit>> getHabits() async {
    return List.unmodifiable(_cache);
  }

  Future<void> addHabit(Habit h) async {
    _cache.add(h);
    await _save();
  }

  Future<void> updateHabit(Habit h) async {
    final index = _cache.indexWhere((e) => e.id == h.id);
    if (index != -1) {
      _cache[index] = h;
      await _save();
    }
  }

  Future<void> deleteHabit(String id) async {
    _cache.removeWhere((e) => e.id == id);
    await _save();
  }

  Future<void> toggleCompletion(String habitId, DateTime date) async {
    final key = date.toIso8601String().split('T').first;
    final map = PreferencesService.readCompletionsJson(habitId);
    if (map.containsKey(key)) {
      map.remove(key);
    } else {
      map[key] = 1;
    }
    await PreferencesService.saveCompletionsJson(habitId, map);
  }

  Stream<List<Habit>> watchHabits() => _controller.stream;
}
