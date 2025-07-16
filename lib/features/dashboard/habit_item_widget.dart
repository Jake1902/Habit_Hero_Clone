import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../core/data/models/habit.dart';
import '../../core/data/providers.dart';
import '../../core/data/preferences_service.dart';

class HabitItemWidget extends ConsumerStatefulWidget {
  final Habit habit;
  const HabitItemWidget({super.key, required this.habit});

  @override
  ConsumerState<HabitItemWidget> createState() => _HabitItemWidgetState();
}

class _HabitItemWidgetState extends ConsumerState<HabitItemWidget> {
  bool _checked = false;

  @override
  void initState() {
    super.initState();
    final map = PreferencesService.readCompletionsJson(widget.habit.id);
    final key = DateTime.now().toIso8601String().split('T').first;
    _checked = map.containsKey(key);
  }

  Future<void> _toggle(bool? value) async {
    await ref
        .read(habitRepoProvider)
        .toggleCompletion(widget.habit.id, DateTime.now());
    setState(() {
      _checked = !_checked;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Card(
      child: ListTile(
        leading: CircleAvatar(
          backgroundColor: Color(widget.habit.colorValue),
          child: Text(
            widget.habit.icon,
            style: const TextStyle(fontSize: 24),
          ),
        ),
        title: Text(
          widget.habit.name,
          style: Theme.of(context).textTheme.titleMedium,
        ),
        subtitle: const Text('Streak: 0'),
        trailing: Checkbox(value: _checked, onChanged: _toggle),
      ),
    );
  }
}
