import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';

import '../../core/data/models/habit.dart';
import '../../core/data/providers.dart';
import '../../core/data/preferences_service.dart';

class HabitItemWidget extends ConsumerWidget {
  const HabitItemWidget({super.key, required this.habit});
  final Habit habit;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final repo = ref.read(habitRepoProvider);
    return GestureDetector(
      onLongPress: () => showModalBottomSheet(
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
      ),
      child: Card(
        child: ListTile(
          leading: CircleAvatar(
            backgroundColor: Color(habit.colorValue),
            child: Text(habit.icon, style: const TextStyle(fontSize: 24)),
          ),
          title: Text(habit.name),
          trailing: Checkbox(
            value: _isCompletedToday(habit, ref),
            onChanged: (_) => repo.toggleCompletion(habit.id, DateTime.now()),
          ),
          onTap: () => context.push('/edit/${habit.id}'),
        ),
      ),
    );
  }
}

bool _isCompletedToday(Habit habit, WidgetRef ref) {
  final map = PreferencesService.readCompletionsJson(habit.id);
  final key = DateTime.now().toIso8601String().split('T').first;
  return map.containsKey(key);
}
