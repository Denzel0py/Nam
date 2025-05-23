import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:namhockey/core/common/entities/user_entity.dart';
import 'package:namhockey/features/auth/presentation/pages/sign_in_page.dart';

class RoleGuard extends StatelessWidget {
  final Widget child;
  final List<String> allowedRoles;

  const RoleGuard({
    super.key,
    required this.child,
    required this.allowedRoles,
  });

  @override
  Widget build(BuildContext context) {
    final user = context.watch<UserEntity?>();
    
    if (user == null) {
      // Redirect to login if no user
      return const SignInPage();
    }

    if (!allowedRoles.contains(user.role)) {
      // Redirect to home or show error if role not allowed
      return Scaffold(
        body: Center(
          child: Text('Access denied. Required roles: ${allowedRoles.join(', ')}'),
        ),
      );
    }

    return child;
  }
} 