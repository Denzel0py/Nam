import 'package:fpdart/fpdart.dart';
import 'package:namhockey/core/error/failure.dart';
import 'package:namhockey/core/usecase/use_case.dart';
import 'package:namhockey/features/games/domain/entity/game_entity.dart';
import 'package:namhockey/features/games/domain/repository/game_repository.dart';

class MakeGamesUseCase implements UseCase<List<GameEntity>, MakeGamesParams> {
  final GameRepository gameRepository;

  MakeGamesUseCase({required this.gameRepository});

  @override
  Future<Either<Failure, List<GameEntity>>> call(MakeGamesParams params) async {
    return await gameRepository.makeGames(
      team1: params.team1,
      team2: params.team2,
      league: params.league,
      team1Logo: params.team1Logo,
      team2Logo: params.team2Logo,
      gameDate: params.gameDate,
      gameTime: params.gameTime,
      gameLocation: params.gameLocation,
    );
  }
}

class MakeGamesParams {
  final String team1;
  final String team2;
  final String league;
  final String team1Logo;
  final String team2Logo;
  final String gameDate;
  final String gameTime;
  final String gameLocation;

  MakeGamesParams({
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
