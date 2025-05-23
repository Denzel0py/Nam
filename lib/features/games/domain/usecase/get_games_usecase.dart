import 'package:fpdart/fpdart.dart';
import 'package:namhockey/core/error/failure.dart';
import 'package:namhockey/core/usecase/use_case.dart';
import 'package:namhockey/features/games/domain/entity/game_entity.dart';
import 'package:namhockey/features/games/domain/repository/game_repository.dart';

class GetGamesUseCase implements UseCase<List<GameEntity>, NoParams> {
  final GameRepository gameRepository;

  GetGamesUseCase({required this.gameRepository});

  @override
  Future<Either<Failure, List<GameEntity>>> call(NoParams params) async {
    return await gameRepository.getGames();
  }
}
