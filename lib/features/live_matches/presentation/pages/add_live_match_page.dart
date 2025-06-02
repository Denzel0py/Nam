import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:namhockey/features/live_matches/presentation/bloc/live_match_bloc.dart';
import 'package:supabase_flutter/supabase_flutter.dart';

class AddLiveMatchPage extends StatefulWidget {
  const AddLiveMatchPage({super.key});

  @override
  State<AddLiveMatchPage> createState() => _AddLiveMatchPageState();
}

class _AddLiveMatchPageState extends State<AddLiveMatchPage> {
  final _formKey = GlobalKey<FormState>();
  String? _selectedTeam1Id;
  String? _selectedTeam2Id;
  final _team1ScoreController = TextEditingController(text: '0');
  final _team2ScoreController = TextEditingController(text: '0');
  List<Map<String, dynamic>> _teams = [];
  bool _isLoading = true;

  @override
  void initState() {
    super.initState();
    _loadTeams();
  }

  Future<void> _loadTeams() async {
    try {
      final supabase = Supabase.instance.client;
      final response = await supabase.from('teams').select();

      setState(() {
        _teams = List<Map<String, dynamic>>.from(response);
        _isLoading = false;
      });
    } catch (e) {
      setState(() {
        _isLoading = false;
      });
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text('Error loading teams: ${e.toString()}'),
            backgroundColor: Colors.red,
          ),
        );
      }
    }
  }

  @override
  void dispose() {
    _team1ScoreController.dispose();
    _team2ScoreController.dispose();
    super.dispose();
  }

  void _submitForm() {
    if (_formKey.currentState!.validate()) {
      if (_selectedTeam1Id == null || _selectedTeam2Id == null) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(
            content: Text('Please select both teams'),
            backgroundColor: Colors.red,
          ),
        );
        return;
      }

      if (_selectedTeam1Id == _selectedTeam2Id) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(
            content: Text('Please select different teams'),
            backgroundColor: Colors.red,
          ),
        );
        return;
      }

      final team1 = _teams.firstWhere((team) => team['id'] == _selectedTeam1Id);
      final team2 = _teams.firstWhere((team) => team['id'] == _selectedTeam2Id);

      context.read<LiveMatchBloc>().add(
        MakeLiveMatchEvent(
          team1Logo: team1['logo_url'] ?? '',
          team2Logo: team2['logo_url'] ?? '',
          team1Name: team1['name'] ?? '',
          team2Name: team2['name'] ?? '',
          team1Score: _team1ScoreController.text,
          team2Score: _team2ScoreController.text,
        ),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Add Live Match')),
      body: BlocListener<LiveMatchBloc, LiveMatchState>(
        listener: (context, state) {
          if (state is LiveMatchFailure) {
            ScaffoldMessenger.of(context).showSnackBar(
              SnackBar(
                content: Text(state.message),
                backgroundColor: Colors.red,
              ),
            );
          } else if (state is LiveMatchCreated) {
            Navigator.pop(context);
          }
        },
        child:
            _isLoading
                ? const Center(child: CircularProgressIndicator())
                : SingleChildScrollView(
                  padding: const EdgeInsets.all(16),
                  child: Form(
                    key: _formKey,
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.stretch,
                      children: [
                        DropdownButtonFormField<String>(
                          decoration: const InputDecoration(
                            labelText: 'Team 1',
                            border: OutlineInputBorder(),
                          ),
                          value: _selectedTeam1Id,
                          items:
                              _teams.map((team) {
                                return DropdownMenuItem<String>(
                                  value: team['id'].toString(),
                                  child: Text(team['name'] ?? ''),
                                );
                              }).toList(),
                          onChanged: (value) {
                            setState(() {
                              _selectedTeam1Id = value;
                            });
                          },
                          validator: (value) {
                            if (value == null) {
                              return 'Please select a team';
                            }
                            return null;
                          },
                        ),
                        const SizedBox(height: 16),
                        DropdownButtonFormField<String>(
                          decoration: const InputDecoration(
                            labelText: 'Team 2',
                            border: OutlineInputBorder(),
                          ),
                          value: _selectedTeam2Id,
                          items:
                              _teams.map((team) {
                                return DropdownMenuItem<String>(
                                  value: team['id'].toString(),
                                  child: Text(team['name'] ?? ''),
                                );
                              }).toList(),
                          onChanged: (value) {
                            setState(() {
                              _selectedTeam2Id = value;
                            });
                          },
                          validator: (value) {
                            if (value == null) {
                              return 'Please select a team';
                            }
                            return null;
                          },
                        ),
                        const SizedBox(height: 16),
                        Row(
                          children: [
                            Expanded(
                              child: TextFormField(
                                controller: _team1ScoreController,
                                decoration: const InputDecoration(
                                  labelText: 'Team 1 Score',
                                  border: OutlineInputBorder(),
                                ),
                                keyboardType: TextInputType.number,
                                validator: (value) {
                                  if (value == null || value.isEmpty) {
                                    return 'Please enter a score';
                                  }
                                  if (int.tryParse(value) == null) {
                                    return 'Please enter a valid number';
                                  }
                                  return null;
                                },
                              ),
                            ),
                            const SizedBox(width: 16),
                            Expanded(
                              child: TextFormField(
                                controller: _team2ScoreController,
                                decoration: const InputDecoration(
                                  labelText: 'Team 2 Score',
                                  border: OutlineInputBorder(),
                                ),
                                keyboardType: TextInputType.number,
                                validator: (value) {
                                  if (value == null || value.isEmpty) {
                                    return 'Please enter a score';
                                  }
                                  if (int.tryParse(value) == null) {
                                    return 'Please enter a valid number';
                                  }
                                  return null;
                                },
                              ),
                            ),
                          ],
                        ),
                        const SizedBox(height: 24),
                        ElevatedButton(
                          onPressed: _submitForm,
                          style: ElevatedButton.styleFrom(
                            padding: const EdgeInsets.symmetric(vertical: 16),
                          ),
                          child: const Text('Create Live Match'),
                        ),
                      ],
                    ),
                  ),
                ),
      ),
    );
  }
}
