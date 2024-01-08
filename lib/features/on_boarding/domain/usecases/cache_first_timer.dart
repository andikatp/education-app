import 'package:teacher/core/usecase/usecase.dart';
import 'package:teacher/core/utils/typedef.dart';
import 'package:teacher/features/on_boarding/domain/repositories/on_boarding_repository.dart';

class CacheFirstTimer implements UseCaseWithoutParams<void> {
  const CacheFirstTimer({required OnBoardingRepository repository})
      : _repository = repository;
  final OnBoardingRepository _repository;
  @override
  ResultFuture<void> call() => _repository.cacheFirstTimer();
}
