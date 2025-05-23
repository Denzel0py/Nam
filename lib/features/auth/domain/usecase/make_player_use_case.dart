import 'package:fpdart/fpdart.dart';
import 'package:namhockey/core/common/entities/user_entity.dart';
import 'package:namhockey/core/error/failure.dart';
import 'package:namhockey/core/usecase/use_case.dart';
import 'package:namhockey/features/auth/domain/repository/auth_repository.dart';

class MakePlayerUseCase implements UseCase<UserEntity, MakePlayerParams> {
  final AuthRepository authRepository;

  MakePlayerUseCase({required this.authRepository});

  @override
  Future<Either<Failure, UserEntity>> call(MakePlayerParams params) async {
    return await authRepository.makePlayer(
      userId: params.userId,
      teamId: params.teamId,
    );
  }
}

class MakePlayerParams {
  final String userId;
  final String teamId;

  MakePlayerParams({
    required this.userId,
    required this.teamId,
  });
} 