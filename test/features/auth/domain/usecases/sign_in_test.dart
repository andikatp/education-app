import 'package:dartz/dartz.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mocktail/mocktail.dart';
import 'package:teacher/core/errors/failures.dart';
import 'package:teacher/features/auth/domain/entities/user_entity.dart';
import 'package:teacher/features/auth/domain/repository/auth_repository.dart';
import 'package:teacher/features/auth/domain/usecases/sign_in.dart';

import 'auth_repository.mock.dart';

void main() {
  late AuthRepository mockRepository;
  late SignIn useCase;

  setUp(() {
    mockRepository = MockAuthRepository();
    useCase = SignIn(repository: mockRepository);
  });

  group('signIn', () {
    final tServerFailure = ServerFailure(message: 'message', statusCode: 400);
    const tParams = SignInParams(email: 'email', password: 'password');
    const tUser = LocalUser.empty();

    test(
        'Should call [AuthRepository.signIn] '
        'and return a right data', () async {
      // arrange
      when(
        () => mockRepository.signIn(
          email: any(named: 'email'),
          password: any(named: 'password'),
        ),
      ).thenAnswer((_) async => const Right(tUser));
      // act
      final result = await useCase(tParams);
      // assert
      expect(result, equals(const Right<dynamic, LocalUser>(tUser)));
      verify(
        () => mockRepository.signIn(
          email: tParams.email,
          password: tParams.password,
        ),
      );
      verifyNoMoreInteractions(mockRepository);
    });

    test(
        'Should call [AuthRepository.signIn] '
        'and return [ServerFailure]', () async {
      // arrange
      when(
        () => mockRepository.signIn(
          email: any(named: 'email'),
          password: any(named: 'password'),
        ),
      ).thenAnswer((_) async => Left(tServerFailure));
      // act
      final result = await useCase(tParams);
      // assert
      expect(result, equals(Left<Failure, dynamic>(tServerFailure)));
      verify(
        () => mockRepository.signIn(
          email: tParams.email,
          password: tParams.password,
        ),
      );
      verifyNoMoreInteractions(mockRepository);
    });
  });
}
