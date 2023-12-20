import 'package:dartz/dartz.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mocktail/mocktail.dart';
import 'package:teacher/core/errors/failures.dart';
import 'package:teacher/features/on_boarding/domain/repositories/on_boarding_repository.dart';
import 'package:teacher/features/on_boarding/domain/usecases/is_user_is_first_timer.dart';

import 'on_boarding_repository.mock.dart';

void main() {
  late OnBoardingRepository mockRepository;
  late IsUserIsFirstTimer useCase;

  setUp(() {
    mockRepository = MockOnBoardingRepository();
    useCase = IsUserIsFirstTimer(repository: mockRepository);
  });

  group('isUserIsFirstTimer', () {
    final tServerFailure =
        ServerFailure(message: 'An Error Occured', statusCode: 404);
    test(
        'Should call the [OnBoardingRepository.isUserIsFirstTimer] '
        'and return the right data', () async {
      // arrange
      when(() => mockRepository.isUserIsFirstTimer())
          .thenAnswer((_) async => const Right(true));
      // act
      final result = await useCase();
      // assert
      expect(result, equals(const Right<dynamic, bool>(true)));
      verify(() => mockRepository.isUserIsFirstTimer());
      verifyNoMoreInteractions(mockRepository);
    });

    test(
        'Should call the [OnBoardingRepository.isUserIsFirstTimer] '
        'and return a failure', () async {
      // arrange
      when(() => mockRepository.isUserIsFirstTimer())
          .thenAnswer((_) async => Left(tServerFailure));
      // act
      final result = await useCase();
      // assert
      expect(result, equals(Left<Failure, dynamic>(tServerFailure)));
      verify(() => mockRepository.isUserIsFirstTimer());
      verifyNoMoreInteractions(mockRepository);
    });
  });
}
