class Completion {
  final String habitId;
  final DateTime date;
  final int value;

  Completion(this.habitId, this.date, {this.value = 1});

  factory Completion.fromJson(Map<String, dynamic> j) {
    return Completion(
      j['habitId'] as String,
      DateTime.parse(j['date'] as String),
      value: j['value'] as int? ?? 1,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'habitId': habitId,
      'date': date.toIso8601String().split('T').first,
      'value': value,
    };
  }
}
