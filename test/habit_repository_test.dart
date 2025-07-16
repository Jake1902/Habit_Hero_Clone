import 'package:flutter_test/flutter_test.dart';
import 'package:shared_preferences/shared_preferences.dart';

import 'package:habit_hero_app/core/data/habit_repository.dart';
import 'package:habit_hero_app/core/data/models/habit.dart';
import 'package:habit_hero_app/core/data/preferences_service.dart';

void main() {
  TestWidgetsFlutterBinding.ensureInitialized();

  setUp(() async {
    SharedPreferences.setMockInitialValues({});
    await PreferencesService.init();
  });

  test('addHabit persists and getHabits returns list', () async {
    final repo = HabitRepository();
    final habit = Habit(
      id: '1',
      name: 'Drink Water',
      icon: '💧',
      colorValue: 0xFFFFFFFF,
    );
    await repo.addHabit(habit);

    final stored = PreferencesService.readHabitListJson();
    expect(stored.length, 1);
    expect(stored.first['id'], habit.id);

    final habits = await repo.getHabits();
    expect(habits.length, 1);
    expect(habits.first.id, habit.id);
  });
}
