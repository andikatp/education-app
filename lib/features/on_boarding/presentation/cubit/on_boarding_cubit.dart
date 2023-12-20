import 'package:equatable/equatable.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:teacher/features/on_boarding/domain/usecases/cache_first_timer.dart';
import 'package:teacher/features/on_boarding/domain/usecases/is_user_is_first_timer.dart';

part 'on_boarding_state.dart';

class OnBoardingCubit extends Cubit<OnBoardingState> {
  OnBoardingCubit({
    required CacheFirstTimer cacheFirstTimer,
    required IsUserIsFirstTimer isUserFirstTimer,
  })  : _cacheFirstTimer = cacheFirstTimer,
        _isUserFirstTimer = isUserFirstTimer,
        super(const OnBoardingInitial());

  final CacheFirstTimer _cacheFirstTimer;
  final IsUserIsFirstTimer _isUserFirstTimer;

  Future<void> cacheFirstTimer() async {
    emit(const CachingFirstTimer());
    final result = await _cacheFirstTimer();
    result.fold(
      (failure) => emit(OnBoardingError(message: failure.errorMessage)),
      (_) => emit(const UserCached()),
    );
  }

  Future<void> isUserFirstTimer() async {
    emit(const CheckingIfUserIsFirstTimer());
    final result = await _isUserFirstTimer();
    result.fold(
      (failure) => emit(OnBoardingError(message: failure.errorMessage)),
      (value) => emit(
        OnBoardingStatus(isFirstTimer: value),
      ),
    );
  }
}
