import 'package:equatable/equatable.dart';
import 'package:teacher/core/usecase/usecase.dart';
import 'package:teacher/core/utils/typedef.dart';
import 'package:teacher/features/auth/domain/entities/user_entity.dart';
import 'package:teacher/features/auth/domain/repository/auth_repository.dart';

class SignIn implements UseCaseWithParams<LocalUser, SignInParams> {
  SignIn({required AuthRepository repository}) : _repository = repository;

  final AuthRepository _repository;

  @override
  ResultFuture<LocalUser> call(SignInParams params) async {
    return _repository.signIn(
      email: params.email,
      password: params.password,
    );
  }
}

class SignInParams extends Equatable {
  const SignInParams({required this.email, required this.password});

  final String email;
  final String password;

  @override
  List<String?> get props => [email, password];
}
