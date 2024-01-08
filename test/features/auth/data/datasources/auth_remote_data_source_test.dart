import 'package:fake_cloud_firestore/fake_cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_auth_mocks/firebase_auth_mocks.dart';
import 'package:firebase_storage_mocks/firebase_storage_mocks.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:google_sign_in_mocks/google_sign_in_mocks.dart';
import 'package:teacher/core/enums/update_user.dart';
import 'package:teacher/features/auth/data/datasource/remote/auth_remote_data_source.dart';

main() {
  late FakeFirebaseFirestore mockCloudstoreClient;
  late MockFirebaseAuth mockAuthClient;
  late MockFirebaseStorage mockDbClient;
  late AuthRemoteDataSource dataSource;

  setUp(() async {
    mockCloudstoreClient = FakeFirebaseFirestore();
    mockDbClient = MockFirebaseStorage();

    // Mock sign in with Google.
    final googleSignIn = MockGoogleSignIn();
    final signinAccount = await googleSignIn.signIn();
    final googleAuth = await signinAccount!.authentication;
    final credential = GoogleAuthProvider.credential(
      accessToken: googleAuth.accessToken,
      idToken: googleAuth.idToken,
    );
    // Sign in.
    final mockUser = MockUser(
      uid: 'someuid',
      email: 'bob@somedomain.com',
      displayName: 'Bob',
    );
    mockAuthClient = MockFirebaseAuth(mockUser: mockUser);
    final result = await mockAuthClient.signInWithCredential(credential);
    final user = result.user;

    dataSource = AuthRemoteDataSourceImpl(
      authClient: mockAuthClient,
      cloudStoreClient: mockCloudstoreClient,
      dbClient: mockDbClient,
    );
  });

  const tPassword = 'tPassword';
  const tFullName = 'tFullName';
  const tEmail = 'tEmail@gmail.com';

  group('signUp', () {
    test('Should get the user which was created in firestore and authclient',
        () async {
      // act
      await dataSource.signUp(
        email: tEmail,
        fullName: tFullName,
        password: tPassword,
      );
      // assert
      expect(mockAuthClient.currentUser, isNotNull);
      expect(mockAuthClient.currentUser!.displayName, tFullName);

      final user = await mockCloudstoreClient
          .collection('users')
          .doc(mockAuthClient.currentUser!.uid)
          .get();
      expect(user.exists, isTrue);
    });
  });

  group('signIn', () {
    const tNewEmail = 'newEmail@gmail.com';
    test('Should sign in using the email and password', () async {
      // act
      await dataSource.signUp(
        email: tNewEmail,
        fullName: tFullName,
        password: tPassword,
      );
      await mockAuthClient.signOut();
      await dataSource.signIn(email: tNewEmail, password: tPassword);
      // assert
      expect(mockAuthClient.currentUser, isNotNull);
      expect(mockAuthClient.currentUser?.email, equals(tNewEmail));
    });
  });

  group('updateUser', () {
    test('display Name', () async {
      // arrange
      await dataSource.signUp(
        email: tEmail,
        fullName: tFullName,
        password: tPassword,
      );
      // act
      await dataSource.updateUser(
        action: UpdateUserAction.displayName,
        userData: 'new name',
      );
      // assert
      expect(mockAuthClient.currentUser?.displayName, 'new name');
    });

   
  });
}
