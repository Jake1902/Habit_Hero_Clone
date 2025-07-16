import 'package:flutter_test/flutter_test.dart';
import 'package:habit_hero_app/core/streak/streak_service.dart';
import 'package:flutter/material.dart';

void main() {
  TestWidgetsFlutterBinding.ensureInitialized();

  test('empty completions', () {
    expect(StreakService.compute({}), (0, 0));
  });

  test('single day streak', () {
    final today = DateUtils.dateOnly(DateTime.now());
    expect(StreakService.compute({today: 1}), (1, 1));
  });

  test('gaps reset streak', () {
    final today = DateUtils.dateOnly(DateTime.now());
    final data = {
      today.subtract(const Duration(days: 2)): 1,
      today.subtract(const Duration(days: 4)): 1,
    };
    expect(StreakService.compute(data), (0, 1));
  });

  test('consecutive days record', () {
    final today = DateUtils.dateOnly(DateTime.now());
    final data = {
      for (int i = 0; i < 3; i++) today.subtract(Duration(days: i)): 1,
    };
    expect(StreakService.compute(data), (3, 3));
  });
}
