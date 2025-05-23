
import 'package:fpdart/fpdart.dart';
import 'package:namhockey/core/common/entities/user_entity.dart';
import 'package:namhockey/core/error/failure.dart';
import 'package:namhockey/core/usecase/use_case.dart';
import 'package:namhockey/features/auth/domain/repository/auth_repository.dart';

class GetCurrentUserDetailsUseCase implements UseCase<UserEntity, NoParams>{
  final AuthRepository authRepository;

  GetCurrentUserDetailsUseCase({required this.authRepository});

  @override
  Future<Either<Failure, UserEntity>> call(NoParams params) async {
    return await authRepository.getCurrentUser();
  }
  
}