import 'package:dartz/dartz.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mocktail/mocktail.dart';
import 'package:teacher/core/enums/update_user.dart';
import 'package:teacher/core/errors/exceptions.dart';
import 'package:teacher/core/errors/failures.dart';
import 'package:teacher/features/auth/data/datasource/remote/auth_remote_data_source.dart';
import 'package:teacher/features/auth/data/models/local_user_model.dart';
import 'package:teacher/features/auth/data/repositories/auth_repository_impl.dart';

class MockAuthRemoteDataSourceImpl extends Mock
    implements AuthRemoteDataSourceImpl {}

void main() {
  late AuthRemoteDataSourceImpl mockRemote;
  late AuthRepositoryImpl repository;

  setUp(() {
    mockRemote = MockAuthRemoteDataSourceImpl();
    repository = AuthRepositoryImpl(remote: mockRemote);
    registerFallbackValue(UpdateUserAction.displayName);
  });

  const tException = ServerException(message: 'message', statusCode: '400');
  const tUser = LocalUserModel.empty();
  const tUserPassword = 'test';

  group('forgotPassword', () {
    test('Should call [AuthRemoteDataSource.forgotPassword]', () async {
      // arrange
      when(
        () => mockRemote.forgotPassword(
          email: any(named: 'email'),
        ),
      ).thenAnswer(
        (_) async => Future.value(),
      );
      // act
      final result = await repository.forgotPassword(email: tUser.email);
      // assert
      expect(result, equals(const Right<dynamic, void>(null)));
      verify(() => mockRemote.forgotPassword(email: tUser.email));
      verifyNoMoreInteractions(mockRemote);
    });
    test(
        'Should throw [ServerException] when '
        'call to [AuthRemoteDataSource.forgotPassword] is unsuccessful',
        () async {
      // arrange
      when(
        () => mockRemote.forgotPassword(
          email: any(named: 'email'),
        ),
      ).thenThrow(tException);
      // act
      final result = await repository.forgotPassword(email: tUser.email);
      // assert
      expect(
        result,
        equals(
          Left<Failure, dynamic>(
            ServerFailure(
              message: tException.message,
              statusCode: tException.statusCode,
            ),
          ),
        ),
      );
      verify(() => mockRemote.forgotPassword(email: tUser.email));
      verifyNoMoreInteractions(mockRemote);
    });
  });

  group('signIn', () {
    test('Should call [AuthRemoteDataSource.login]', () async {
      // arrange
      when(
        () => mockRemote.signIn(
          email: any(named: 'email'),
          password: any(named: 'password'),
        ),
      ).thenAnswer((_) async => tUser);
      // act
      final result = await repository.signIn(
        email: tUser.email,
        password: tUserPassword,
      );
      // assert
      expect(result, equals(const Right<dynamic, LocalUserModel>(tUser)));
      verify(
        () => mockRemote.signIn(email: tUser.email, password: tUserPassword),
      );
      verifyNoMoreInteractions(mockRemote);
    });

    test(
        'Should throw [ServerFailure] when '
        'call to [AuthRemoteDataSource.login] failed', () async {
      // arrange
      when(
        () => mockRemote.signIn(
          email: any(named: 'email'),
          password: any(named: 'password'),
        ),
      ).thenThrow(tException);
      // act
      final result = await repository.signIn(
        email: tUser.email,
        password: tUserPassword,
      );
      // assert
      expect(
        result,
        equals(
          Left<Failure, dynamic>(
            ServerFailure(
              message: tException.message,
              statusCode: tException.statusCode,
            ),
          ),
        ),
      );
      verify(
        () => mockRemote.signIn(email: tUser.email, password: tUserPassword),
      );
      verifyNoMoreInteractions(mockRemote);
    });
  });

  group('signUp', () {
    test('Should call [AuthRemoteDataSource.signUp]', () async {
      // arrange
      when(
        () => mockRemote.signUp(
          email: any(named: 'email'),
          fullName: any(named: 'fullName'),
          password: any(named: 'password'),
        ),
      ).thenAnswer((_) async => Future.value());
      // act
      final result = await repository.signUp(
        email: tUser.email,
        fullName: tUser.fullName,
        password: tUserPassword,
      );
      // assert
      expect(result, equals(const Right<dynamic, void>(null)));
      verify(
        () => mockRemote.signUp(
          email: tUser.email,
          fullName: tUser.fullName,
          password: tUserPassword,
        ),
      );
      verifyNoMoreInteractions(mockRemote);
    });

    test(
        'Should throw [ServerFailure] when '
        'call to [AuthRemoteDataSource.signUp] if unsuccessful', () async {
      // arrange
      when(
        () => mockRemote.signUp(
          email: any(named: 'email'),
          fullName: any(named: 'fullName'),
          password: any(named: 'password'),
        ),
      ).thenThrow(tException);
      // act
      final result = await repository.signUp(
        email: tUser.email,
        fullName: tUser.fullName,
        password: tUserPassword,
      );
      // assert
      expect(
        result,
        equals(
          Left<Failure, dynamic>(
            ServerFailure(
              message: tException.message,
              statusCode: tException.statusCode,
            ),
          ),
        ),
      );
      verify(
        () => mockRemote.signUp(
          email: tUser.email,
          fullName: tUser.fullName,
          password: tUserPassword,
        ),
      );
      verifyNoMoreInteractions(mockRemote);
    });
  });

  group('updateUser', () {
    test('Should call [AuthRemoteDataSource.updateUser]', () async {
      // arrange
      when(
        () => mockRemote.updateUser(
          action: any(named: 'action'),
          userData: any<dynamic>(named: 'userData'),
        ),
      ).thenAnswer((_) => Future.value());
      // act
      final result = await repository.updateUser(
        action: UpdateUserAction.displayName,
        userData: tUser.fullName,
      );
      // assert
      expect(result, const Right<dynamic, void>(null));
      verify(
        () => mockRemote.updateUser(
          action: UpdateUserAction.displayName,
          userData: tUser.fullName,
        ),
      );
      verifyNoMoreInteractions(mockRemote);
    });

    test(
        'Should throw [ServerException] when '
        'call to [AuthRemoteDataSource.updateUser] failed', () async {
      // arrange
      when(
        () => mockRemote.updateUser(
          action: any(named: 'action'),
          userData: any<dynamic>(named: 'userData'),
        ),
      ).thenThrow(tException);
      // act
      final result = await repository.updateUser(
        action: UpdateUserAction.displayName,
        userData: tUser.fullName,
      );
      // assert
      expect(
        result,
        Left<Failure, dynamic>(
          ServerFailure(
            message: tException.message,
            statusCode: tException.statusCode,
          ),
        ),
      );
      verify(
        () => mockRemote.updateUser(
          action: UpdateUserAction.displayName,
          userData: tUser.fullName,
        ),
      );
      verifyNoMoreInteractions(mockRemote);
    });
  });
}
