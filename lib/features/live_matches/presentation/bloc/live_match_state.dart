part of 'live_match_bloc.dart';

@immutable
sealed class LiveMatchState {}

final class LiveMatchInitial extends LiveMatchState {}

final class LiveMatchFailure extends LiveMatchState {
  final String message;

  LiveMatchFailure(this.message);
}

final class LiveMatchesLoaded extends LiveMatchState {
  final List<LiveMatchEntity> matches;

  LiveMatchesLoaded(this.matches);
}

final class LiveMatchCreated extends LiveMatchState {
  final LiveMatchEntity match;

  LiveMatchCreated(this.match);
}

final class LiveMatchUpdated extends LiveMatchState {}
