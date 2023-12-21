import 'package:dartz/dartz.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mocktail/mocktail.dart';
import 'package:teacher/core/enums/update_user.dart';
import 'package:teacher/core/errors/failures.dart';
import 'package:teacher/features/auth/domain/repository/auth_repository.dart';
import 'package:teacher/features/auth/domain/usecases/update_user.dart';

import 'auth_repository.mock.dart';

void main() {
  late AuthRepository mockRepository;
  late UpdateUser useCase;

  setUp(() {
    mockRepository = MockAuthRepository();
    useCase = UpdateUser(repository: mockRepository);
    registerFallbackValue(UpdateUserAction.displayName);
  });

  group('signIn', () {
    final tServerFailure = ServerFailure(message: 'message', statusCode: 400);
    const tParams = UpdateUserParams(
      action: UpdateUserAction.displayName,
      userData: 'test',
    );

    test(
        'Should call [AuthRepository.updateUser] '
        'and return a right data', () async {
      // arrange
      when(
        () => mockRepository.updateUser(
          action: any(
            named: 'action',
          ),
          userData: any<dynamic>(named: 'userData'),
        ),
      ).thenAnswer((_) async => const Right(null));
      // act
      final result = await useCase(tParams);
      // assert
      expect(result, equals(const Right<dynamic, void>(null)));
      verify(
        () => mockRepository.updateUser(
          action: tParams.action,
          userData: tParams.userData,
        ),
      );
      verifyNoMoreInteractions(mockRepository);
    });

    test(
        'Should call [AuthRepository.updateUser] '
        'and return [ServerFailure]', () async {
      // arrange
      when(
        () => mockRepository.updateUser(
          action: any(named: 'action'),
          userData: any<dynamic>(named: 'userData'),
        ),
      ).thenAnswer((_) async => Left(tServerFailure));
      // act
      final result = await useCase(tParams);
      // assert
      expect(result, equals(Left<Failure, dynamic>(tServerFailure)));
      verify(
        () => mockRepository.updateUser(
          action: tParams.action,
          userData: tParams.userData,
        ),
      );
      verifyNoMoreInteractions(mockRepository);
    });
  });
}
