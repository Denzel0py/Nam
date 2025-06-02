import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:namhockey/core/common/cubit/app_user/app_user_cubit.dart';
import 'package:namhockey/features/admin/presentation/pages/user_management_page.dart';
import 'package:namhockey/features/games/presentation/bloc/games_bloc.dart';
import 'package:namhockey/features/games/presentation/widgets/add_game_dialog.dart';
import 'package:namhockey/features/games/presentation/widgets/games.dart';
import 'package:namhockey/features/games/presentation/widgets/league_filter.dart';
import 'package:namhockey/features/live_matches/presentation/bloc/live_match_bloc.dart';
import 'package:namhockey/features/live_matches/presentation/pages/add_live_match_page.dart';
import 'package:namhockey/features/live_matches/presentation/widgets/live_match_container.dart';

class HomePage extends StatefulWidget {
  const HomePage({super.key});

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  bool showLeagueFilter = false;
  DateTime? selectedDate; // Make it nullable to represent "All" state

  @override
  void initState() {
    super.initState();
    context.read<GamesBloc>().add(GetGamesEvent());
    context.read<LiveMatchBloc>().add(GetLiveMatchesEvent());
  }

  void _showAddGameDialog() {
    showDialog(context: context, builder: (context) => const AddGameDialog());
  }

  void _showAddLiveMatchDialog() {
    Navigator.push(
      context,
      MaterialPageRoute(builder: (context) => const AddLiveMatchPage()),
    );
  }

  void _selectDate(BuildContext context) async {
    final DateTime? picked = await showDatePicker(
      context: context,
      initialDate: selectedDate ?? DateTime.now(),
      firstDate: DateTime(2000),
      lastDate: DateTime(2100),
    );
    if (picked != null && picked != selectedDate) {
      setState(() {
        selectedDate = picked;
      });
      context.read<GamesBloc>().add(FilterGamesByDateEvent(picked));
    }
  }

  String _getDayName(DateTime date) {
    return date.day == DateTime.now().day
        ? 'Today'
        : date.day == DateTime.now().add(const Duration(days: 1)).day
        ? 'Tomorrow'
        : ['Mon', 'Tue', 'Wed', 'Thu', 'Fri', 'Sat', 'Sun'][date.weekday - 1];
  }

  String _getFormattedDate(DateTime date) {
    return '${date.day} ${['Jan', 'Feb', 'Mar', 'Apr', 'May', 'Jun', 'Jul', 'Aug', 'Sep', 'Oct', 'Nov', 'Dec'][date.month - 1]}';
  }

