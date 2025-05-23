import 'package:fpdart/fpdart.dart';
import 'package:namhockey/core/common/entities/user_entity.dart';
import 'package:namhockey/core/error/failure.dart';
import 'package:namhockey/core/usecase/use_case.dart';
import 'package:namhockey/features/auth/domain/repository/auth_repository.dart';

class GetAllUsersUseCase implements UseCase<List<UserEntity>, NoParams> {
  final AuthRepository authRepository;

  GetAllUsersUseCase({required this.authRepository});

  @override
  Future<Either<Failure, List<UserEntity>>> call(NoParams params) async {
    return await authRepository.getAllUsers();
  }
} 