import 'package:teacher/core/usecase/usecase.dart';
import 'package:teacher/core/utils/typedef.dart';
import 'package:teacher/features/auth/domain/repository/auth_repository.dart';

class ForgotPassword implements UseCaseWithParams<void, String> {
  const ForgotPassword({required AuthRepository repository})
      : _repository = repository;

  final AuthRepository _repository;

  @override
  ResultFuture<void> call(String email) =>
      _repository.forgotPassword(email: email);
}
