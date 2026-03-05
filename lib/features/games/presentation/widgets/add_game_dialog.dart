import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:namhockey/features/games/presentation/bloc/games_bloc.dart';
import 'package:supabase_flutter/supabase_flutter.dart';

class AddGameDialog extends StatefulWidget {
  const AddGameDialog({super.key});

  @override
  State<AddGameDialog> createState() => _AddGameDialogState();
}

class _AddGameDialogState extends State<AddGameDialog> {
  final _formKey = GlobalKey<FormState>();
  final _leagueController = TextEditingController();
  final _gameDateController = TextEditingController();
  final _gameTimeController = TextEditingController();
  final _gameLocationController = TextEditingController();

  String? selectedTeam1Id;
  String? selectedTeam2Id;
  List<Map<String, dynamic>> teams = [];
  bool isLoading = true;

  @override
  void initState() {
    super.initState();
    _loadTeams();
  }

  Future<void> _loadTeams() async {
    try {
      final response = await Supabase.instance.client
          .from('teams')
          .select()
          .order('name');

      setState(() {
        teams = List<Map<String, dynamic>>.from(response);
        isLoading = false;
      });
    } catch (e) {
      print('Error loading teams: $e');
      setState(() {
        isLoading = false;
      });
    }
  }

  @override
  void dispose() {
    _leagueController.dispose();
    _gameDateController.dispose();
    _gameTimeController.dispose();
    _gameLocationController.dispose();
    super.dispose();
  }

  void _submitForm() {
    if (_formKey.currentState!.validate() &&
        selectedTeam1Id != null &&
        selectedTeam2Id != null) {
      context.read<GamesBloc>().add(
        MakeGamesEvent(
          team1: selectedTeam1Id!,
          team2: selectedTeam2Id!,
          league: _leagueController.text,
          team1Logo:
              teams.firstWhere(
                (team) => team['id'] == selectedTeam1Id,
              )['logo_url'],
          team2Logo:
              teams.firstWhere(
                (team) => team['id'] == selectedTeam2Id,
              )['logo_url'],
          gameDate: _gameDateController.text,
          gameTime: _gameTimeController.text,
          gameLocation: _gameLocationController.text,
        ),
      );
      Navigator.of(context).pop();
    }
  }

  @override
  Widget build(BuildContext context) {
    return Dialog(
      child: Container(
        padding: const EdgeInsets.all(16),
        child: Form(
          key: _formKey,
          child: SingleChildScrollView(
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                const Text(
                  'Add New Game',
                  style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
                ),
                const SizedBox(height: 16),
                if (isLoading)
                  const Center(child: CircularProgressIndicator())
                else ...[
                  DropdownButtonFormField<String>(
                    initialValue: selectedTeam1Id,
                    decoration: const InputDecoration(
                      labelText: 'Team 1',
                      border: OutlineInputBorder(),
                    ),
                    items:
                        teams.map((team) {
                          return DropdownMenuItem(
                            value: team['id'].toString(),
                            child: Row(
                              children: [
                                if (team['logo_url'] != null)
                                  Image.network(
                                    team['logo_url'],
                                    width: 24,
                                    height: 24,
                                    errorBuilder:
                                        (context, error, stackTrace) =>
                                            const Icon(Icons.sports),
                                  ),
                                const SizedBox(width: 8),
                                Text(team['name']),
                              ],
                            ),
                          );
                        }).toList(),
                    onChanged: (value) {
                      setState(() {
                        selectedTeam1Id = value;
                      });
                    },
                    validator: (value) {
                      if (value == null || value.isEmpty) {
                        return 'Please select team 1';
                      }
                      return null;
                    },
                  ),
                  const SizedBox(height: 8),
                  DropdownButtonFormField<String>(
                    initialValue: selectedTeam2Id,
                    decoration: const InputDecoration(
                      labelText: 'Team 2',
                      border: OutlineInputBorder(),
                    ),
                    items:
                        teams.map((team) {
                          return DropdownMenuItem(
                            value: team['id'].toString(),
                            child: Row(
                              children: [
                                if (team['logo_url'] != null)
                                  Image.network(
                                    team['logo_url'],
                                    width: 24,
                                    height: 24,
                                    errorBuilder:
                                        (context, error, stackTrace) =>
                                            const Icon(Icons.sports),
                                  ),
                                const SizedBox(width: 8),
                                Text(team['name']),
                              ],
                            ),
                          );
                        }).toList(),
                    onChanged: (value) {
                      setState(() {
                        selectedTeam2Id = value;
                      });
                    },
                    validator: (value) {
                      if (value == null || value.isEmpty) {
                        return 'Please select team 2';
                      }
                      if (value == selectedTeam1Id) {
                        return 'Please select a different team';
                      }
                      return null;
                    },
                  ),
                  const SizedBox(height: 8),
                  TextFormField(
                    controller: _leagueController,
                    decoration: const InputDecoration(
                      labelText: 'League',
                      border: OutlineInputBorder(),
                    ),
                    validator: (value) {
                      if (value == null || value.isEmpty) {
                        return 'Please enter league name';
                      }
                      return null;
                    },
                  ),
                  const SizedBox(height: 8),
                  TextFormField(
                    controller: _gameDateController,
                    decoration: const InputDecoration(
                      labelText: 'Game Date (YYYY-MM-DD)',
                      border: OutlineInputBorder(),
                    ),
                    validator: (value) {
                      if (value == null || value.isEmpty) {
                        return 'Please enter game date';
                      }
                      return null;
                    },
                  ),
                  const SizedBox(height: 8),
                  TextFormField(
                    controller: _gameTimeController,
                    decoration: const InputDecoration(
                      labelText: 'Game Time (HH:MM)',
                      border: OutlineInputBorder(),
                    ),
                    validator: (value) {
                      if (value == null || value.isEmpty) {
                        return 'Please enter game time';
                      }
                      return null;
                    },
                  ),
                  const SizedBox(height: 8),
                  TextFormField(
                    controller: _gameLocationController,
                    decoration: const InputDecoration(
                      labelText: 'Game Location',
                      border: OutlineInputBorder(),
                    ),
                    validator: (value) {
                      if (value == null || value.isEmpty) {
                        return 'Please enter game location';
                      }
                      return null;
                    },
                  ),
                  const SizedBox(height: 16),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.end,
                    children: [
                      TextButton(
                        onPressed: () => Navigator.of(context).pop(),
                        child: const Text('Cancel'),
                      ),
                      const SizedBox(width: 8),
                      ElevatedButton(
                        onPressed: _submitForm,
                        child: const Text('Add Game'),
                      ),
                    ],
                  ),
                ],
              ],
            ),
          ),
        ),
      ),
    );
  }
}
