import 'package:flutter/material.dart';
import '../models/fitness_entry.dart';

class AddEntryScreen extends StatefulWidget {
  const AddEntryScreen({super.key});

  @override
  State<AddEntryScreen> createState() => _AddEntryScreenState();
}

class _AddEntryScreenState extends State<AddEntryScreen> {
  final _stepsController = TextEditingController();
  final _caloriesController = TextEditingController();
  final _minutesController = TextEditingController();
  String _selectedType = 'Walking';

  final _types = ['Walking', 'Running', 'Cycling'];

  void _saveEntry() {
    final entry = FitnessEntry(
      date: DateTime.now(), // 🔑 normalized later in model
      steps: int.tryParse(_stepsController.text) ?? 0,
      calories: double.tryParse(_caloriesController.text) ?? 0,
      minutes: int.tryParse(_minutesController.text) ?? 0,
      type: _selectedType,
    );
    Navigator.pop(context, entry);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Add Entry')),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          children: [
            DropdownButtonFormField<String>(
              value: _selectedType,
              items: _types
                  .map((t) => DropdownMenuItem(value: t, child: Text(t)))
                  .toList(),
              onChanged: (v) => setState(() => _selectedType = v ?? 'Walking'),
              decoration: const InputDecoration(labelText: 'Activity Type'),
            ),
            TextField(
              controller: _stepsController,
              decoration: const InputDecoration(labelText: 'Steps'),
              keyboardType: TextInputType.number,
            ),
            TextField(
              controller: _caloriesController,
              decoration: const InputDecoration(labelText: 'Calories'),
              keyboardType: TextInputType.number,
            ),
            TextField(
              controller: _minutesController,
              decoration: const InputDecoration(labelText: 'Minutes'),
              keyboardType: TextInputType.number,
            ),
            const SizedBox(height: 20),
            ElevatedButton(onPressed: _saveEntry, child: const Text('Save')),
          ],
        ),
      ),
    );
  }
}
