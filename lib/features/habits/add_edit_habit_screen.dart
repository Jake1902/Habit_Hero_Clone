import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';

import '../../core/data/models/habit.dart';
import '../../core/data/providers.dart';
import '../habits/widgets/color_picker_grid.dart';
import '../habits/widgets/icon_picker_sheet.dart';
import '../../core/widgets/primary_button.dart';

const kAccent = Color(0xFF9E4DFF);
const kBg = Color(0xFF121212);
const kCard = Color(0xFF1E1E1E);

class AddEditHabitScreen extends ConsumerStatefulWidget {
  final String? habitId;
  const AddEditHabitScreen({super.key, this.habitId});

  @override
  ConsumerState<AddEditHabitScreen> createState() => _AddEditHabitScreenState();
}

class _AddEditHabitScreenState extends ConsumerState<AddEditHabitScreen> {
  final _nameController = TextEditingController();
  final _descController = TextEditingController();
  int _color = kAccent.value;
  String _icon = '🔥';
  int _target = 1;
  int _mode = 0;

  bool get _isEditing => widget.habitId != null;

  @override
  void initState() {
    super.initState();
    if (_isEditing) {
      final repo = ref.read(habitRepoProvider);
      repo.getHabits().then((list) {
        final h = list.firstWhere((e) => e.id == widget.habitId);
        _nameController.text = h.name;
        _descController.text = h.description;
        _icon = h.icon;
        _color = h.colorValue;
        _target = h.targetPerDay;
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

  void _pickIcon() {
    showModalBottomSheet(
      context: context,
      backgroundColor: Colors.transparent,
      isScrollControlled: true,
      builder: (_) => IconPickerSheet(
        onSelected: (icon) {
          setState(() => _icon = icon);
          Navigator.pop(context);
        },
      ),
    );
  }

  Future<void> _save() async {
    final name = _nameController.text.trim();
    final desc = _descController.text.trim();
    final repo = ref.read(habitRepoProvider);
    if (_isEditing) {
      final habit = Habit(
        id: widget.habitId!,
        name: name,
        description: desc,
        icon: _icon,
        colorValue: _color,
        targetPerDay: _target,
      );
      await repo.updateHabit(habit);
    } else {
      final habit = Habit(
        id: DateTime.now().millisecondsSinceEpoch.toString(),
        name: name,
        description: desc,
        icon: _icon,
        colorValue: _color,
        targetPerDay: _target,
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

  void _inc() => setState(() => _target++);
  void _dec() => setState(() => _target = _target > 1 ? _target - 1 : 1);

  @override
  Widget build(BuildContext context) {
    final valid = _nameController.text.trim().isNotEmpty;
    return Scaffold(
      backgroundColor: kBg,
      body: NestedScrollView(
        headerSliverBuilder: (context, _) => [
          SliverAppBar(
            backgroundColor: kBg,
            leading: IconButton(
              icon: const Icon(Icons.close),
              onPressed: () => context.pop(),
            ),
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
        ],
        body: ListView(
          padding: const EdgeInsets.all(16),
          children: [
            GestureDetector(
              onTap: _pickIcon,
              child: CircleAvatar(
                radius: 56,
                backgroundColor: Color(_color),
                child: Text(_icon, style: const TextStyle(fontSize: 40)),
              ),
            ),
            const SizedBox(height: 24),
            TextField(
              controller: _nameController,
              autofocus: true,
              textCapitalization: TextCapitalization.sentences,
              decoration: const InputDecoration(labelText: 'Name'),
              onChanged: (_) => setState(() {}),
            ),
            const SizedBox(height: 16),
            TextField(
              controller: _descController,
              maxLines: 3,
              decoration: const InputDecoration(labelText: 'Description'),
            ),
            const SizedBox(height: 16),
            ColorPickerGrid(
              selectedColor: _color,
              onChanged: (c) => setState(() => _color = c),
            ),
            const SizedBox(height: 16),
            ExpansionTile(
              title: const Text('Advanced Options'),
              childrenPadding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
              children: [
                ListTile(
                  title: const Text('Streak Goal'),
                  trailing: const Text('None'),
                  onTap: () {},
                ),
                ListTile(
                  title: const Text('Reminder'),
                  trailing: const Text('None'),
                  onTap: () {},
                ),
                ListTile(
                  title: const Text('Categories'),
                  trailing: const Text('None'),
                  onTap: () {},
                ),
                const SizedBox(height: 8),
                SegmentedButton<int>(
                  segments: const [
                    ButtonSegment(value: 0, label: Text('Step by step')),
                    ButtonSegment(value: 1, label: Text('Custom value')),
                  ],
                  selected: {_mode},
                  onSelectionChanged: (v) => setState(() => _mode = v.first),
                ),
                const SizedBox(height: 12),
                Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    IconButton(icon: const Icon(Icons.remove), onPressed: _dec),
                    SizedBox(
                      width: 48,
                      child: TextFormField(
                        textAlign: TextAlign.center,
                        keyboardType: TextInputType.number,
                        controller: TextEditingController(text: '$_target'),
                        onChanged: (v) {
                          final n = int.tryParse(v) ?? _target;
                          setState(() => _target = n);
                        },
                      ),
                    ),
                    IconButton(icon: const Icon(Icons.add), onPressed: _inc),
                  ],
                ),
              ],
            ),
            const SizedBox(height: 80),
          ],
        ),
      ),
      bottomNavigationBar: Padding(
        padding: const EdgeInsets.all(16),
        child: PrimaryButton('Save', onPressed: valid ? _save : null),
      ),
    );
  }
}