  @override
  Widget build(BuildContext context) {
    final state = context.read<AppUserCubit>().state;
    final isAdmin = state is AppUserLoggedIn && state.user.role == 'admin';
    final theme = Theme.of(context);

    // Generate dates for the next 5 days
    final dates = List.generate(
      5,
      (index) => DateTime.now().add(Duration(days: index)),
    );

    return Scaffold(
      backgroundColor: Colors.grey[100],
      appBar: AppBar(
        elevation: 0,
        backgroundColor: Colors.white,
        leading: IconButton(
          icon: Icon(Icons.menu, color: theme.primaryColor),
          onPressed: () {},
        ),
        title: SizedBox(
          height: 40,
          child: Image.asset("assets/images/nht.jpg"),
        ),
        centerTitle: true,
        actions: [
          if (isAdmin)
            IconButton(
              icon: Icon(Icons.people, color: theme.primaryColor),
              onPressed: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (context) => const UserManagementPage(),
                  ),
                );
              },
            ),
          IconButton(
            icon: Icon(Icons.search, color: theme.primaryColor),
            onPressed: () {},
          ),
        ],
      ),
      floatingActionButton:
          isAdmin
              ? FloatingActionButton(
                onPressed: _showAddGameDialog,
                backgroundColor: theme.primaryColor,
                child: const Icon(Icons.add, color: Colors.white),
              )
              : null,
      body: SingleChildScrollView(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Container(
              padding: const EdgeInsets.all(16),
              decoration: BoxDecoration(
                color: Colors.white,
                boxShadow: [
                  BoxShadow(
                    color: Colors.grey.withOpacity(0.1),
                    spreadRadius: 1,
                    blurRadius: 2,
                    offset: const Offset(0, 1),
                  ),
                ],
              ),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Text(
                        'Live Matches',
                        style: theme.textTheme.titleLarge?.copyWith(
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                      if (isAdmin)
                        IconButton(
                          icon: const Icon(Icons.add),
                          onPressed: _showAddLiveMatchDialog,
                        ),
                    ],
                  ),
                  const SizedBox(height: 16),
                  BlocBuilder<LiveMatchBloc, LiveMatchState>(
                    builder: (context, state) {
                      if (state is LiveMatchLoading && state.matches.isEmpty) {
                        return const Center(child: CircularProgressIndicator());
                      }
                      if (state is LiveMatchFailure) {
                        return Center(
                          child: Text(
                            state.message,
                            style: const TextStyle(color: Colors.red),
                          ),
                        );
                      }
                      if (state is LiveMatchesLoaded) {
                        if (state.matches.isEmpty) {
                          return const Center(
                            child: Text('No live matches at the moment'),
                          );
                        }
                        return SizedBox(
                          height: 220,
                          child: ListView.builder(
                            scrollDirection: Axis.horizontal,
                            itemCount: state.matches.length,
                            itemBuilder: (context, index) {
                              final colors = [
                                Colors.blue,
                                Colors.grey,
                                Colors.orange,
                                Colors.purple,
                                Colors.teal,
                              ];
                              return Padding(
                                padding: const EdgeInsets.only(right: 16),
                                child: LiveMatchContainer(
                                  match: state.matches[index],
                                  containerColor: colors[index % colors.length],
                                ),
                              );
                            },
                          ),
                        );
                      }
                      return const SizedBox.shrink();
                    },
                  ),
                ],
              ),
            ),
            const SizedBox(height: 16),
            Container(
              margin: const EdgeInsets.symmetric(horizontal: 16),
              padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
              decoration: BoxDecoration(
                color: theme.primaryColor,
                borderRadius: BorderRadius.circular(12),
                boxShadow: [
                  BoxShadow(
                    color: theme.primaryColor.withOpacity(0.2),
                    spreadRadius: 1,
                    blurRadius: 4,
                    offset: const Offset(0, 2),
                  ),
                ],
              ),
              child: SingleChildScrollView(
                scrollDirection: Axis.horizontal,
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.start,
                  children: [
                    // All button
                    Padding(
                      padding: const EdgeInsets.only(right: 8),
                      child: GestureDetector(
                        onTap: () {
                          setState(() {
                            selectedDate = null;
                          });
                          context.read<GamesBloc>().add(GetGamesEvent());
                        },
                        child: Container(
                          padding: const EdgeInsets.symmetric(
                            horizontal: 12,
                            vertical: 6,
                          ),
                          decoration: BoxDecoration(
                            borderRadius: BorderRadius.circular(8),
                            color:
                                selectedDate == null
                                    ? Colors.white
                                    : Colors.transparent,
                          ),
                          child: Text(
                            'All',
                            style: TextStyle(
                              color:
                                  selectedDate == null
                                      ? theme.primaryColor
                                      : Colors.white,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                        ),
                      ),
                    ),
                    // Date buttons
                    ...dates
                        .map(
                          (date) => Padding(
                            padding: const EdgeInsets.only(right: 8),
                            child: GestureDetector(
                              onTap: () {
                                setState(() {
                                  selectedDate = date;
                                });
                                context.read<GamesBloc>().add(
                                  FilterGamesByDateEvent(date),
                                );
                              },
                              child: Container(
                                padding: const EdgeInsets.symmetric(
                                  horizontal: 12,
                                  vertical: 6,
                                ),
                                decoration: BoxDecoration(
                                  borderRadius: BorderRadius.circular(8),
                                  color:
                                      selectedDate?.day == date.day
                                          ? Colors.white
                                          : Colors.transparent,
                                ),
                                child: Column(
                                  children: [
                                    Text(
                                      _getDayName(date),
                                      style: TextStyle(
                                        color:
                                            selectedDate?.day == date.day
                                                ? theme.primaryColor
                                                : Colors.white,
                                        fontWeight: FontWeight.bold,
                                      ),
                                    ),
                                    Text(
                                      _getFormattedDate(date),
                                      style: TextStyle(
                                        color:
                                            selectedDate?.day == date.day
                                                ? theme.primaryColor
                                                : Colors.white,
                                        fontSize: 12,
                                      ),
                                    ),
                                  ],
                                ),
                              ),
                            ),
                          ),
                        )
                        .toList(),
                    IconButton(
                      onPressed: () => _selectDate(context),
                      icon: const Icon(
                        Icons.calendar_month,
                        color: Colors.white,
                      ),
                    ),
                  ],
                ),
              ),
            ),
            if (showLeagueFilter) LeagueFilter(),
            const SizedBox(height: 16),
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 16),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Text(
                    'Upcoming Matches',
                    style: theme.textTheme.titleLarge?.copyWith(
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  if (isAdmin)
                    IconButton(
                      icon: const Icon(Icons.add),
                      onPressed: _showAddGameDialog,
                    ),
                ],
              ),
            ),
            const SizedBox(height: 16),
            BlocConsumer<GamesBloc, GamesState>(
              listener: (context, state) {
                if (state is GamesFailure) {
                  ScaffoldMessenger.of(context).showSnackBar(
                    SnackBar(
                      content: Text(state.message),
                      backgroundColor: Colors.red,
                    ),
                  );
                }
              },
              builder: (context, state) {
                if (state is GamesLoading) {
                  return const Center(child: CircularProgressIndicator());
                }
                if (state is GamesLoaded) {
                  if (selectedDate != null && state.games.isEmpty) {
                    return Center(
                      child: Padding(
                        padding: const EdgeInsets.all(16.0),
                        child: Text(
                          'No matches scheduled for ${_getFormattedDate(selectedDate!)}',
                          style: TextStyle(
                            fontSize: 16,
                            color: Colors.grey[600],
                          ),
                        ),
                      ),
                    );
                  }
                  return Container(
                    margin: const EdgeInsets.symmetric(horizontal: 16),
                    decoration: BoxDecoration(
                      color: Colors.white,
                      borderRadius: BorderRadius.circular(12),
                      boxShadow: [
                        BoxShadow(
                          color: Colors.grey.withOpacity(0.1),
                          spreadRadius: 1,
                          blurRadius: 2,
                          offset: const Offset(0, 1),
                        ),
                      ],
                    ),
                    child: ListView.separated(
                      shrinkWrap: true,
                      physics: const NeverScrollableScrollPhysics(),
                      itemCount: state.games.length,
                      separatorBuilder:
                          (context, index) => const Divider(height: 1),
                      itemBuilder: (context, index) {
                        return Games(game: state.games[index]);
                      },
                    ),
                  );
                }
                return const SizedBox.shrink();
              },
            ),
          ],
        ),
      ),
    );
  }
}
