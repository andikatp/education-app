import 'package:dartz/dartz.dart';
import 'package:teacher/core/enums/update_user.dart';
import 'package:teacher/core/errors/exceptions.dart';
import 'package:teacher/core/errors/failures.dart';
import 'package:teacher/core/utils/typedef.dart';
import 'package:teacher/features/auth/data/datasource/remote/auth_remote_data_source.dart';
import 'package:teacher/features/auth/domain/entities/user_entity.dart';
import 'package:teacher/features/auth/domain/repository/auth_repository.dart';

class AuthRepositoryImpl implements AuthRepository {
  const AuthRepositoryImpl({required AuthRemoteDataSource remote})
      : _remoteDataSource = remote;
  final AuthRemoteDataSource _remoteDataSource;

  @override
  ResultFuture<void> forgotPassword({required String email}) async {
    try {
      await _remoteDataSource.forgotPassword(email: email);
      return const Right(null);
    } on ServerException catch (e) {
      return Left(ServerFailure.fromException(e));
    }
  }

  @override
  ResultFuture<LocalUser> signIn({
    required String email,
    required String password,
  }) async {
    try {
      final result =
          await _remoteDataSource.signIn(email: email, password: password);
      return Right(result);
    } on ServerException catch (e) {
      return Left(ServerFailure.fromException(e));
    }
  }

  @override
  ResultFuture<void> signUp({
    required String email,
    required String fullName,
    required String password,
  }) async {
    try {
      final result = await _remoteDataSource.signUp(
        email: email,
        fullName: fullName,
        password: password,
      );
      return Right(result);
    } on ServerException catch (e) {
      return Left(ServerFailure.fromException(e));
    }
  }

  @override
  ResultFuture<void> updateUser({
    required UpdateUserAction action,
    dynamic userData,
  }) async {
    try {
      final result = await _remoteDataSource.updateUser(
        action: action,
        userData: userData,
      );
      return Right(result);
    } on ServerException catch (e) {
      return Left(ServerFailure.fromException(e));
    }
  }
}
