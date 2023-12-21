import 'dart:convert';

import 'package:flutter_test/flutter_test.dart';
import 'package:teacher/core/utils/typedef.dart';
import 'package:teacher/features/auth/data/models/local_user_model.dart';
import 'package:teacher/features/auth/domain/entities/user_entity.dart';

import '../../../../fixture/fixture_reader.dart';

void main() {
  late LocalUserModel tLocalUserModel;

  setUp(() => tLocalUserModel = const LocalUserModel.empty());

  test('Should be a subclass of [LocalUser] entity', () async {
    // assert
    expect(tLocalUserModel, isA<LocalUser>());
  });

  final tMap = jsonDecode(fixtureReader('user.json')) as DataMap;
  group('fromMap', () {
    test('Should return a valid [LocalUserModel] from the map', () {
      // act
      final result = LocalUserModel.fromMap(tMap);
      // assert
      expect(result, equals(tLocalUserModel));
      expect(result, isA<LocalUserModel>());
    });

    test('Should throw an [Error] when the map is invalid', () {
      final map = DataMap.from(tMap)..remove('uid');
      const call = LocalUserModel.fromMap;
      expect(() => call(map), throwsA(isA<Error>()));
    });
  });
  group('toMap', () {
    test('Should return a valid [DataMap] from the model', () async {
      // act
      final result = tLocalUserModel.toMap();
      // assert
      expect(result, equals(tMap));
    });
  });

  group('copyWith', () {
    test('Should return a valid [LocalUserModel] with updated values',
        () async {
      // act
      final result = tLocalUserModel.copyWith(uid: '2');
      // assert
      expect(result.uid, '2');
    });
  });
}
