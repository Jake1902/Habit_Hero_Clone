import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';

import '../../core/data/providers.dart';
import '../../core/widgets/primary_button.dart';
import 'empty_state_widget.dart';
import 'heatmap_widget.dart';

part 'habit_heatmap_card.dart';

const kAccent = Color(0xFF9E4DFF);
const kBg = Color(0xFF121212);

class HomeScreen extends ConsumerWidget {
  const HomeScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    ref.listen<String?>(newRecordProvider, (_, id) {
      if (id != null) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text('🔥 New longest streak!')),
        );
      }
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
      body: Consumer(
        builder: (context, ref, _) {
          final habits = ref.watch(habitListProvider);
          return habits.when(
            loading: () => const Center(child: CircularProgressIndicator()),
            error: (e, _) => Center(child: Text('Error: $e')),
            data: (list) {
              if (list.isEmpty) {
                return EmptyStateWidget(onCreate: () => context.push('/add'));
              }
              return ListView.separated(
                padding: const EdgeInsets.all(16),
                itemCount: list.length,
                separatorBuilder: (_, __) => const SizedBox(height: 12),
                itemBuilder: (_, i) => HabitHeatmapCard(habit: list[i]),
              );
            },
          );
        },
      ),
      floatingActionButton: FloatingActionButton(
        backgroundColor: kAccent,
        child: const Icon(Icons.add),
        onPressed: () => context.push('/add'),
      ),
    );
  }
}
