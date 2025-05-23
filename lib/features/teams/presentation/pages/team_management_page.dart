import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:namhockey/core/common/cubit/app_user/app_user_cubit.dart';
import 'package:namhockey/features/auth/presentation/bloc/auth_bloc.dart';

class TeamManagementPage extends StatefulWidget {
  const TeamManagementPage({super.key});

  @override
  State<TeamManagementPage> createState() => _TeamManagementPageState();
}

class _TeamManagementPageState extends State<TeamManagementPage> {
  @override
  void initState() {
    super.initState();
    context.read<AuthBloc>().add(GetAllUsersEvent());
  }

  void _showAddPlayerDialog(BuildContext context, String userId) {
    showDialog(
      context: context,
      builder: (context) => AddPlayerDialog(userId: userId),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Team Management')),
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
                content: Text('Successfully updated team'),
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
            // Get current user from AppUserCubit
            final appUserState = context.read<AppUserCubit>().state;
            if (appUserState is! AppUserLoggedIn) {
              return const Center(
                child: Text('You must be logged in to manage your team'),
              );
            }

            final currentUser = appUserState.user;
            if (currentUser.teamId == null) {
              return const Center(
                child: Text('You are not assigned to a team'),
              );
            }

            // Split users into available users and current players
            final availableUsers =
                state.users
                    .where(
                      (user) =>
                          user.role != 'admin' &&
                          user.id != currentUser.id &&
                          user.role == 'user', // Only show regular users
                    )
                    .toList();

            final currentPlayers =
                state.users
                    .where(
                      (user) =>
                          user.role == 'player' &&
                          user.teamId == currentUser.teamId,
                    )
                    .toList();

            return SingleChildScrollView(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  // Current Players Section
                  Padding(
                    padding: const EdgeInsets.all(16.0),
                    child: Text(
                      'Current Players',
                      style: Theme.of(context).textTheme.titleLarge,
                    ),
                  ),
                  if (currentPlayers.isEmpty)
                    const Padding(
                      padding: EdgeInsets.all(16.0),
                      child: Text('No players in your team yet'),
                    )
                  else
                    ListView.builder(
                      shrinkWrap: true,
                      physics: const NeverScrollableScrollPhysics(),
                      itemCount: currentPlayers.length,
                      itemBuilder: (context, index) {
                        final player = currentPlayers[index];
                        return Card(
                          margin: const EdgeInsets.symmetric(
                            horizontal: 16,
                            vertical: 8,
                          ),
                          child: ListTile(
                            leading: const CircleAvatar(
                              child: Icon(Icons.person),
                            ),
                            title: Text(player.name),
                            subtitle: Text('Role: ${player.role}'),
                            trailing: ElevatedButton(
                              onPressed: () {
                                context.read<AuthBloc>().add(
                                  MakeRegularUserEvent(userId: player.id),
                                );
                              },
                              style: ElevatedButton.styleFrom(
                                backgroundColor: Colors.red,
                              ),
                              child: const Text('Remove Player'),
                            ),
                          ),
                        );
                      },
                    ),

                  // Available Users Section
                  Padding(
                    padding: const EdgeInsets.all(16.0),
                    child: Text(
                      'Available Users',
                      style: Theme.of(context).textTheme.titleLarge,
                    ),
                  ),
                  if (availableUsers.isEmpty)
                    const Padding(
                      padding: EdgeInsets.all(16.0),
                      child: Text('No users available to add as players'),
                    )
                  else
                    ListView.builder(
                      shrinkWrap: true,
                      physics: const NeverScrollableScrollPhysics(),
                      itemCount: availableUsers.length,
                      itemBuilder: (context, index) {
                        final user = availableUsers[index];
                        return Card(
                          margin: const EdgeInsets.symmetric(
                            horizontal: 16,
                            vertical: 8,
                          ),
                          child: ListTile(
                            leading: const CircleAvatar(
                              child: Icon(Icons.person),
                            ),
                            title: Text(user.name),
                            subtitle: Text('Current Role: ${user.role}'),
                            trailing: ElevatedButton(
                              onPressed:
                                  () => _showAddPlayerDialog(context, user.id),
                              child: const Text('Add as Player'),
                            ),
                          ),
                        );
                      },
                    ),
                ],
              ),
            );
          }
          return const Center(child: Text('No users found'));
        },
      ),
    );
  }
}

class AddPlayerDialog extends StatefulWidget {
  final String userId;

  const AddPlayerDialog({super.key, required this.userId});

  @override
  State<AddPlayerDialog> createState() => _AddPlayerDialogState();
}

class _AddPlayerDialogState extends State<AddPlayerDialog> {
  bool _isLoading = false;

  @override
  Widget build(BuildContext context) {
    final appUserState = context.read<AppUserCubit>().state;
    if (appUserState is! AppUserLoggedIn || appUserState.user.teamId == null) {
      return const SizedBox.shrink();
    }

    return AlertDialog(
      title: const Text('Add Player to Team'),
      content: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          const Text(
            'Are you sure you want to add this user as a player to your team?',
          ),
          if (_isLoading) ...[
            const SizedBox(height: 16),
            const CircularProgressIndicator(),
          ],
        ],
      ),
      actions: [
        TextButton(
          onPressed: _isLoading ? null : () => Navigator.pop(context),
          child: const Text('Cancel'),
        ),
        ElevatedButton(
          onPressed:
              _isLoading
                  ? null
                  : () {
                    setState(() {
                      _isLoading = true;
                    });
                    context.read<AuthBloc>().add(
                      MakePlayerEvent(
                        userId: widget.userId,
                        teamId: appUserState.user.teamId!,
                      ),
                    );
                  },
          child: const Text('Add Player'),
        ),
      ],
    );
  }

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    final state = context.read<AuthBloc>().state;
    if (state is AuthFailure) {
      setState(() {
        _isLoading = false;
      });
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text(state.message), backgroundColor: Colors.red),
      );
    } else if (state is AuthSuccess) {
      setState(() {
        _isLoading = false;
      });
      Navigator.pop(context);
      context.read<AuthBloc>().add(GetAllUsersEvent());
    }
  }
}
