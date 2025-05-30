import 'package:fpdart/fpdart.dart';
import 'package:namhockey/core/common/entities/user_entity.dart';
import 'package:namhockey/core/error/failure.dart';

abstract interface class AuthRepository {
  Future<Either<Failure, UserEntity>> signUpWithEmailAndPassword({
    required String email,
    required String password,
    required String name,
    required String role,
  });
  Future<Either<Failure, UserEntity>> signInWithEmailAndPassword({
    required String email,
    required String password,
  });
  Future<Either<Failure, void>> signOut();
  Future<Either<Failure, UserEntity>> getCurrentUser();

  Future<Either<Failure, List<UserEntity>>> getAllUsers();
  Future<Either<Failure, UserEntity>> makeCoach({
    required String userId,
    required String teamName,
    required String teamLogoPath,
  });
  Future<Either<Failure, UserEntity>> makePlayer({
    required String userId,
    required String teamId,
  });
  Future<Either<Failure, UserEntity>> makeRegularUser({required String userId});

  Future<Either<Failure, UserEntity>> updateProfile({
    String? name,
    String? email,
    String? profilePicturePath,
  });
}
