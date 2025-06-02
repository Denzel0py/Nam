import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:namhockey/features/live_matches/domain/entity/live_match_entity.dart';
import 'package:namhockey/features/live_matches/presentation/bloc/live_match_bloc.dart';

class EditLiveMatchPage extends StatefulWidget {
  final LiveMatchEntity match;

  const EditLiveMatchPage({super.key, required this.match});

  @override
  State<EditLiveMatchPage> createState() => _EditLiveMatchPageState();
}

class _EditLiveMatchPageState extends State<EditLiveMatchPage> {
  final _formKey = GlobalKey<FormState>();
  late final TextEditingController _team1ScoreController;
  late final TextEditingController _team2ScoreController;

  @override
  void initState() {
    super.initState();
    _team1ScoreController = TextEditingController(
      text: widget.match.team1Score,
    );
    _team2ScoreController = TextEditingController(
      text: widget.match.team2Score,
    );
  }

  @override
  void dispose() {
    _team1ScoreController.dispose();
    _team2ScoreController.dispose();
    super.dispose();
  }

  void _submitForm() {
    if (_formKey.currentState!.validate()) {
      context.read<LiveMatchBloc>().add(
        UpdateLiveMatchEvent(
          id: widget.match.id,
          team1Score: _team1ScoreController.text,
          team2Score: _team2ScoreController.text,
        ),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Edit Live Match')),
      body: BlocListener<LiveMatchBloc, LiveMatchState>(
        listener: (context, state) {
          if (state is LiveMatchFailure) {
            ScaffoldMessenger.of(context).showSnackBar(
              SnackBar(
                content: Text(state.message),
                backgroundColor: Colors.red,
              ),
            );
          } else if (state is LiveMatchUpdated) {
            Navigator.pop(context);
          }
        },
        child: SingleChildScrollView(
          padding: const EdgeInsets.all(16),
          child: Form(
            key: _formKey,
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: [
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                  children: [
                    Column(
                      children: [
                        ClipRRect(
                          borderRadius: BorderRadius.circular(20),
                          child: Container(
                            height: 60,
                            width: 60,
                            decoration: BoxDecoration(
                              color: Colors.white,
                              borderRadius: BorderRadius.circular(20),
                            ),
                            child: Image.network(
                              widget.match.team1Logo,
                              fit: BoxFit.contain,
                              errorBuilder: (context, error, stackTrace) {
                                return const Icon(Icons.sports_hockey);
                              },
                            ),
                          ),
                        ),
                        const SizedBox(height: 8),
                        Text(
                          widget.match.team1Name,
                          style: const TextStyle(
                            fontSize: 16,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                      ],
                    ),
                    Column(
                      children: [
                        ClipRRect(
                          borderRadius: BorderRadius.circular(20),
                          child: Container(
                            height: 60,
                            width: 60,
                            decoration: BoxDecoration(
                              color: Colors.white,
                              borderRadius: BorderRadius.circular(20),
                            ),
                            child: Image.network(
                              widget.match.team2Logo,
                              fit: BoxFit.contain,
                              errorBuilder: (context, error, stackTrace) {
                                return const Icon(Icons.sports_hockey);
                              },
                            ),
                          ),
                        ),
                        const SizedBox(height: 8),
                        Text(
                          widget.match.team2Name,
                          style: const TextStyle(
                            fontSize: 16,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                      ],
                    ),
                  ],
                ),
                const SizedBox(height: 32),
                Row(
                  children: [
                    Expanded(
                      child: TextFormField(
                        controller: _team1ScoreController,
                        decoration: InputDecoration(
                          labelText: '${widget.match.team1Name} Score',
                          border: const OutlineInputBorder(),
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
                        decoration: InputDecoration(
                          labelText: '${widget.match.team2Name} Score',
                          border: const OutlineInputBorder(),
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
                  child: const Text('Update Scores'),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
