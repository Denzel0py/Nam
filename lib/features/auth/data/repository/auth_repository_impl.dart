import 'package:fpdart/fpdart.dart';
import 'package:namhockey/core/common/entities/user_entity.dart';
import 'package:namhockey/core/error/failure.dart';
import 'package:namhockey/core/error/server_exeption.dart';
import 'package:namhockey/features/auth/data/datasources/auth_remote_data_source.dart';
import 'package:namhockey/features/auth/domain/repository/auth_repository.dart';

class AuthRepositoryImpl implements AuthRepository {
  final AuthRemoteDataSource authRemoteDataSource;
  AuthRepositoryImpl({required this.authRemoteDataSource});

  @override
  Future<Either<Failure, UserEntity>> getCurrentUser() async{
     try {
      final user = await authRemoteDataSource.getCurrentUser();

      if (user == null) {
        return left(Failure('User is not logged in!'));
      }

      return right(user);
      
    } on ServerException catch (e) {
      return left(Failure(e.message));
    }
  }

  @override
  Future<Either<Failure, UserEntity>> signInWithEmailAndPassword({required String email, required String password}) async {
    try {
      final user = await authRemoteDataSource.signInWithEmailAndPassword(email: email, password: password,);
      return right(user);
    } on ServerException catch (e) {
      return left(Failure(e.message));
    }
  }

  @override
  Future<Either<Failure, void>> signOut() async {
    try {
      await authRemoteDataSource.signOut();
      return right(null);
    } on ServerException catch (e) {
      return left(Failure(e.message));
    }
  }

  @override
  Future<Either<Failure, UserEntity>> signUpWithEmailAndPassword({required String email, required String password, required String name, required String role}) async {
    try {
      final user = await authRemoteDataSource.signUpWithEmailAndPassword(name: name, email: email, password: password, role: role);
      return right(user);
    } on ServerException catch (e) {
      return left(Failure(e.message));
    }
  }

  @override
  Future<Either<Failure, List<UserEntity>>> getAllUsers() async {
    try {
      final users = await authRemoteDataSource.getAllUsers();
      return right(users);
    } on ServerException catch (e) {
      return left(Failure(e.message));
    }
  }

  @override
  Future<Either<Failure, UserEntity>> makeCoach({
    required String userId,
    required String teamName,
    required String teamLogoPath,
  }) async {
    try {
      final updatedUser = await authRemoteDataSource.makeCoach(
        userId: userId,
        teamName: teamName,
        teamLogoPath: teamLogoPath,
      );
      return right(updatedUser);
    } on ServerException catch (e) {
      return left(Failure(e.message));
    }
  }

  @override
  Future<Either<Failure, UserEntity>> makePlayer({
    required String userId,
    required String teamId,
  }) async {
    try {
      final updatedUser = await authRemoteDataSource.makePlayer(
        userId: userId,
        teamId: teamId,
      );
      return right(updatedUser);
    } on ServerException catch (e) {
      return left(Failure(e.message));
    }
  }

  @override
  Future<Either<Failure, UserEntity>> makeRegularUser({
    required String userId,
  }) async {
    try {
      final updatedUser = await authRemoteDataSource.makeRegularUser(
        userId: userId,
      );
      return right(updatedUser);
    } on ServerException catch (e) {
      return left(Failure(e.message));
    }
  }
}
