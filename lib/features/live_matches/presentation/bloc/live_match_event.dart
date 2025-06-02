part of 'live_match_bloc.dart';

@immutable
sealed class LiveMatchEvent {}

class GetLiveMatchesEvent extends LiveMatchEvent {}

class MakeLiveMatchEvent extends LiveMatchEvent {
  final String team1Logo;
  final String team2Logo;
  final String team1Name;
  final String team2Name;
  final String team1Score;
  final String team2Score;

  MakeLiveMatchEvent({
    required this.team1Logo,
    required this.team2Logo,
    required this.team1Name,
    required this.team2Name,
    required this.team1Score,
    required this.team2Score,
  });
}

class UpdateLiveMatchEvent extends LiveMatchEvent {
  final String id;
  final String team1Score;
  final String team2Score;

  UpdateLiveMatchEvent({
    required this.id,
    required this.team1Score,
    required this.team2Score,
  });
}
