import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';

import '../../core/data/models/habit.dart';
import '../../core/data/providers.dart';
import 'widgets/color_picker_grid.dart';
import 'widgets/icon_picker_sheet.dart';

class AddEditHabitScreen extends ConsumerStatefulWidget {
  final String? habitId;
  const AddEditHabitScreen({super.key, this.habitId});

  @override
  ConsumerState<AddEditHabitScreen> createState() => _AddEditHabitScreenState();
}

class _AddEditHabitScreenState extends ConsumerState<AddEditHabitScreen> {
  final _nameController = TextEditingController();
  final _descController = TextEditingController();
  String _icon = '🔥';
  int _color = 0xFF9E4DFF;
  bool get _isEditing => widget.habitId != null;

  @override
  void initState() {
    super.initState();
    if (_isEditing) {
      final repo = ref.read(habitRepoProvider);
      repo.getHabits().then((habits) {
        final h = habits.firstWhere((e) => e.id == widget.habitId);
        _nameController.text = h.name;
        _descController.text = h.description;
        _icon = h.icon;
        _color = h.colorValue;
        setState(() {});
      });
    }
  }

  @override
  void dispose() {
    _nameController.dispose();
    _descController.dispose();
    super.dispose();
  }

  Future<void> _save() async {
    final repo = ref.read(habitRepoProvider);
    final name = _nameController.text.trim();
    final desc = _descController.text.trim();
    if (_isEditing) {
      final habit = Habit(
        id: widget.habitId!,
        name: name,
        description: desc,
        icon: _icon,
        colorValue: _color,
      );
      await repo.updateHabit(habit);
    } else {
      final habit = Habit(
        id: DateTime.now().millisecondsSinceEpoch.toString(),
        name: name,
        description: desc,
        icon: _icon,
        colorValue: _color,
      );
      await repo.addHabit(habit);
    }
    if (mounted) context.pop();
  }

  Future<void> _onMenu(String value) async {
    final repo = ref.read(habitRepoProvider);
    final id = widget.habitId!;
    switch (value) {
      case 'archive':
        await repo.archiveHabit(id);
        break;
      case 'delete':
        await repo.deleteHabit(id);
        break;
    }
    if (mounted) context.pop();
  }

  void _pickIcon() {
    showModalBottomSheet(
      context: context,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(24)),
      ),
      builder: (_) => IconPickerSheet(
        onSelected: (icon) {
          setState(() => _icon = icon);
          Navigator.pop(context);
        },
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final valid = _nameController.text.trim().isNotEmpty;
    return Scaffold(
      backgroundColor: Theme.of(context).colorScheme.background,
      body: CustomScrollView(
        slivers: [
          SliverAppBar(
            title: Text(_isEditing ? 'Edit Habit' : 'New Habit'),
            actions: [
              if (_isEditing)
                PopupMenuButton<String>(
                  onSelected: _onMenu,
                  itemBuilder: (_) => const [
                    PopupMenuItem(value: 'archive', child: Text('Archive')),
                    PopupMenuItem(value: 'delete', child: Text('Delete')),
                  ],
                ),
            ],
          ),
          SliverToBoxAdapter(
            child: Padding(
              padding: const EdgeInsets.all(24),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  GestureDetector(
                    onTap: _pickIcon,
                    child: CircleAvatar(
                      radius: 32,
                      backgroundColor: Color(_color),
                      child: Text(_icon, style: const TextStyle(fontSize: 32)),
                    ),
                  ),
                  const SizedBox(height: 24),
                  TextField(
                    controller: _nameController,
                    onChanged: (_) => setState(() {}),
                    decoration: const InputDecoration(labelText: 'Name'),
                  ),
                  const SizedBox(height: 16),
                  TextField(
                    controller: _descController,
                    decoration: const InputDecoration(labelText: 'Description'),
                  ),
                  const SizedBox(height: 16),
                  ColorPickerGrid(
                    selected: _color,
                    onChanged: (c) => setState(() => _color = c),
                  ),
                  const SizedBox(height: 16),
                  ExpansionTile(
                    title: const Text('Advanced options'),
                    children: const [
                      ListTile(title: Text('Target per day')),
                      ListTile(title: Text('Reminder')),
                    ],
                  ),
                  const SizedBox(height: 80),
                ],
              ),
            ),
          ),
        ],
      ),
      bottomNavigationBar: Padding(
        padding: const EdgeInsets.all(16),
        child: SizedBox(
          height: 56,
          width: double.infinity,
          child: ElevatedButton(
            onPressed: valid ? _save : null,
            style: ElevatedButton.styleFrom(
              backgroundColor: Theme.of(context).colorScheme.primary,
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(12),
              ),
            ),
            child: const Text('Save'),
          ),
        ),
      ),
    );
  }
}
