import 'package:flutter/material.dart';

/// Utility class for computing habit streaks.
class StreakService {
  /// Computes the current and longest streak from [comp], where the key is the
  /// completion date (without time) and the value indicates the completion
  /// count.
  ///
  /// Returns a tuple `(current, longest)`.
  static (int, int) compute(Map<DateTime, int> comp) {
    if (comp.isEmpty) return (0, 0);

    final sorted = comp.keys.toList()..sort();
    final today = DateUtils.dateOnly(DateTime.now());

    // Compute current streak starting from today backwards.
    var current = 0;
    for (var off = 0;; off++) {
      final d = today.subtract(Duration(days: off));
      if (comp[d] != null && comp[d]! > 0) {
        current++;
      } else {
        break;
      }
    }

    // Compute longest streak through entire sorted list.
    var longest = 0;
    var run = 0;
    DateTime? prev;
    for (final d in sorted) {
      if (prev != null && d.difference(prev).inDays == 1) {
        run++;
      } else {
        run = comp[d]! > 0 ? 1 : 0;
      }
      if (run > longest) longest = run;
      prev = d;
    }

    return (current, longest);
  }
}
