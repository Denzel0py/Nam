import 'package:fpdart/fpdart.dart';
import 'package:namhockey/core/common/entities/user_entity.dart';
import 'package:namhockey/core/error/failure.dart';
import 'package:namhockey/core/usecase/use_case.dart';
import 'package:namhockey/features/auth/domain/repository/auth_repository.dart';

class MakeRegularUserUseCase implements UseCase<UserEntity, MakeRegularUserParams> {
  final AuthRepository authRepository;

  MakeRegularUserUseCase({required this.authRepository});

  @override
  Future<Either<Failure, UserEntity>> call(MakeRegularUserParams params) async {
    return await authRepository.makeRegularUser(
      userId: params.userId,
    );
  }
}

class MakeRegularUserParams {
  final String userId;

  MakeRegularUserParams({
    required this.userId,
  });
} 