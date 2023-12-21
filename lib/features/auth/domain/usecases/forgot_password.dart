import 'package:teacher/core/usecase/usecase.dart';
import 'package:teacher/core/utils/typedef.dart';
import 'package:teacher/features/auth/domain/repository/auth_repository.dart';

class ForgotPassword implements UseCaseWithParams<void, String> {
  ForgotPassword({required AuthRepository repository})
      : _repository = repository;

  final AuthRepository _repository;

  @override
  ResultFuture<void> call(String email) async {
    return _repository.forgotPassword(email: email);
  }
}
