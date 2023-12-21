import 'package:dartz/dartz.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mocktail/mocktail.dart';
import 'package:teacher/core/errors/failures.dart';
import 'package:teacher/features/auth/domain/repository/auth_repository.dart';
import 'package:teacher/features/auth/domain/usecases/sign_up.dart';

import 'auth_repository.mock.dart';

void main() {
  late AuthRepository mockRepository;
  late SignUp useCase;

  setUp(() {
    mockRepository = MockAuthRepository();
    useCase = SignUp(repository: mockRepository);
  });

  group('signIn', () {
    final tServerFailure = ServerFailure(message: 'message', statusCode: 400);
    const tParams = SignUpParams(
      email: 'email',
      password: 'password',
      fullName: 'fullName',
    );

    test(
        'Should call [AuthRepository.signUp] '
        'and return a right data', () async {
      // arrange
      when(
        () => mockRepository.signUp(
          fullName: any(named: 'fullName'),
          email: any(named: 'email'),
          password: any(named: 'password'),
        ),
      ).thenAnswer((_) async => const Right(null));
      // act
      final result = await useCase(tParams);
      // assert
      expect(result, equals(const Right<dynamic, void>(null)));
      verify(
        () => mockRepository.signUp(
          fullName: tParams.fullName,
          email: tParams.email,
          password: tParams.password,
        ),
      );
      verifyNoMoreInteractions(mockRepository);
    });

    test(
        'Should call [AuthRepository.signUp] '
        'and return [ServerFailure]', () async {
      // arrange
      when(
        () => mockRepository.signUp(
          fullName: any(named: 'fullName'),
          email: any(named: 'email'),
          password: any(named: 'password'),
        ),
      ).thenAnswer((_) async => Left(tServerFailure));
      // act
      final result = await useCase(tParams);
      // assert
      expect(result, equals(Left<Failure, dynamic>(tServerFailure)));
      verify(
        () => mockRepository.signUp(
          fullName: tParams.fullName,
          email: tParams.email,
          password: tParams.password,
        ),
      );
      verifyNoMoreInteractions(mockRepository);
    });
  });
}
