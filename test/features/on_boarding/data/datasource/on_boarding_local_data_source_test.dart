import 'package:flutter_test/flutter_test.dart';
import 'package:mocktail/mocktail.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:teacher/core/errors/exceptions.dart';
import 'package:teacher/features/on_boarding/data/datasource/on_boarding_local_data_source.dart';

class MockSharedPreferences extends Mock implements SharedPreferences {}

void main() {
  late SharedPreferences mocksharedPreferences;
  late OnBoardingLocalDataSourceImpl localData;

  setUp(() {
    mocksharedPreferences = MockSharedPreferences();
    localData =
        OnBoardingLocalDataSourceImpl(sharedPreference: mocksharedPreferences);
  });

  group('cacheFirstTimer', () {
    test('Should call the [SharedPreferences] to cache the data', () async {
      // arrange
      when(
        () => mocksharedPreferences.setBool(any(), any()),
      ).thenAnswer((_) async => true);
      // act
      await localData.cacheFirstTimer();
      // assert
      verify(() => mocksharedPreferences.setBool(kFirstTimerKey, false))
          .called(1);
      verifyNoMoreInteractions(mocksharedPreferences);
    });

    test('Should throw a [CacheException] when theres an error', () async {
      // arrange
      when(
        () => mocksharedPreferences.setBool(any(), any()),
      ).thenThrow(Exception());
      // act
      final result = localData.cacheFirstTimer;
      // assert
      expect(result, throwsA(const TypeMatcher<CacheException>()));
      verify(() => mocksharedPreferences.setBool(kFirstTimerKey, false))
          .called(1);
      verifyNoMoreInteractions(mocksharedPreferences);
    });
  });

  group('isUserIsFirstTimer', () {
    test('Should call the [SharedPreferences] to get the data', () async {
      // arrange
      when(() => mocksharedPreferences.getBool(kFirstTimerKey))
          .thenAnswer((_) => true);
      // act
      final result = await localData.isUserIsFirstTimer();
      // assert
      expect(result, equals(true));
      verify(() => mocksharedPreferences.getBool(kFirstTimerKey)).called(1);
      verifyNoMoreInteractions(mocksharedPreferences);
    });

    test('Should throw a [CacheException] when theres an error', () async {
      // arrange
      when(() => mocksharedPreferences.getBool(any()))
          .thenThrow(Exception());
      // act
      final result = localData.isUserIsFirstTimer;
      // assert
      expect(result, throwsA(const TypeMatcher<CacheException>()));
      verify(() => mocksharedPreferences.getBool(kFirstTimerKey)).called(1);
      verifyNoMoreInteractions(mocksharedPreferences);
    });
  });
}
