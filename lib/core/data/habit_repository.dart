import 'dart:async';

import 'models/habit.dart';
import 'preferences_service.dart';

class HabitRepository {
  final _controller = StreamController<List<Habit>>.broadcast();
  List<Habit> _cache = [];

  HabitRepository() {
    _load();
  }

  List<Habit> _activeHabits() =>
      _cache.where((h) => !h.archived).toList();

  void _emit() {
    _controller.add(List.unmodifiable(_activeHabits()));
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
    return List.unmodifiable(_activeHabits());
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

  Future<void> archiveHabit(String id) async {
    final idx = _cache.indexWhere((h) => h.id == id);
    if (idx == -1) return;
    final h = _cache[idx];
    _cache[idx] = Habit(
      id: h.id,
      name: h.name,
      description: h.description,
      icon: h.icon,
      colorValue: h.colorValue,
      targetPerDay: h.targetPerDay,
      archived: true,
      createdAt: h.createdAt,
    );
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
