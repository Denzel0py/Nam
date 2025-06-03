import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:namhockey/core/common/cubit/app_user/app_user_cubit.dart';
import 'package:namhockey/features/auth/presentation/bloc/auth_bloc.dart';
import 'package:namhockey/features/auth/presentation/pages/sign_in_page.dart';
import 'package:namhockey/features/profile/presentation/pages/edit_profile_page.dart';
import 'package:cached_network_image/cached_network_image.dart';

class ProfileScreen extends StatefulWidget {
  const ProfileScreen({super.key});

  @override
  State<ProfileScreen> createState() => _ProfileScreenState();
}

class _ProfileScreenState extends State<ProfileScreen> {
  @override
  void initState() {
    super.initState();
    // Only refresh user data if we're logged in
    final appUserState = context.read<AppUserCubit>().state;
    if (appUserState is AppUserLoggedIn) {
      context.read<AuthBloc>().add(AuthGetUserDetailsEvent());
    }
  }

  @override
  Widget build(BuildContext context) {
    return BlocConsumer<AuthBloc, AuthState>(
      listener: (context, state) {
        if (state is AuthSuccess) {
          // Only refresh if we're still logged in
          final appUserState = context.read<AppUserCubit>().state;
          if (appUserState is AppUserLoggedIn) {
            setState(() {});
          }
        }
      },
      builder: (context, state) {
        final appUserState = context.read<AppUserCubit>().state;
        if (appUserState is! AppUserLoggedIn) {
          return Scaffold(
            appBar: AppBar(title: const Text('Profile'), centerTitle: true),
            body: const Center(
              child: Text('Please sign in to view your profile'),
            ),
          );
        }

        final user = appUserState.user;
        return Scaffold(
          appBar: AppBar(title: const Text('Profile'), centerTitle: true),
          backgroundColor: const Color.fromARGB(255, 214, 209, 209),
          body: Column(
            children: [
              // Profile Header
              Container(
                padding: const EdgeInsets.all(16.0),
                child: Column(
                  children: [
                    CircleAvatar(
                      radius: 50,
                      backgroundImage:
                          user.profilePictureUrl != null
                              ? CachedNetworkImageProvider(
                                user.profilePictureUrl!,
                              )
                              : null,
                      child:
                          user.profilePictureUrl == null
                              ? const Icon(Icons.person, size: 50)
                              : null,
                    ),
                    const SizedBox(height: 16),
                    Text(
                      user.name,
                      style: const TextStyle(
                        fontSize: 24,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    Text(
                      user.email,
                      style: const TextStyle(fontSize: 16, color: Colors.grey),
                    ),
                    if (user.role.isNotEmpty)
                      Padding(
                        padding: const EdgeInsets.only(top: 8.0),
                        child: Chip(
                          label: Text(
                            user.role.toUpperCase(),
                            style: const TextStyle(
                              color: Colors.white,
                              fontSize: 12,
                            ),
                          ),
                          backgroundColor: Theme.of(context).primaryColor,
                        ),
                      ),
                  ],
                ),
              ),
              const Divider(),

              // Profile Options
              Expanded(
                child: ListView(
                  children: [
                    ListTile(
                      leading: const Icon(Icons.person_outline),
                      title: const Text('Edit Profile'),
                      trailing: const Icon(Icons.chevron_right),
                      onTap: () {
                        Navigator.push(
                          context,
                          MaterialPageRoute(
                            builder: (context) => const EditProfilePage(),
                          ),
                        );
                      },
                    ),
                    ListTile(
                      leading: const Icon(Icons.notifications_outlined),
                      title: const Text('Notifications'),
                      trailing: const Icon(Icons.chevron_right),
                      onTap: () {
                        // Navigate to notifications settings
                      },
                    ),
                    ListTile(
                      leading: const Icon(Icons.security_outlined),
                      title: const Text('Privacy & Security'),
                      trailing: const Icon(Icons.chevron_right),
                      onTap: () {
                        // Navigate to privacy settings
                      },
                    ),
                    ListTile(
                      leading: const Icon(Icons.help_outline),
                      title: const Text('Help & Support'),
                      trailing: const Icon(Icons.chevron_right),
                      onTap: () {
                        // Navigate to help section
                      },
                    ),
                    ListTile(
                      leading: const Icon(Icons.info_outline),
                      title: const Text('About'),
                      trailing: const Icon(Icons.chevron_right),
                      onTap: () {
                        // Navigate to about section
                      },
                    ),
                  ],
                ),
              ),

              // Logout Button
              Padding(
                padding: const EdgeInsets.all(16.0),
                child: SizedBox(
                  width: double.infinity,
                  child: ElevatedButton(
                    onPressed: () {
                      context.read<AuthBloc>().add(AuthLogOutEvent());
                      Navigator.pushAndRemoveUntil(
                        context,
                        MaterialPageRoute(
                          builder: (context) => const SignInPage(),
                        ),
                        (route) => false,
                      );
                    },
                    style: ElevatedButton.styleFrom(
                      backgroundColor: Colors.red,
                      padding: const EdgeInsets.symmetric(vertical: 16),
                    ),
                    child: const Text(
                      'Logout',
                      style: TextStyle(fontSize: 16, color: Colors.white),
                    ),
                  ),
                ),
              ),
            ],
          ),
        );
      },
    );
  }
}
