import 'package:fpdart/fpdart.dart';
import 'package:namhockey/core/common/entities/user_entity.dart';
import 'package:namhockey/core/error/failure.dart';
import 'package:namhockey/core/usecase/use_case.dart';
import 'package:namhockey/features/auth/domain/repository/auth_repository.dart';

class SignUpUseCase implements UseCase<UserEntity, SignUpParams> {
  final AuthRepository authRepository;

  SignUpUseCase({required this.authRepository});

  @override
  Future<Either<Failure, UserEntity>> call(SignUpParams params) async {
    return await authRepository.signUpWithEmailAndPassword(
      name: params.name,
      email: params.email,
      password: params.password,
      role: params.role,
    );
  }
}

class SignUpParams {
  final String name;
  final String email;
  final String password;
  final String role;

  SignUpParams({
    required this.name,
    required this.email,
    required this.password,
    required this.role,
  });
}
