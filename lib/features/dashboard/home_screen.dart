import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';

import '../../core/data/providers.dart';
import '../../core/data/models/habit.dart';
import '../../core/data/preferences_service.dart';
import '../../core/streak/streak_service.dart';
import '../../core/widgets/primary_button.dart';
import 'empty_state_widget.dart';
import 'heatmap_widget.dart';
import 'bottom_navbar.dart';

part 'habit_heatmap_card.dart';

const kAccent = Color(0xFF9E4DFF);
const kBg = Color(0xFF121212);

class HomeScreen extends ConsumerWidget {
  const HomeScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    ref.listen<AsyncValue<String>>(newRecordProvider, (_, value) {
      value.whenData((id) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text('🔥 New longest streak!')),
        );
      });
    });

    return Scaffold(
      backgroundColor: kBg,
      extendBodyBehindAppBar: true,
      appBar: AppBar(
        backgroundColor: Colors.transparent,
        elevation: 0,
        leading: IconButton(
          icon: const Icon(Icons.settings),
          onPressed: () => context.push('/settings'),
        ),
        title: RichText(
          text: TextSpan(
            style: Theme.of(context).textTheme.headlineMedium,
            children: const [
              TextSpan(text: 'Habit', style: TextStyle(color: Colors.white)),
              TextSpan(text: 'Hero', style: TextStyle(color: kAccent)),
            ],
          ),
        ),
        actions: [
          IconButton(
            icon: const Icon(Icons.show_chart_outlined),
            onPressed: () => context.push('/analytics'),
          ),
          IconButton(
            icon: const Icon(Icons.add_circle_outline),
            onPressed: () => context.push('/add'),
          ),
        ],
      ),

      body: SafeArea(
        child: Consumer(
          builder: (context, ref, _) {
            final asyncHabits = ref.watch(habitListProvider);
            return asyncHabits.when(
              data: (habits) {
                if (habits.isEmpty) return const _EmptyState();
                return SingleChildScrollView(
                  padding: const EdgeInsets.fromLTRB(16, 16, 16, 80),
                  child: Column(
                    children: [
                      for (int i = 0; i < habits.length; i++) ...[
                        HabitHeatmapCard(habit: habits[i]),
                        if (i != habits.length - 1)
                          const SizedBox(height: 12),
                      ],
                    ],
                  ),
                );
              },
              loading: () => const Center(child: CircularProgressIndicator()),
              error: (e, _) => Center(child: Text('Error: $e')),
            );
          },
        ),

      ),
      floatingActionButton: FloatingActionButton(
        backgroundColor: kAccent,
        child: const Icon(Icons.add),

      ),
      bottomNavigationBar: HomeBottomNav(
        index: 0,
        onTap: (i) {
          // TODO switch modes
        },
      ),
    );
  }
}

class _EmptyState extends StatelessWidget {
  const _EmptyState();

  @override
  Widget build(BuildContext context) {
    final textTheme = Theme.of(context).textTheme;
    return Center(
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          const Icon(Icons.add, size: 48, color: Colors.white54),
          const SizedBox(height: 12),
          Text('No habits yet', style: textTheme.titleMedium),
          const SizedBox(height: 4),
          Text('Tap the + button to start tracking',
              style: textTheme.bodySmall),
          const SizedBox(height: 16),
          ElevatedButton(
            onPressed: () => context.push('/add'),
            child: const Text('Add Habit'),
          ),
        ],

      ),
    );
  }
}
