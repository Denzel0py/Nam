import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import 'package:namhockey/core/usecase/use_case.dart';
import 'package:namhockey/features/games/domain/entity/game_entity.dart';
import 'package:namhockey/features/games/domain/usecase/get_games_usecase.dart';
import 'package:namhockey/features/games/domain/usecase/make_games_usecase.dart';

part 'games_event.dart';
part 'games_state.dart';

class GamesBloc extends Bloc<GamesEvent, GamesState> {
  final GetGamesUseCase _getGamesUseCase;
  final MakeGamesUseCase _makeGamesUseCase;

  GamesBloc({
    required GetGamesUseCase getGamesUseCase,
    required MakeGamesUseCase makeGamesUseCase,
  })  : _getGamesUseCase = getGamesUseCase,
        _makeGamesUseCase = makeGamesUseCase,
        super(GamesInitial()) {
    on<GetGamesEvent>(_onGetGames);
    on<MakeGamesEvent>(_onMakeGames);
  }

  void _onGetGames(GetGamesEvent event, Emitter<GamesState> emit) async {
    emit(GamesLoading());
    final res = await _getGamesUseCase(NoParams());
    
    res.fold(
      (l) => emit(GamesFailure(l.message)),
      (r) => emit(GamesLoaded(r)),
    );
  }

  void _onMakeGames(MakeGamesEvent event, Emitter<GamesState> emit) async {
    emit(GamesLoading());
    final res = await _makeGamesUseCase(MakeGamesParams(
      team1: event.team1,
      team2: event.team2,
      league: event.league,
      team1Logo: event.team1Logo,
      team2Logo: event.team2Logo,
      gameDate: event.gameDate,
      gameTime: event.gameTime,
      gameLocation: event.gameLocation,
    ));
    
    res.fold(
      (l) => emit(GamesFailure(l.message)),
      (r) => emit(GamesLoaded(r)),
    );
  }
}
