import 'package:equatable/equatable.dart';
import 'package:teacher/core/usecase/usecase.dart';
import 'package:teacher/core/utils/typedef.dart';
import 'package:teacher/features/auth/domain/entities/user_entity.dart';

class SignIn implements UseCaseWithParams<LocalUser, SignInParams> {
  @override
  ResultFuture<LocalUser> call(SignInParams params) {
    // TODO: implement call
    throw UnimplementedError();
  }
}

class SignInParams extends Equatable {
  const SignInParams({required this.email, required this.password});

  final String email;
  final String password;

  @override
  List<String?> get props => [email, password];
}
