import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../core/data/providers.dart';
import '../../core/data/models/habit.dart';
import '../../core/data/preferences_service.dart';
import '../../core/streak/streak_service.dart';
import 'heatmap_widget.dart';
import 'package:go_router/go_router.dart';
part 'habit_heatmap_card.dart';

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

    return ref.watch(habitListProvider).when(
          data: (habits) {
            if (habits.isEmpty) return const _EmptyState();
            return ListView.separated(
              padding: const EdgeInsets.all(16),
              itemCount: habits.length,
              separatorBuilder: (_, __) => const SizedBox(height: 12),
              itemBuilder: (_, i) {
                final h = habits[i];
                return ProviderScope(
                  overrides: [_currentHabit.overrideWithValue(h)],
                  child: const HabitHeatmapCard(),
                );
              },
            );
          },
          loading: () => const Center(child: CircularProgressIndicator()),
          error: (e, _) => Center(child: Text('Error: $e')),
        );
  }
}

class _EmptyState extends StatelessWidget {
  const _EmptyState();

  @override
  Widget build(BuildContext context) {
    return const Center(child: Text('No habits yet'));
  }
}
