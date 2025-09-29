class FitnessEntry {
  final int? id;
  final DateTime date;
  final int steps;
  final double calories;
  final int minutes;
  final String type;

  FitnessEntry({
    this.id,
    required this.date,
    required this.steps,
    required this.calories,
    required this.minutes,
    required this.type,
  });

  Map<String, dynamic> toMap() {
    // normalize to midnight
    final d = DateTime(date.year, date.month, date.day);
    return {
      'id': id,
      'date': d.toIso8601String(),
      'steps': steps,
      'calories': calories,
      'minutes': minutes,
      'type': type,
    };
  }

  factory FitnessEntry.fromMap(Map<String, dynamic> map) {
    final parsed = DateTime.parse(map['date']);
    final d = DateTime(parsed.year, parsed.month, parsed.day);

    return FitnessEntry(
      id: map['id'],
      date: d,
      steps: map['steps'],
      calories: (map['calories'] as num).toDouble(),
      minutes: map['minutes'],
      type: map['type'],
    );
  }
}
