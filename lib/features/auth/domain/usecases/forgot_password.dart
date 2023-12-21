import 'package:teacher/core/usecase/usecase.dart';
import 'package:teacher/core/utils/typedef.dart';

class ForgotPassword implements UseCaseWithParams<void, String> {
  @override
  ResultFuture<void> call(String email) {
    throw UnimplementedError();
  }
}
