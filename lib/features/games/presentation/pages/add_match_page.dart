import 'package:flutter/material.dart';

class AddMatchPage extends StatefulWidget {
  const AddMatchPage({super.key});

  @override
  State<AddMatchPage> createState() => _AddMatchPageState();
}

class _AddMatchPageState extends State<AddMatchPage> {
  final _formKey = GlobalKey<FormState>();
  final _homeTeamController = TextEditingController();
  final _awayTeamController = TextEditingController();
  DateTime _selectedDate = DateTime.now();
  TimeOfDay _selectedTime = TimeOfDay.now();
  String _selectedLeague = 'Premier League';

  final List<String> _leagues = [
    'Premier League',
    'La Liga',
    'Bundesliga',
    'Serie A',
    'Ligue 1',
  ];

  @override
  void dispose() {
    _homeTeamController.dispose();
    _awayTeamController.dispose();
    super.dispose();
  }

  Future<void> _selectDate(BuildContext context) async {
    final DateTime? picked = await showDatePicker(
      context: context,
      initialDate: _selectedDate,
      firstDate: DateTime.now(),
      lastDate: DateTime.now().add(const Duration(days: 365)),
    );
    if (picked != null && picked != _selectedDate) {
      setState(() {
        _selectedDate = picked;
      });
    }
  }

  Future<void> _selectTime(BuildContext context) async {
    final TimeOfDay? picked = await showTimePicker(
      context: context,
      initialTime: _selectedTime,
    );
    if (picked != null && picked != _selectedTime) {
      setState(() {
        _selectedTime = picked;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Add Match')),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16.0),
        child: Form(
          key: _formKey,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              DropdownButtonFormField<String>(
                initialValue: _selectedLeague,
                decoration: const InputDecoration(
                  labelText: 'League',
                  border: OutlineInputBorder(),
                ),
                items:
                    _leagues.map((String league) {
                      return DropdownMenuItem<String>(
                        value: league,
                        child: Text(league),
                      );
                    }).toList(),
                onChanged: (String? newValue) {
                  setState(() {
                    _selectedLeague = newValue!;
                  });
                },
              ),
              const SizedBox(height: 16),
              TextFormField(
                controller: _homeTeamController,
                decoration: const InputDecoration(
                  labelText: 'Home Team',
                  border: OutlineInputBorder(),
                ),
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return 'Please enter home team name';
                  }
                  return null;
                },
              ),
              const SizedBox(height: 16),
              TextFormField(
                controller: _awayTeamController,
                decoration: const InputDecoration(
                  labelText: 'Away Team',
                  border: OutlineInputBorder(),
                ),
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return 'Please enter away team name';
                  }
                  return null;
                },
              ),
              const SizedBox(height: 16),
              ListTile(
                title: const Text('Match Date'),
                subtitle: Text(
                  '${_selectedDate.day}/${_selectedDate.month}/${_selectedDate.year}',
                ),
                trailing: const Icon(Icons.calendar_today),
                onTap: () => _selectDate(context),
              ),
              const SizedBox(height: 8),
              ListTile(
                title: const Text('Match Time'),
                subtitle: Text(_selectedTime.format(context)),
                trailing: const Icon(Icons.access_time),
                onTap: () => _selectTime(context),
              ),
              const SizedBox(height: 24),
              ElevatedButton(
                onPressed: () {
                  if (_formKey.currentState!.validate()) {
                    // TODO: Implement match creation logic
                    ScaffoldMessenger.of(context).showSnackBar(
                      const SnackBar(content: Text('Match added successfully')),
                    );
                  }
                },
                child: const Padding(
                  padding: EdgeInsets.all(16.0),
                  child: Text('Add Match'),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
