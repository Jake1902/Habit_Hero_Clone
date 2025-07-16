import 'package:flutter_riverpod/flutter_riverpod.dart';

import 'habit_repository.dart';
import 'models/habit.dart';

final habitRepoProvider = Provider<HabitRepository>((ref) => HabitRepository());

final habitListProvider = StreamProvider<List<Habit>>(
  (ref) => ref.watch(habitRepoProvider).watchHabits(),
);
