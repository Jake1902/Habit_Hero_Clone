part of 'home_screen.dart';

const kCard = Color(0xFF1E1E1E);

class HabitHeatmapCard extends ConsumerWidget {
  final Habit habit;
  const HabitHeatmapCard({super.key, required this.habit});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final repo = ref.read(habitRepoProvider);
    final map = PreferencesService.readCompletionsJson(habit.id);
    final completions = map.map((k, v) => MapEntry(DateTime.parse(k), v as int));
    final isDoneToday =
        completions[DateUtils.dateOnly(DateTime.now())] != null;

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
        color: kCard,
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
        child: Padding(
          padding: const EdgeInsets.all(16),
          child: Row(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Container(
                height: 56,
                width: 56,
                decoration: BoxDecoration(
                  color: Color(habit.colorValue),
                  borderRadius: BorderRadius.circular(8),
                ),
              ),
              const SizedBox(width: 12),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(habit.name,
                        style: Theme.of(context).textTheme.titleMedium),
                    if (habit.description.isNotEmpty)
                      Text(habit.description,
                          style: Theme.of(context).textTheme.bodySmall),
                    const SizedBox(height: 8),
                    HeatMapWidget(
                      data: completions,
                      accent: Color(habit.colorValue),
                    ),
                  ],
                ),
              ),
              GestureDetector(
                onTap: () =>
                    repo.toggleCompletion(habit.id, DateTime.now()),
                child: Container(
                  height: 48,
                  width: 48,
                  decoration: BoxDecoration(
                    color:
                        isDoneToday ? Color(habit.colorValue) : kCard,
                    border: Border.all(
                      color: Color(habit.colorValue),
                      width: 1.5,
                    ),
                    borderRadius: BorderRadius.circular(12),
                  ),
                  child: Icon(
                    Icons.check,
                    color: isDoneToday
                        ? Colors.white
                        : Color(habit.colorValue),
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
