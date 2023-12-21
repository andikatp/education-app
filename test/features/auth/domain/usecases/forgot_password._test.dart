import 'package:dartz/dartz.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mocktail/mocktail.dart';
import 'package:teacher/core/errors/failures.dart';
import 'package:teacher/features/auth/domain/repository/auth_repository.dart';
import 'package:teacher/features/auth/domain/usecases/forgot_password.dart';
import 'auth_repository.mock.dart';



void main() {
  late AuthRepository mockRepository;
  late ForgotPassword useCase;

  setUp(() {
    mockRepository = MockAuthRepository();
    useCase = ForgotPassword(repository: mockRepository);
  });

  group('forgotPassword', () {
    const tEmail = 'test@test.com';
    final tServerFailure = ServerFailure(message: 'message', statusCode: 400);
    test(
        'Should call [AuthRepository.forgotPassword] '
        'and return a right data', () async {
      // arrange
      when(
        () => mockRepository.forgotPassword(email: any(named: 'email')),
      ).thenAnswer((_) async => const Right(null));
      // act
      final result = await useCase(tEmail);
      // assert
      expect(result, equals(const Right<dynamic, void>(null)));
      verify(
        () => mockRepository.forgotPassword(email: tEmail),
      );
      verifyNoMoreInteractions(mockRepository);
    });

    test(
        'Should call [AuthRepository.forgotPassword] '
        'and return [ServerFailure]', () async {
      // arrange
      when(() => mockRepository.forgotPassword(email: any(named: 'email')))
          .thenAnswer((_) async => Left(tServerFailure));
      // act
      final result = await useCase(tEmail);
      // assert
      expect(result, equals(Left<Failure, dynamic>(tServerFailure)));
      verify(
        () => mockRepository.forgotPassword(email: tEmail),
      );
      verifyNoMoreInteractions(mockRepository);
    });
  });
}
