class Habit {
  final String id;
  String name;
  String description;
  String icon;
  int colorValue;
  int targetPerDay;
  bool archived;
  DateTime createdAt;

  Habit({
    required this.id,
    required this.name,
    this.description = '',
    required this.icon,
    required this.colorValue,
    this.targetPerDay = 1,
    this.archived = false,
    DateTime? createdAt,
  }) : createdAt = createdAt ?? DateTime.now();

  factory Habit.fromJson(Map<String, dynamic> j) {
    return Habit(
      id: j['id'] as String,
      name: j['name'] as String,
      description: j['description'] as String? ?? '',
      icon: j['icon'] as String,
      colorValue: j['colorValue'] as int,
      targetPerDay: j['targetPerDay'] as int? ?? 1,
      archived: j['archived'] as bool? ?? false,
      createdAt: DateTime.parse(j['createdAt'] as String),
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'name': name,
      'description': description,
      'icon': icon,
      'colorValue': colorValue,
      'targetPerDay': targetPerDay,
      'archived': archived,
      'createdAt': createdAt.toIso8601String(),
    };
  }
}
