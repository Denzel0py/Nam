part of 'games_bloc.dart';

@immutable
abstract class GamesState {}

class GamesInitial extends GamesState {}

class GamesLoading extends GamesState {}

class GamesLoaded extends GamesState {
  final List<GameEntity> games;

  GamesLoaded(this.games);
}

class GamesFailure extends GamesState {
  final String message;

  GamesFailure(this.message);
}
