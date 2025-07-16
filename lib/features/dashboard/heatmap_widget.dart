import 'package:flutter/material.dart';

class HeatMapWidget extends StatelessWidget {
  final Map<DateTime, int> data;
  final Color accent;
  final double tileSize;

  const HeatMapWidget({
    super.key,
    required this.data,
    required this.accent,
    this.tileSize = 14,
  });

  int get _weeksSpan {
    if (data.isEmpty) return 12;
    final dates = data.keys.toList()..sort();
    final oldest = dates.first;
    final today = DateUtils.dateOnly(DateTime.now());
    final diff = today.difference(DateUtils.dateOnly(oldest)).inDays ~/ 7 + 1;
    return diff.clamp(12, 52);
  }

  @override
  Widget build(BuildContext context) {
    final weeks = _weeksSpan;
    return GridView.builder(
      physics: const NeverScrollableScrollPhysics(),
      shrinkWrap: true,
      gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
        crossAxisCount: weeks,
      ),
      itemCount: weeks * 7,
      itemBuilder: (context, index) {
        final row = index % 7;
        final col = index ~/ 7;
        final today = DateUtils.dateOnly(DateTime.now());
        final start = today.subtract(Duration(days: (weeks - 1 - col) * 7 + (6 - row)));
        if (start.isAfter(today)) {
          return const SizedBox.shrink();
        }
        final val = data[DateUtils.dateOnly(start)] ?? 0;
        Color color;
        if (val == 0) {
          color = const Color(0xFF1E1E1E);
        } else if (val == 1) {
          color = accent.withOpacity(.25);
        } else {
          color = accent.withOpacity(.55);
        }
        return Container(
          width: tileSize,
          height: tileSize,
          decoration: BoxDecoration(
            color: start.isAfter(today) ? Colors.transparent : color,
            border: Border.all(color: Colors.grey.shade600, width: 0.5),
          ),
        );
      },
    );
  }
}

