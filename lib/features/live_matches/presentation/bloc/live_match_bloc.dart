import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:namhockey/core/usecase/use_case.dart';
import 'package:namhockey/features/live_matches/domain/entity/live_match_entity.dart';
import 'package:namhockey/features/live_matches/domain/usecases/get_live_matches_usecase.dart';
import 'package:namhockey/features/live_matches/domain/usecases/make_live_match_usecase.dart';
import 'package:namhockey/features/live_matches/domain/usecases/update_live_match_usecase.dart';

part 'live_match_event.dart';
part 'live_match_state.dart';

class LiveMatchBloc extends Bloc<LiveMatchEvent, LiveMatchState> {
  final GetLiveMatchesUseCase _getLiveMatchesUseCase;
  final MakeLiveMatchUseCase _makeLiveMatchUseCase;
  final UpdateLiveMatchUseCase _updateLiveMatchUseCase;

  LiveMatchBloc({
    required GetLiveMatchesUseCase getLiveMatchesUseCase,
    required MakeLiveMatchUseCase makeLiveMatchUseCase,
    required UpdateLiveMatchUseCase updateLiveMatchUseCase,
  }) : _getLiveMatchesUseCase = getLiveMatchesUseCase,
       _makeLiveMatchUseCase = makeLiveMatchUseCase,
       _updateLiveMatchUseCase = updateLiveMatchUseCase,
       super(LiveMatchInitial()) {
    on<GetLiveMatchesEvent>(_onGetLiveMatches);
    on<MakeLiveMatchEvent>(_onMakeLiveMatch);
    on<UpdateLiveMatchEvent>(_onUpdateLiveMatch);
  }

  void _onGetLiveMatches(
    GetLiveMatchesEvent event,
    Emitter<LiveMatchState> emit,
  ) async {
    emit(
      LiveMatchLoading(
        matches:
            state is LiveMatchesLoaded
                ? (state as LiveMatchesLoaded).matches
                : [],
      ),
    );
    final result = await _getLiveMatchesUseCase(NoParams());
    result.fold(
      (failure) => emit(LiveMatchFailure(failure.message)),
      (matches) => emit(LiveMatchesLoaded(matches)),
    );
  }

  void _onMakeLiveMatch(
    MakeLiveMatchEvent event,
    Emitter<LiveMatchState> emit,
  ) async {
    emit(
      LiveMatchLoading(
        matches:
            state is LiveMatchesLoaded
                ? (state as LiveMatchesLoaded).matches
                : [],
      ),
    );
    final result = await _makeLiveMatchUseCase(
      MakeLiveMatchParams(
        team1Logo: event.team1Logo,
        team2Logo: event.team2Logo,
        team1Name: event.team1Name,
        team2Name: event.team2Name,
        team1Score: event.team1Score,
        team2Score: event.team2Score,
      ),
    );
    result.fold((failure) => emit(LiveMatchFailure(failure.message)), (r) {
      emit(LiveMatchCreated(r));
      add(GetLiveMatchesEvent());
    });
  }

  void _onUpdateLiveMatch(
    UpdateLiveMatchEvent event,
    Emitter<LiveMatchState> emit,
  ) async {
    emit(
      LiveMatchLoading(
        matches:
            state is LiveMatchesLoaded
                ? (state as LiveMatchesLoaded).matches
                : [],
      ),
    );
    final result = await _updateLiveMatchUseCase(
      UpdateLiveMatchParams(
        id: event.id,
        team1Score: event.team1Score,
        team2Score: event.team2Score,
      ),
    );
    result.fold((failure) => emit(LiveMatchFailure(failure.message)), (r) {
      emit(LiveMatchUpdated());
      add(GetLiveMatchesEvent());
    });
  }
}

class LiveMatchLoading extends LiveMatchState {
  final List<LiveMatchEntity> matches;

  LiveMatchLoading({this.matches = const []});

  @override
  List<Object?> get props => [matches];
}
