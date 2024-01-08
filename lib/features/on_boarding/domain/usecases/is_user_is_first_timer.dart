import 'package:teacher/core/usecase/usecase.dart';
import 'package:teacher/core/utils/typedef.dart';
import 'package:teacher/features/on_boarding/domain/repositories/on_boarding_repository.dart';

class IsUserIsFirstTimer implements UseCaseWithoutParams<bool> {
  const IsUserIsFirstTimer({required OnBoardingRepository repository})
      : _repository = repository;
  final OnBoardingRepository _repository;

  @override
  ResultFuture<bool> call() => _repository.isUserIsFirstTimer();
}
