import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:get_it/get_it.dart';
import 'package:iconly/iconly.dart';
import 'package:namhockey/core/common/cubit/app_user/app_user_cubit.dart';
import 'package:namhockey/features/admin/presentation/pages/user_management_page.dart';
import 'package:namhockey/features/discussion/presentation/bloc/discussion_bloc.dart';
import 'package:namhockey/features/games/presentation/pages/home_page.dart';
import 'package:namhockey/features/news/presentation/bloc/news_bloc.dart';
import 'package:namhockey/features/news/presentation/pages/news_page.dart';
import 'package:namhockey/features/profile/presentation/pages/profile_screen.dart';
import 'package:namhockey/features/teams/presentation/bloc/team_bloc.dart';
import 'package:namhockey/features/teams/presentation/pages/team_management_page.dart';
import 'package:namhockey/features/teams/presentation/pages/player_registration_page.dart';
import 'package:namhockey/features/discussion/presentation/pages/discussion_page.dart';

class MainNavigationPage extends StatefulWidget {
  const MainNavigationPage({super.key});

  @override
  State<MainNavigationPage> createState() => _MainNavigationPageState();
}

class _MainNavigationPageState extends State<MainNavigationPage> {
  int _selectedIndex = 0;
  String? _teamName;
  late final TeamBloc _teamBloc;

  @override
  void initState() {
    super.initState();
    _teamBloc = GetIt.I<TeamBloc>();
    _loadTeamName();
  }

  @override
  void dispose() {
    _teamBloc.close();
    super.dispose();
  }

  Future<void> _loadTeamName() async {
    final appUserState = context.read<AppUserCubit>().state;
    if (appUserState is AppUserLoggedIn && appUserState.user.teamId != null) {
      _teamBloc.add(GetTeamNameEvent(appUserState.user.teamId!));
    }
  }

  List<Widget> _getPages(String role) {
    final pages = [
      HomePage(),
      BlocProvider.value(value: GetIt.I<NewsBloc>(), child: const NewsPage()),
    ];

    // Add role-specific pages
    if (role == 'admin') {
      pages.add(
        const UserManagementPage(),
      ); // Using TeamManagementPage for adding teams
    } else if (role == 'coach') {
      pages.add(const TeamManagementPage());
    } else if (role == 'player') {
      pages.add(const PlayerRegistrationPage());
    }

    // Add team discussion for both players and coaches
    if (role == 'player' || role == 'coach') {
      final appUserState = context.read<AppUserCubit>().state;
      if (appUserState is AppUserLoggedIn && appUserState.user.teamId != null) {
        pages.add(
          BlocProvider.value(
            value: GetIt.I<DiscussionBloc>(),
            child: DiscussionPage(
              teamId: appUserState.user.teamId!,
              teamName: _teamName ?? 'Team Discussion',
            ),
          ),
        );
      }
    }

    // Add profile page last
    pages.add(const ProfileScreen());

    return pages;
  }

  List<BottomNavigationBarItem> _getNavItems(String role) {
    final items = [
      BottomNavigationBarItem(
        icon: Icon(
          _getIconData(0, _selectedIndex == 0),
          size: 25,
          color: _selectedIndex == 0 ? Colors.blue : Colors.grey,
        ),
        label: 'Home',
      ),
      BottomNavigationBarItem(
        icon: Icon(
          _getIconData(1, _selectedIndex == 1),
          size: 30,
          color: _selectedIndex == 1 ? Colors.blue : Colors.grey,
        ),
        label: 'News',
      ),
    ];

    // Add role-specific items
    if (role == 'admin') {
      items.add(
        BottomNavigationBarItem(
          icon: Icon(
            Icons.group_add,
            size: 25,
            color: _selectedIndex == 2 ? Colors.blue : Colors.grey,
          ),
          label: 'Add Teams',
        ),
      );
    } else if (role == 'coach') {
      items.add(
        BottomNavigationBarItem(
          icon: Icon(
            Icons.group,
            size: 25,
            color: _selectedIndex == 2 ? Colors.blue : Colors.grey,
          ),
          label: 'Teams',
        ),
      );
    } else if (role == 'player') {
      items.add(
        BottomNavigationBarItem(
          icon: Icon(
            Icons.sports_hockey,
            size: 25,
            color: _selectedIndex == 2 ? Colors.blue : Colors.grey,
          ),
          label: 'Join Team',
        ),
      );
    }

    // Add team discussion for both players and coaches
    if (role == 'player' || role == 'coach') {
      final appUserState = context.read<AppUserCubit>().state;
      if (appUserState is AppUserLoggedIn && appUserState.user.teamId != null) {
        items.add(
          BottomNavigationBarItem(
            icon: Icon(
              Icons.chat,
              size: 25,
              color:
                  _selectedIndex == (role == 'coach' ? 3 : 3)
                      ? Colors.blue
                      : Colors.grey,
            ),
            label: 'Discussion',
          ),
        );
      }
    }

    // Add profile item last
    items.add(
      BottomNavigationBarItem(
        icon: Icon(
          _getIconData(
            3,
            _selectedIndex ==
                (role == 'admin'
                    ? 3
                    : role == 'coach'
                    ? 4
                    : role == 'player'
                    ? 4
                    : 3),
          ),
          size: 30,
          color:
              _selectedIndex ==
                      (role == 'admin'
                          ? 3
                          : role == 'coach'
                          ? 4
                          : role == 'player'
                          ? 4
                          : 3)
                  ? Colors.blue
                  : Colors.grey,
        ),
        label: 'Profile',
      ),
    );

    return items;
  }

  void _onItemTapped(int index) {
    setState(() {
      _selectedIndex = index;
    });
  }

  IconData _getIconData(int index, bool isSelected) {
    switch (index) {
      case 0:
        return isSelected ? IconlyBold.home : IconlyLight.home;
      case 1:
        return isSelected ? IconlyBold.paper : IconlyLight.paper;
      case 2:
        return isSelected ? IconlyBold.bookmark : IconlyLight.bookmark;
      case 3:
        return isSelected ? IconlyBold.profile : IconlyLight.profile;
      default:
        return IconlyLight.home;
    }
  }

  @override
  Widget build(BuildContext context) {
    final appUserState = context.read<AppUserCubit>().state;
    if (appUserState is! AppUserLoggedIn) {
      return const Scaffold(
        body: Center(child: Text('You must be logged in to access this page')),
      );
    }

    return BlocListener<TeamBloc, TeamState>(
      bloc: _teamBloc,
      listener: (context, state) {
        if (state is TeamLoaded) {
          setState(() {
            _teamName = state.teamName;
          });
        }
      },
      child: Scaffold(
        body: _getPages(appUserState.user.role)[_selectedIndex],
        bottomNavigationBar: BottomNavigationBar(
          items: _getNavItems(appUserState.user.role),
          currentIndex: _selectedIndex,
          onTap: _onItemTapped,
          type: BottomNavigationBarType.fixed,
        ),
      ),
    );
  }
}
