import 'package:fpdart/fpdart.dart';
import 'package:namhockey/core/common/entities/user_entity.dart';
import 'package:namhockey/core/error/failure.dart';
import 'package:namhockey/core/usecase/use_case.dart';
import 'package:namhockey/features/auth/domain/repository/auth_repository.dart';

class UpdateProfileUseCase implements UseCase<UserEntity, UpdateProfileParams> {
  final AuthRepository authRepository;

  UpdateProfileUseCase({required this.authRepository});

  @override
  Future<Either<Failure, UserEntity>> call(UpdateProfileParams params) async {
    return await authRepository.updateProfile(
      name: params.name,
      email: params.email,
      profilePicturePath: params.profilePicturePath,
    );
  }
}

class UpdateProfileParams {
  final String? name;
  final String? email;
  final String? profilePicturePath;

  UpdateProfileParams({this.name, this.email, this.profilePicturePath});
}
