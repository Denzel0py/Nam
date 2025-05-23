import 'package:flutter/material.dart';
import 'package:namhockey/core/common/navigation/role_guard.dart';
import 'package:namhockey/features/auth/presentation/pages/sign_in_page.dart';
import 'package:namhockey/features/auth/presentation/pages/sign_up_page.dart';
import 'package:namhockey/features/games/presentation/pages/home_page.dart';
import 'package:namhockey/features/games/presentation/pages/add_match_page.dart';
import 'package:namhockey/features/teams/presentation/pages/team_management_page.dart';
import 'package:namhockey/features/teams/presentation/pages/player_registration_page.dart';
import 'package:namhockey/features/teams/presentation/pages/team_discussion_page.dart';
import 'package:namhockey/features/admin/presentation/pages/user_management_page.dart';

class AppRoutes {
  static const String home = '/';
  static const String signIn = '/sign-in';
  static const String signUp = '/sign-up';
  static const String teamManagement = '/team-management';
  static const String playerRegistration = '/player-registration';
  static const String teamDiscussion = '/team-discussion';
  static const String addMatch = '/add-match';
  static const String userManagement = '/user-management';

  static Route<dynamic> generateRoute(RouteSettings settings) {
    switch (settings.name) {
      case home:
        return MaterialPageRoute(builder: (_) => HomePage());
      case signIn:
        return MaterialPageRoute(builder: (_) => const SignInPage());
      case signUp:
        return MaterialPageRoute(builder: (_) => const SignUpPage());
      case teamManagement:
        return MaterialPageRoute(
          builder:
              (_) => RoleGuard(
                allowedRoles: ['coach'],
                child: const TeamManagementPage(),
              ),
        );
      case playerRegistration:
        return MaterialPageRoute(
          builder:
              (_) => RoleGuard(
                allowedRoles: ['player'],
                child: const PlayerRegistrationPage(),
              ),
        );
      case teamDiscussion:
        return MaterialPageRoute(
          builder:
              (_) => RoleGuard(
                allowedRoles: ['player', 'coach'],
                child: const TeamDiscussionPage(),
              ),
        );
      case addMatch:
        return MaterialPageRoute(
          builder:
              (_) => RoleGuard(
                allowedRoles: ['admin'],
                child: const AddMatchPage(),
              ),
        );
      case userManagement:
        return MaterialPageRoute(
          builder:
              (_) => RoleGuard(
                allowedRoles: ['admin'],
                child: const UserManagementPage(),
              ),
        );
      default:
        return MaterialPageRoute(
          builder:
              (_) => Scaffold(
                body: Center(
                  child: Text('No route defined for ${settings.name}'),
                ),
              ),
        );
    }
  }
}
