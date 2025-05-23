
import 'package:fpdart/fpdart.dart';
import 'package:namhockey/core/common/entities/user_entity.dart';
import 'package:namhockey/core/error/failure.dart';
import 'package:namhockey/core/usecase/use_case.dart';
import 'package:namhockey/features/auth/domain/repository/auth_repository.dart';

class LogInUseCase implements UseCase<UserEntity, LogInParams> {
  final AuthRepository authRepository;

  LogInUseCase({required this.authRepository});

  @override
  Future<Either<Failure, UserEntity>> call(LogInParams params) async {
    return await authRepository.signInWithEmailAndPassword(
      email: params.email,
      password: params.password,
    );
  }
}

class LogInParams {
  final String email;
  final String password;

  LogInParams({
    required this.email,
    required this.password,
  });
}
