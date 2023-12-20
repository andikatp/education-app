import 'package:bloc_test/bloc_test.dart';
import 'package:dartz/dartz.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mocktail/mocktail.dart';
import 'package:teacher/core/errors/failures.dart';
import 'package:teacher/features/on_boarding/domain/usecases/cache_first_timer.dart';
import 'package:teacher/features/on_boarding/domain/usecases/is_user_is_first_timer.dart';
import 'package:teacher/features/on_boarding/presentation/cubit/on_boarding_cubit.dart';

class MockCacheFirstTimer extends Mock implements CacheFirstTimer {}

class MockIsUserIsFirstTimer extends Mock implements IsUserIsFirstTimer {}

void main() {
  late CacheFirstTimer mockCacheFirstTimer;
  late IsUserIsFirstTimer mockIsUserFirstTimer;
  late OnBoardingCubit cubit;

  setUp(() {
    mockCacheFirstTimer = MockCacheFirstTimer();
    mockIsUserFirstTimer = MockIsUserIsFirstTimer();
    cubit = OnBoardingCubit(
      cacheFirstTimer: mockCacheFirstTimer,
      isUserFirstTimer: mockIsUserFirstTimer,
    );
  });

  test('Should emits [OnBoardingInitial] on first running', () async {
    // assert
    expect(cubit.state, const OnBoardingInitial());
  });

  group('cacheFirstTimer', () {
    blocTest<OnBoardingCubit, OnBoardingState>(
      'emits [CachingFirstTimer, UserCached] '
      'when [mockCacheFirstTimer] running.',
      build: () {
        when(() => mockCacheFirstTimer())
            .thenAnswer((_) async => const Right(null));
        return cubit;
      },
      act: (_) => cubit.cacheFirstTimer(),
      expect: () => [const CachingFirstTimer(), const UserCached()],
    );

    blocTest<OnBoardingCubit, OnBoardingState>(
      'emits [CachingFirstTimer, OnBoardingError] '
      'when [OnBoardingError] failed.',
      build: () {
        when(() => mockCacheFirstTimer()).thenAnswer(
          (_) async => Left(
            CacheFailure(message: 'message', statusCode: 500),
          ),
        );
        return cubit;
      },
      act: (_) => cubit.cacheFirstTimer(),
      expect: () => [
        const CachingFirstTimer(),
        const OnBoardingError(message: 'statusCode Error: message'),
      ],
    );
  });

  group('isUserFirstTimer', () {
    blocTest<OnBoardingCubit, OnBoardingState>(
      'emits [CheckingIfUserIsFirstTimer, OnBoardingStatus] '
      'when [mockIsUserFirstTimer] running.',
      build: () {
        when(() => mockIsUserFirstTimer())
            .thenAnswer((_) async => const Right(true));
        return cubit;
      },
      act: (_) => cubit.isUserFirstTimer(),
      expect: () => [
        const CheckingIfUserIsFirstTimer(),
        const OnBoardingStatus(isFirstTimer: true),
      ],
    );

    blocTest<OnBoardingCubit, OnBoardingState>(
      'emits [CheckingIfUserIsFirstTimer, OnBoardingError] '
      'when [mockIsUserFirstTimer] failed.',
      build: () {
        when(() => mockIsUserFirstTimer()).thenAnswer((_) async =>
            Left(CacheFailure(message: 'message', statusCode: 500)),);
        return cubit;
      },
      act: (_) => cubit.isUserFirstTimer(),
      expect: () => [
        const CheckingIfUserIsFirstTimer(),
        const OnBoardingError(message: '500 Error: message'),
      ],
    );
  });
}
