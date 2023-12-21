import 'package:equatable/equatable.dart';
import 'package:teacher/core/usecase/usecase.dart';
import 'package:teacher/core/utils/typedef.dart';

class SignUp implements UseCaseWithParams<void, SignUpParams> {
  @override
  ResultFuture<void> call(SignUpParams params) {
    // TODO: implement call
    throw UnimplementedError();
  }
}

class SignUpParams extends Equatable {
  const SignUpParams(
      {required this.email, required this.password, required this.fullName,});

  final String email;
  final String password;
  final String fullName;

  @override
  List<String?> get props => [email, password, fullName];
}
