import 'package:dartz/dartz.dart';
import 'package:teacher/core/errors/exceptions.dart';
import 'package:teacher/core/errors/failures.dart';
import 'package:teacher/core/utils/typedef.dart';
import 'package:teacher/features/on_boarding/data/datasource/on_boarding_local_data_source.dart';
import 'package:teacher/features/on_boarding/domain/repositories/on_boarding_repository.dart';

class OnBoardingRepositoryImpl implements OnBoardingRepository {
  const OnBoardingRepositoryImpl({
    required OnBoardingLocalDataSource localDataSource,
  }) : _localDataSource = localDataSource;
  final OnBoardingLocalDataSource _localDataSource;
  @override
  ResultFuture<void> cacheFirstTimer() async {
    try {
      await _localDataSource.cacheFirstTimer();
    } on CacheException catch (e) {
      return Left(CacheFailure.fromException(e));
    }
    return const Right(null);
  }

  @override
  ResultFuture<bool> isUserIsFirstTimer() async {
    try {
      final result = await _localDataSource.isUserIsFirstTimer();
      return Right(result);
    } on CacheException catch (e) {
      return Left(CacheFailure.fromException(e));
    }
  }
}
