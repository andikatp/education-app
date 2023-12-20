import 'package:dartz/dartz.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mocktail/mocktail.dart';
import 'package:teacher/core/errors/exceptions.dart';
import 'package:teacher/core/errors/failures.dart';
import 'package:teacher/features/on_boarding/data/datasource/on_boarding_local_data_source.dart';
import 'package:teacher/features/on_boarding/data/repositories/on_boarding_repository_impl.dart';
import 'package:teacher/features/on_boarding/domain/repositories/on_boarding_repository.dart';

class MockOnBoardingLocalDataSource extends Mock
    implements OnBoardingLocalDataSource {}

void main() {
  late OnBoardingLocalDataSource mockDataSource;
  late OnBoardingRepositoryImpl repository;

  setUp(() {
    mockDataSource = MockOnBoardingLocalDataSource();
    repository = OnBoardingRepositoryImpl(localDataSource: mockDataSource);
  });

  const tCacheException = CacheException(message: 'Unknown Error');

  test('Should be a subclass of [OnBoardingRepository]', () async {
    // assert
    expect(repository, isA<OnBoardingRepository>());
  });

  group('cacheFirstTimer', () {
    test('Should complete successfully when call to local source is successful',
        () async {
      // arrange
      when(() => mockDataSource.cacheFirstTimer())
          .thenAnswer((_) async => Future.value());
      // act
      final result = await repository.cacheFirstTimer();
      // assert
      expect(result, equals(const Right<dynamic, void>(null)));
      verify(() => mockDataSource.cacheFirstTimer());
      verifyNoMoreInteractions(mockDataSource);
    });

    test(
        'Should return a [CacheFailure] '
        'when call to local source is unsuccessful', () async {
      // arrange
      when(() => mockDataSource.cacheFirstTimer()).thenThrow(tCacheException);
      // act
      final result = await repository.cacheFirstTimer();
      // assert
      expect(
        result,
        equals(
          Left<Failure, dynamic>(
            CacheFailure(message: 'Unknown Error', statusCode: 500),
          ),
        ),
      );
      verify(() => mockDataSource.cacheFirstTimer());
      verifyNoMoreInteractions(mockDataSource);
    });
  });

  group('isUserIsFirstTimer', () {
    test('Should return true when call to local source is successful',
        () async {
      // arrange
      when(() => mockDataSource.isUserIsFirstTimer())
          .thenAnswer((_) async => true);
      // act
      final result = await repository.isUserIsFirstTimer();
      // assert
      expect(result, equals(const Right<dynamic, bool>(true)));
      verify(() => mockDataSource.isUserIsFirstTimer());
      verifyNoMoreInteractions(mockDataSource);
    });

    test(
        'Should return a [CacheFailure] '
        'when call to local source is unsuccessful', () async {
      // arrange
      when(() => mockDataSource.isUserIsFirstTimer())
          .thenThrow(tCacheException);
      // act
      final result = await repository.isUserIsFirstTimer();
      // assert
      expect(
        result,
        equals(
          Left<Failure, dynamic>(
            CacheFailure(message: 'Unknown Error', statusCode: 500),
          ),
        ),
      );
      verify(() => mockDataSource.isUserIsFirstTimer());
      verifyNoMoreInteractions(mockDataSource);
    });
  });
}
