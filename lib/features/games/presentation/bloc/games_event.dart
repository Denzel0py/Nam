part of 'games_bloc.dart';

@immutable
abstract class GamesEvent {}

class GetGamesEvent extends GamesEvent {}

class MakeGamesEvent extends GamesEvent {
  final String team1;
  final String team2;
  final String league;
  final String team1Logo;
  final String team2Logo;
  final String gameDate;
  final String gameTime;
  final String gameLocation;

  MakeGamesEvent({
    required this.team1,
    required this.team2,
    required this.league,
    required this.team1Logo,
    required this.team2Logo,
    required this.gameDate,
    required this.gameTime,
    required this.gameLocation,
  });
}
