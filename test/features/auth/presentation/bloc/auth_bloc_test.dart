import 'package:bloc_test/bloc_test.dart';
import 'package:dartz/dartz.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mocktail/mocktail.dart';
import 'package:teacher/core/errors/failures.dart';
import 'package:teacher/features/auth/domain/entities/user_entity.dart';
import 'package:teacher/features/auth/domain/usecases/forgot_password.dart';
import 'package:teacher/features/auth/domain/usecases/sign_in.dart';
import 'package:teacher/features/auth/domain/usecases/sign_up.dart';
import 'package:teacher/features/auth/domain/usecases/update_user.dart';
import 'package:teacher/features/auth/presentation/bloc/auth_bloc.dart';

class MockSignIn extends Mock implements SignIn {}

class MockSignUp extends Mock implements SignUp {}

class MockForgotPassword extends Mock implements ForgotPassword {}

class MockUpdateUser extends Mock implements UpdateUser {}

void main() {
  late SignIn mockSignIn;
  late SignUp mockSignUp;
  late ForgotPassword mockForgotPassword;
  late UpdateUser mockUpdateUser;
  late AuthBloc authBloc;

  const tSignInParams = SignInParams.empty();
  const tSignUpParams = SignUpParams.empty();
  const tUpdateUserParams = UpdateUserParams.empty();

  setUp(() {
    mockSignIn = MockSignIn();
    mockSignUp = MockSignUp();
    mockForgotPassword = MockForgotPassword();
    mockUpdateUser = MockUpdateUser();
    authBloc = AuthBloc(
      signIn: mockSignIn,
      signUp: mockSignUp,
      forgotPassword: mockForgotPassword,
      updateUser: mockUpdateUser,
    );
  });

  setUpAll(() {
    registerFallbackValue(tSignInParams);
    registerFallbackValue(tSignUpParams);
    registerFallbackValue(tUpdateUserParams);
  });

  tearDown(() => authBloc.close());

  test('initial state should be [AuthInitial]', () async {
    // assert
    expect(authBloc.state, const AuthInitial());
  });

  group('SignIn', () {
    const tLocalUser = LocalUser.empty();
    final tServerFailure = ServerFailure(message: '', statusCode: '');
    blocTest<AuthBloc, AuthState>(
      'Should emit [AuthLoading, SignedIn] when '
      '[SignInEvent] is called',
      build: () {
        when(() => mockSignIn(any()))
            .thenAnswer((_) async => const Right(tLocalUser));
        return authBloc;
      },
      act: (bloc) => bloc.add(
        SignInEvent(
          email: tSignInParams.email,
          password: tSignInParams.password,
        ),
      ),
      expect: () => [const AuthLoading(), const SignedIn(tLocalUser)],
      verify: (_) {
        verify(() => mockSignIn(tSignInParams)).called(1);
        verifyNoMoreInteractions(mockSignIn);
      },
    );

    blocTest<AuthBloc, AuthState>(
      'Should emit [AuthLoading, AuthError] when '
      '[SignInEvent] failed',
      build: () {
        when(() => mockSignIn(any()))
            .thenAnswer((_) async => Left(tServerFailure));
        return authBloc;
      },
      act: (bloc) => bloc.add(
        SignInEvent(
          email: tSignInParams.email,
          password: tSignInParams.password,
        ),
      ),
      expect: () =>
          [const AuthLoading(), AuthError(tServerFailure.errorMessage)],
      verify: (_) {
        verify(() => mockSignIn(tSignInParams)).called(1);
        verifyNoMoreInteractions(mockSignIn);
      },
    );
  });

  group('SignUp', () {
    final tServerFailure = ServerFailure(message: '', statusCode: '');
    blocTest<AuthBloc, AuthState>(
      'Should emit [AuthLoading, SignUp] when '
      '[SignUpEvent] is called',
      build: () {
        when(() => mockSignUp(any()))
            .thenAnswer((_) async => const Right(null));
        return authBloc;
      },
      act: (bloc) => bloc.add(
        SignUpEvent(
          email: tSignUpParams.email,
          password: tSignUpParams.password,
          name: tSignUpParams.fullName,
        ),
      ),
      expect: () => [const AuthLoading(), const SignedUp()],
      verify: (_) {
        verify(() => mockSignUp(tSignUpParams)).called(1);
        verifyNoMoreInteractions(mockSignUp);
      },
    );

    blocTest<AuthBloc, AuthState>(
      'Should emit [AuthLoading, AuthError] when '
      '[SignUpEvent] failed',
      build: () {
        when(() => mockSignUp(any()))
            .thenAnswer((_) async => Left(tServerFailure));
        return authBloc;
      },
      act: (bloc) => bloc.add(
        SignUpEvent(
          email: tSignUpParams.email,
          password: tSignUpParams.password,
          name: tSignUpParams.fullName,
        ),
      ),
      expect: () =>
          [const AuthLoading(), AuthError(tServerFailure.errorMessage)],
      verify: (_) {
        verify(() => mockSignUp(tSignUpParams)).called(1);
        verifyNoMoreInteractions(mockSignUp);
      },
    );
  });

  group('ForgotPassword', () {
    const tEmail = '';
    final tServerFailure = ServerFailure(message: '', statusCode: '');
    blocTest<AuthBloc, AuthState>(
      'Should emit [AuthLoading, SignUp] when '
      '[ForgotPasswordEvent] is called',
      build: () {
        when(() => mockForgotPassword(any()))
            .thenAnswer((_) async => const Right(null));
        return authBloc;
      },
      act: (bloc) => bloc.add(
        const ForgotPasswordEvent(
          email: tEmail,
        ),
      ),
      expect: () => [const AuthLoading(), const ForgotPasswordSent()],
      verify: (_) {
        verify(() => mockForgotPassword(tEmail)).called(1);
        verifyNoMoreInteractions(mockForgotPassword);
      },
    );

    blocTest<AuthBloc, AuthState>(
      'Should emit [AuthLoading, AuthError] when '
      '[ForgotPasswordEvent] failed',
      build: () {
        when(() => mockForgotPassword(any()))
            .thenAnswer((_) async => Left(tServerFailure));
        return authBloc;
      },
      act: (bloc) => bloc.add(
        const ForgotPasswordEvent(email: tEmail),
      ),
      expect: () =>
          [const AuthLoading(), AuthError(tServerFailure.errorMessage)],
      verify: (_) {
        verify(() => mockForgotPassword(tEmail)).called(1);
        verifyNoMoreInteractions(mockForgotPassword);
      },
    );
  });

  group('UpdateUser', () {
    const tEmail = '';
    final tServerFailure = ServerFailure(message: '', statusCode: '');
    blocTest<AuthBloc, AuthState>(
      'Should emit [AuthLoading, UserUpdated] when '
      '[UpdateUserEvent] is called',
      build: () {
        when(() => mockUpdateUser(any()))
            .thenAnswer((_) async => const Right(null));
        return authBloc;
      },
      act: (bloc) => bloc.add(
        UpdateUserEvent(
          action: tUpdateUserParams.action,
          userData: tUpdateUserParams.userData,
        ),
      ),
      expect: () => [const AuthLoading(), const UserUpdated()],
      verify: (_) {
        verify(() => mockUpdateUser(tUpdateUserParams)).called(1);
        verifyNoMoreInteractions(mockUpdateUser);
      },
    );

    blocTest<AuthBloc, AuthState>(
      'Should emit [AuthLoading, AuthError] when '
      '[UpdateUserEvent] failed',
      build: () {
        when(() => mockForgotPassword(any()))
            .thenAnswer((_) async => Left(tServerFailure));
        return authBloc;
      },
      act: (bloc) => bloc.add(
        const ForgotPasswordEvent(email: tEmail),
      ),
      expect: () =>
          [const AuthLoading(), AuthError(tServerFailure.errorMessage)],
      verify: (_) {
        verify(() => mockForgotPassword(tEmail)).called(1);
        verifyNoMoreInteractions(mockForgotPassword);
      },
    );
  });
}
