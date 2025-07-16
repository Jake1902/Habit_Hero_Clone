part of 'home_screen.dart';

import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';

import '../../core/data/models/habit.dart';
import '../../core/data/providers.dart';
import '../../core/data/preferences_service.dart';
import '../../core/streak/streak_service.dart';
import 'heatmap_widget.dart';

final _currentHabit = Provider<Habit>((ref) => throw UnimplementedError());

class HabitHeatmapCard extends ConsumerWidget {
  const HabitHeatmapCard({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final habit = ref.watch(_currentHabit);
    final repo = ref.read(habitRepoProvider);
    final map = PreferencesService.readCompletionsJson(habit.id);
    final completions = map.map((k, v) => MapEntry(DateTime.parse(k), v as int));
    final (current, _) = StreakService.compute(completions);

    void showMenu() {
      showModalBottomSheet(
        context: context,
        shape: const RoundedRectangleBorder(
          borderRadius: BorderRadius.vertical(top: Radius.circular(24)),
        ),
        builder: (_) => SafeArea(
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              ListTile(
                leading: const Icon(Icons.edit),
                title: const Text('Edit'),
                onTap: () {
                  Navigator.pop(context);
                  context.push('/edit/${habit.id}');
                },
              ),
              ListTile(
                leading: const Icon(Icons.archive_outlined),
                title: const Text('Archive'),
                onTap: () async {
                  await repo.archiveHabit(habit.id);
                  Navigator.pop(context);
                },
              ),
            ],
          ),
        ),
      );
    }

    return GestureDetector(
      onLongPress: showMenu,
      onTap: () => context.push('/edit/${habit.id}'),
      child: Card(
        color: const Color(0xFF1E1E1E),
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
        child: Padding(
          padding: const EdgeInsets.all(16),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Row(
                children: [
                  CircleAvatar(
                    backgroundColor: Color(habit.colorValue),
                    child: Text(habit.icon, style: const TextStyle(fontSize: 24)),
                  ),
                  const SizedBox(width: 12),
                  Expanded(
                    child: Text(
                      habit.name,
                      style: Theme.of(context).textTheme.titleMedium,
                    ),
                  ),
                  Text('🔥 $current', style: Theme.of(context).textTheme.labelLarge),
                ],
              ),
              const SizedBox(height: 12),
              HeatMapWidget(
                data: completions,
                accent: Color(habit.colorValue),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

