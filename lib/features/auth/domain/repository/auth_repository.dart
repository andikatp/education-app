import 'package:teacher/core/enums/update_user.dart';
import 'package:teacher/core/utils/typedef.dart';
import 'package:teacher/features/auth/domain/entities/user_entity.dart';

abstract class AuthRepository {
  const AuthRepository();

  ResultFuture<void> forgotPassword({required String email});

  ResultFuture<LocalUser> signIn({
    required String email,
    required String password,
  });
  ResultFuture<void> signUp({
    required String email,
    required String fullName,
    required String password,
  });
  ResultFuture<void> updateUser({
    required UpdateUserAction action,
    dynamic userData,
  });
}
