import 'package:fpdart/fpdart.dart';
import 'package:namhockey/core/error/failure.dart';
import 'package:namhockey/features/games/domain/entity/game_entity.dart';

abstract class GameRepository {
  Future<Either<Failure, List<GameEntity>>> getGames();
  Future<Either<Failure, List<GameEntity>>> makeGames({
    required String team1,
    required String team2,
    required String league,
    required String team1Logo,
    required String team2Logo,
    required String gameDate,
    required String gameTime,
    required String gameLocation,
  });
}




