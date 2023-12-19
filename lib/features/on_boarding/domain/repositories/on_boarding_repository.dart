import 'package:teacher/core/utils/typedef.dart';

abstract class OnBoardingRepository {
  const OnBoardingRepository();
  ResultFuture<void> cacheFirstTimer();
  ResultFuture<bool> isUserIsFirstTimer();
}
