import 'package:fpdart/fpdart.dart';
import 'package:namhockey/core/common/entities/user_entity.dart';
import 'package:namhockey/core/error/failure.dart';
import 'package:namhockey/core/usecase/use_case.dart';
import 'package:namhockey/features/auth/domain/repository/auth_repository.dart';

class MakeCoachUseCase implements UseCase<UserEntity, MakeCoachParams> {
  final AuthRepository authRepository;

  MakeCoachUseCase({required this.authRepository});

  @override
  Future<Either<Failure, UserEntity>> call(MakeCoachParams params) async {
    return await authRepository.makeCoach(
      userId: params.userId,
      teamName: params.teamName,
      teamLogoPath: params.teamLogoPath,
    );
  }
}

class MakeCoachParams {
  final String userId;
  final String teamName;
  final String teamLogoPath;

  MakeCoachParams({
    required this.userId,
    required this.teamName,
    required this.teamLogoPath,
  });
} 