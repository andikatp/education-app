import 'package:http/http.dart' as http;
import 'package:teacher/core/enums/update_user.dart';
import 'package:teacher/features/auth/domain/entities/user_entity.dart';

abstract class AuthRemoteDataSource {
  Future<void> forgotPassword({required String email});
  Future<LocalUser> signIn({
    required String email,
    required String password,
  });
  Future<void> signUp({
    required String email,
    required String fullName,
    required String password,
  });
  Future<void> updateUser({
    required UpdateUserAction action,
    required dynamic userData,
  });
}

class AuthRemoteDataSourceImpl implements AuthRemoteDataSource {
  AuthRemoteDataSourceImpl({required http.Client client}) : _client = client;
  final http.Client _client;
  @override
  Future<void> forgotPassword({required String email}) {
    // TODO: implement forgotPassword
    throw UnimplementedError();
  }

  @override
  Future<LocalUser> signIn({required String email, required String password}) {
    // TODO: implement signIn
    throw UnimplementedError();
  }

  @override
  Future<void> signUp({
    required String email,
    required String fullName,
    required String password,
  }) {
    // TODO: implement signUp
    throw UnimplementedError();
  }

  @override
  Future<void> updateUser(
      {required UpdateUserAction action, required dynamic userData,}) {
    // TODO: implement updateUser
    throw UnimplementedError();
  }
}
