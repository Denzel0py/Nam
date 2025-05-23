import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:image_picker/image_picker.dart';
import 'dart:io';
import 'package:namhockey/features/auth/presentation/bloc/auth_bloc.dart';

class UserManagementPage extends StatefulWidget {
  const UserManagementPage({super.key});

  @override
  State<UserManagementPage> createState() => _UserManagementPageState();
}

class _UserManagementPageState extends State<UserManagementPage> {
  @override
  void initState() {
    super.initState();
    context.read<AuthBloc>().add(GetAllUsersEvent());
  }

  void _showMakeCoachDialog(BuildContext context, String userId) {
    showDialog(
      context: context,
      builder: (context) => MakeCoachDialog(userId: userId),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('User Management')),

      backgroundColor: const Color.fromARGB(255, 214, 207, 207),
      body: BlocConsumer<AuthBloc, AuthState>(
        listener: (context, state) {
          if (state is AuthFailure) {
            ScaffoldMessenger.of(context).showSnackBar(
              SnackBar(
                content: Text(state.message),
                backgroundColor: Colors.red,
              ),
            );
          } else if (state is AuthSuccess) {
            ScaffoldMessenger.of(context).showSnackBar(
              const SnackBar(
                content: Text('Successfully made user a coach'),
                backgroundColor: Colors.green,
              ),
            );
            Navigator.pop(context);
            context.read<AuthBloc>().add(GetAllUsersEvent());
          }
        },
        builder: (context, state) {
          if (state is AuthLoading) {
            return const Center(child: CircularProgressIndicator());
          } else if (state is UsersLoaded) {
            return ListView.builder(
              itemCount: state.users.length,
              itemBuilder: (context, index) {
                final user = state.users[index];
                return Card(
                  margin: const EdgeInsets.symmetric(
                    horizontal: 16,
                    vertical: 8,
                  ),
                  child: ListTile(
                    leading: const CircleAvatar(child: Icon(Icons.person)),
                    title: Text(user.name),
                    subtitle: Text('Current Role: ${user.role}'),
                    trailing:
                        user.role != 'coach'
                            ? PopupMenuButton<String>(
                              onSelected: (value) {
                                if (value == 'make_coach') {
                                  _showMakeCoachDialog(context, user.id);
                                }
                              },
                              itemBuilder:
                                  (context) => [
                                    const PopupMenuItem(
                                      value: 'make_coach',
                                      child: Text('Make Coach'),
                                    ),
                                  ],
                            )
                            : null,
                  ),
                );
              },
            );
          }
          return const Center(child: Text('No users found'));
        },
      ),
    );
  }
}

class MakeCoachDialog extends StatefulWidget {
  final String userId;

  const MakeCoachDialog({super.key, required this.userId});

  @override
  State<MakeCoachDialog> createState() => _MakeCoachDialogState();
}

class _MakeCoachDialogState extends State<MakeCoachDialog> {
  final _formKey = GlobalKey<FormState>();
  File? _teamLogo;
  final _teamNameController = TextEditingController();
  bool _isLoading = false;

  Future<void> _pickImage() async {
    try {
      final ImagePicker picker = ImagePicker();
      final XFile? image = await picker.pickImage(
        source: ImageSource.gallery,
        maxWidth: 800,
        maxHeight: 800,
        imageQuality: 85,
      );

      if (image != null) {
        setState(() {
          _teamLogo = File(image.path);
        });
      }
    } catch (e) {
      if (mounted) {
        ScaffoldMessenger.of(
          context,
        ).showSnackBar(SnackBar(content: Text('Error picking image: $e')));
      }
    }
  }

  void _makeCoach() {
    if (!_formKey.currentState!.validate()) return;
    if (_teamLogo == null) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Please select a team logo')),
      );
      return;
    }

    setState(() {
      _isLoading = true;
    });

    context.read<AuthBloc>().add(
      MakeCoachEvent(
        userId: widget.userId,
        teamName: _teamNameController.text,
        teamLogo: _teamLogo!,
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return AlertDialog(
      title: const Text('Make Coach'),
      content: Form(
        key: _formKey,
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            TextFormField(
              controller: _teamNameController,
              decoration: const InputDecoration(labelText: 'Team Name'),
              validator: (value) {
                if (value == null || value.isEmpty) {
                  return 'Please enter a team name';
                }
                return null;
              },
            ),
            const SizedBox(height: 16),
            ElevatedButton.icon(
              onPressed: _isLoading ? null : _pickImage,
              icon: const Icon(Icons.image),
              label: Text(
                _teamLogo == null ? 'Select Team Logo' : 'Change Team Logo',
              ),
            ),
            if (_teamLogo != null) ...[
              const SizedBox(height: 8),
              ClipRRect(
                borderRadius: BorderRadius.circular(8),
                child: Image.file(
                  _teamLogo!,
                  height: 100,
                  width: 100,
                  fit: BoxFit.cover,
                  errorBuilder: (context, error, stackTrace) {
                    return Container(
                      height: 100,
                      width: 100,
                      color: Colors.grey[300],
                      child: const Icon(Icons.error),
                    );
                  },
                ),
              ),
            ],
            if (_isLoading) ...[
              const SizedBox(height: 16),
              const CircularProgressIndicator(),
            ],
          ],
        ),
      ),
      actions: [
        TextButton(
          onPressed: _isLoading ? null : () => Navigator.pop(context),
          child: const Text('Cancel'),
        ),
        ElevatedButton(
          onPressed: _isLoading ? null : _makeCoach,
          child: const Text('Make Coach'),
        ),
      ],
    );
  }

  @override
  void dispose() {
    _teamNameController.dispose();
    super.dispose();
  }
}
