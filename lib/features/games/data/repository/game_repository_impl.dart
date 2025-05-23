import 'package:fpdart/fpdart.dart';
import 'package:namhockey/core/error/failure.dart';
import 'package:namhockey/core/error/server_exeption.dart';
import 'package:namhockey/features/games/data/datasources/games_remote_source.dart';
import 'package:namhockey/features/games/domain/entity/game_entity.dart';
import 'package:namhockey/features/games/domain/repository/game_repository.dart';

class GameRepositoryImpl implements GameRepository {
  final GamesRemoteDataSource remoteDataSource;

  GameRepositoryImpl(this.remoteDataSource);

  @override
  Future<Either<Failure, List<GameEntity>>> getGames() async {
    try {
      final games = await remoteDataSource.getGames();
      return right(games);
    } on ServerException catch (e) {
      return left(Failure(e.message));
    } catch (e) {
      return left(Failure(e.toString()));
    }
  }

  @override
  Future<Either<Failure, List<GameEntity>>> makeGames({
    required String team1,
    required String team2,
    required String league,
    required String team1Logo,
    required String team2Logo,
    required String gameDate,
    required String gameTime,
    required String gameLocation,
  }) async {
    try {
      final games = await remoteDataSource.makeGames(
        team1: team1,
        team2: team2,
        league: league,
        team1Logo: team1Logo,
        team2Logo: team2Logo,
        gameDate: gameDate,
        gameTime: gameTime,
        gameLocation: gameLocation,
      );
      return right(games);
    } on ServerException catch (e) {
      return left(Failure(e.message));
    } catch (e) {
      return left(Failure(e.toString()));
    }
  }
} 