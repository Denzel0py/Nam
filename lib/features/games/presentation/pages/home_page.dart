import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:namhockey/core/common/cubit/app_user/app_user_cubit.dart';
import 'package:namhockey/features/admin/presentation/pages/user_management_page.dart';
import 'package:namhockey/features/games/presentation/bloc/games_bloc.dart';
import 'package:namhockey/features/games/presentation/widgets/add_game_dialog.dart';
import 'package:namhockey/features/games/presentation/widgets/games.dart';
import 'package:namhockey/features/games/presentation/widgets/live_games.dart';
import 'package:namhockey/features/games/presentation/widgets/league_filter.dart';

class HomePage extends StatefulWidget {
  const HomePage({super.key});

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  bool showLeagueFilter = false;

  @override
  void initState() {
    super.initState();
    context.read<GamesBloc>().add(GetGamesEvent());
  }

  void _showAddGameDialog() {
    showDialog(context: context, builder: (context) => const AddGameDialog());
  }

  @override
  Widget build(BuildContext context) {
    final state = context.read<AppUserCubit>().state;
    final isAdmin = state is AppUserLoggedIn && state.user.role == 'admin';

    return Scaffold(
      appBar: AppBar(
        leading: Icon(Icons.menu, color: Colors.grey),
        title: Container(
          height: 120,
          width: 120,
          child: Image.asset("assets/images/nht.jpg"),
        ),
        centerTitle: true,
        actions: [
          if (isAdmin)
            IconButton(
              icon: const Icon(Icons.people, color: Colors.grey),
              onPressed: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (context) => const UserManagementPage(),
                  ),
                );
              },
            ),
          Padding(
            padding: const EdgeInsets.only(right: 16.0),
            child: Icon(Icons.search, color: Colors.grey),
          ),
        ],
      ),
      floatingActionButton:
          isAdmin
              ? FloatingActionButton(
                onPressed: _showAddGameDialog,
                child: const Icon(Icons.add),
              )
              : null,
      body: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 16.0),
        child: SingleChildScrollView(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              SizedBox(height: 16.0),
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Text('Live Matches', style: TextStyle(fontSize: 16)),
                  Text(
                    'View All',
                    style: TextStyle(fontSize: 16, color: Colors.grey),
                  ),
                ],
              ),
              SizedBox(height: 16.0),
              SizedBox(
                height: 200,
                child: ListView.builder(
                  scrollDirection: Axis.horizontal,
                  itemCount: 5,
                  itemBuilder: (context, index) {
                    final colors = [
                      Colors.blue,
                      Colors.grey,
                      Colors.orange,
                      Colors.purple,
                      Colors.teal,
                    ];
                    return Padding(
                      padding: const EdgeInsets.only(right: 16.0),
                      child: LiveGames(containerColor: colors[index]),
                    );
                  },
                ),
              ),
              SizedBox(height: 20.0),
              Container(
                padding: EdgeInsets.symmetric(horizontal: 16.0),
                height: 50,
                width: double.infinity,
                decoration: BoxDecoration(
                  color: Colors.black,
                  borderRadius: BorderRadius.circular(10),
                ),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Container(
                      padding: EdgeInsets.symmetric(
                        horizontal: 10,
                        vertical: 3,
                      ),
                      decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(10),
                        color: Colors.red,
                      ),
                      child: GestureDetector(
                        onTap: () {
                          setState(() {
                            showLeagueFilter = !showLeagueFilter;
                          });
                        },
                        child: Text('All'),
                      ),
                    ),
                    Column(
                      children: [
                        Text('Mon', style: TextStyle(color: Colors.grey)),
                        Text('28 Apr', style: TextStyle(color: Colors.grey)),
                      ],
                    ),
                    Column(
                      children: [
                        Text('Tue', style: TextStyle(color: Colors.grey)),
                        Text('29 Apr', style: TextStyle(color: Colors.grey)),
                      ],
                    ),
                    Column(
                      children: [
                        Text('Today', style: TextStyle(color: Colors.white)),
                        Text('30 Apr', style: TextStyle(color: Colors.white)),
                      ],
                    ),
                    Column(
                      children: [
                        Text('Thur', style: TextStyle(color: Colors.grey)),
                        Text('1 May', style: TextStyle(color: Colors.grey)),
                      ],
                    ),
                    Row(
                      children: [
                        GestureDetector(
                          onTap: () async {
                            final DateTime? picked = await showDatePicker(
                              context: context,
                              initialDate: DateTime.now(),
                              firstDate: DateTime(2000),
                              lastDate: DateTime(2100),
                            );
                            // Handle the selected date if needed
                          },
                          child: Row(
                            children: [
                              Icon(Icons.calendar_month, color: Colors.white),
                              Icon(Icons.arrow_drop_down, color: Colors.white),
                            ],
                          ),
                        ),
                      ],
                    ),
                  ],
                ),
              ),
              if (showLeagueFilter) LeagueFilter(),
              SizedBox(height: 16.0),
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
                    return Container(
                      padding: EdgeInsets.all(16),
                      height: 250,
                      width: double.infinity,
                      decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(10),
                        color: Colors.grey,
                      ),
                      child: ListView.builder(
                        itemCount: state.games.length,
                        itemBuilder: (context, index) {
                          return Games(game: state.games[index]);
                        },
                      ),
                    );
                  }

                  return Container(
                    padding: EdgeInsets.all(16),
                    height: 250,
                    width: double.infinity,
                    decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(10),
                      color: Colors.grey,
                    ),
                    child: Center(
                      child: Text(
                        'No games available',
                        style: TextStyle(color: Colors.white),
                      ),
                    ),
                  );
                },
              ),
            ],
          ),
        ),
      ),
    );
  }
}
