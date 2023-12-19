import 'package:dartz/dartz.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mocktail/mocktail.dart';
import 'package:teacher/core/errors/failures.dart';
import 'package:teacher/features/on_boarding/domain/repositories/on_boarding_repository.dart';
import 'package:teacher/features/on_boarding/domain/usecases/cache_first_timer.dart';
import 'on_boarding_repository.mock.dart';

void main() {
  late OnBoardingRepository mockRepository;
  late CacheFirstTimer usecase;

  setUp(() {
    mockRepository = MockOnBoardingRepository();
    usecase = CacheFirstTimer(repository: mockRepository);
  });

  group('cahceFirstTimerUseCase', () {
    final tServerFailure =
        ServerFailure(message: 'An Error Occured', statusCode: 400);
    test(
        'Should call [OnBoardingRepository.cacheFirstTimer] '
        'and return a right data', () async {
      // arrange
      when(() => mockRepository.cacheFirstTimer())
          .thenAnswer((_) async => const Right(null));
      // act
      final result = await usecase();
      // assert
      expect(result, equals(const Right<dynamic, void>(null)));
      verify(() => mockRepository.cacheFirstTimer());
      verifyNoMoreInteractions(mockRepository);
    });

    test(
        'Should call [OnBoardingRepository.cacheFirstTimer] '
        'and return a failure', () async {
      // arrange
      when(() => mockRepository.cacheFirstTimer())
          .thenAnswer((_) async => Left(tServerFailure));
      // act
      final result = await usecase();
      // assert
      expect(result, equals(Left<Failure, dynamic>(tServerFailure)));
      verify(() => mockRepository.cacheFirstTimer());
      verifyNoMoreInteractions(mockRepository);
    });
  });
}
