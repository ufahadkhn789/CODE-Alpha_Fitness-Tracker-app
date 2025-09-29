import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import '../models/fitness_entry.dart';
import '../widgets/info_card.dart';
import '../widgets/weekly_bar_chart.dart';
import 'add_entry_screen.dart';

class DashboardScreen extends StatefulWidget {
  const DashboardScreen({super.key});

  @override
  State<DashboardScreen> createState() => _DashboardScreenState();
}

class _DashboardScreenState extends State<DashboardScreen> {
  final List<FitnessEntry> _entries = []; // 🔑 in-memory list only

  Map<String, num> getTodayTotals() {
    final today = DateTime.now();
    final t = DateTime(today.year, today.month, today.day);
    int steps = 0;
    double calories = 0;
    int minutes = 0;

    for (var e in _entries) {
      final eDay = DateTime(e.date.year, e.date.month, e.date.day);
      if (eDay == t) {
        steps += e.steps;
        calories += e.calories;
        minutes += e.minutes;
      }
    }
    return {'steps': steps, 'calories': calories, 'minutes': minutes};
  }

  List<Map<String, dynamic>> weeklyAggregates() {
    final today = DateTime.now();
    final start =
    DateTime(today.year, today.month, today.day).subtract(const Duration(days: 6));

    Map<String, int> map = {};
    for (int i = 0; i < 7; i++) {
      final day = start.add(Duration(days: i));
      final key = DateFormat('yyyy-MM-dd').format(day);
      map[key] = 0;
    }

    for (var e in _entries) {
      final key = DateFormat('yyyy-MM-dd').format(e.date);
      if (map.containsKey(key)) {
        map[key] = (map[key] ?? 0) + e.steps;
      }
    }

    return map.entries
        .map((ent) => {'date': DateTime.parse(ent.key), 'steps': ent.value})
        .toList();
  }

  void _openAdd() async {
    final newEntry = await Navigator.push<FitnessEntry>(
      context,
      MaterialPageRoute(builder: (_) => const AddEntryScreen()),
    );
    if (newEntry != null) {
      setState(() {
        _entries.insert(0, newEntry);
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    final totals = getTodayTotals();
    final weekly = weeklyAggregates();

    return Scaffold(
      appBar: AppBar(title: const Text('Fitness Tracker')),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const Text('Today', style: TextStyle(fontSize: 22, fontWeight: FontWeight.bold)),
            const SizedBox(height: 8),
            Row(
              children: [
                InfoCard(label: 'Steps', value: '${totals['steps']}'),
                const SizedBox(width: 8),
                InfoCard(
                  label: 'Calories',
                  value: (totals['calories'] as double).toStringAsFixed(0),
                ),
                const SizedBox(width: 8),
                InfoCard(label: 'Minutes', value: '${totals['minutes']}'),
              ],
            ),
            const SizedBox(height: 18),
            const Text('Last 7 days', style: TextStyle(fontSize: 18, fontWeight: FontWeight.w600)),
            const SizedBox(height: 8),
            WeeklyBarChart(data: weekly),
            const SizedBox(height: 18),
            const Text('Recent entries', style: TextStyle(fontSize: 18, fontWeight: FontWeight.w600)),
            const SizedBox(height: 8),
            ..._entries.take(8).map(
                  (e) => Card(
                child: ListTile(
                  title: Text('${e.type} • ${e.steps} steps'),
                  subtitle: Text(
                    '${DateFormat.yMMMd().format(e.date)} • ${e.minutes} min • ${e.calories.toStringAsFixed(0)} kcal',
                  ),
                ),
              ),
            ),
            const SizedBox(height: 80),
          ],
        ),
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: _openAdd,
        child: const Icon(Icons.add),
      ),
    );
  }
}
