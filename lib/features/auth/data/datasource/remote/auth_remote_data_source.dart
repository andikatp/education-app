import 'dart:convert';
import 'dart:io';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/widgets.dart';
import 'package:teacher/core/enums/update_user.dart';
import 'package:teacher/core/errors/exceptions.dart';
import 'package:teacher/core/utils/constants.dart';
import 'package:teacher/core/utils/typedef.dart';
import 'package:teacher/features/auth/data/models/local_user_model.dart';
import 'package:teacher/features/auth/domain/entities/user_entity.dart';

abstract class AuthRemoteDataSource {
  Future<void> forgotPassword({required String email});
  Future<LocalUser> signIn({
    required String email,
    required String password,
  });
  Future<void> signUp({
    required String email,
    required String fullName,
    required String password,
  });
  Future<void> updateUser({
    required UpdateUserAction action,
    required dynamic userData,
  });
}

class AuthRemoteDataSourceImpl implements AuthRemoteDataSource {
  AuthRemoteDataSourceImpl({
    required FirebaseAuth authClient,
    required FirebaseFirestore cloudStoreClient,
    required FirebaseStorage dbClient,
  })  : _authClient = authClient,
        _cloudStoreClient = cloudStoreClient,
        _dbClient = dbClient;
  final FirebaseAuth _authClient;
  final FirebaseFirestore _cloudStoreClient;
  final FirebaseStorage _dbClient;

  @override
  Future<void> forgotPassword({required String email}) async {
    try {
      await _authClient.sendPasswordResetEmail(email: email);
    } on FirebaseAuthException catch (e) {
      throw ServerException(
        message: e.message ?? 'An Error Occured',
        statusCode: e.code,
      );
    } catch (e, s) {
      debugPrintStack(stackTrace: s);
      throw ServerException(message: e.toString(), statusCode: '505');
    }
  }

  @override
  Future<LocalUserModel> signIn({
    required String email,
    required String password,
  }) async {
    try {
      final userCredential = await _authClient.signInWithEmailAndPassword(
        email: email,
        password: password,
      );

      final user = userCredential.user;

      if (user == null) {
        throw const ServerException(
          message: 'Please try again later',
          statusCode: 'Unknow Error',
        );
      }
      var userData = await _getUserData(user.uid);

      if (!userData.exists) {
        await _setUserData(user, email);
        userData = await _getUserData(user.uid);
        return LocalUserModel.fromMap(userData.data()!);
      }
      return LocalUserModel.fromMap(userData.data()!);
    } on ServerException {
      rethrow;
    } on FirebaseAuthException catch (e) {
      throw ServerException(
        message: e.message ?? 'An Error Occured',
        statusCode: e.code,
      );
    } catch (e, s) {
      debugPrintStack(stackTrace: s);
      throw ServerException(message: e.toString(), statusCode: '505');
    }
  }

  @override
  Future<void> signUp({
    required String email,
    required String fullName,
    required String password,
  }) async {
    try {
      final userCredential = await _authClient.createUserWithEmailAndPassword(
        email: email,
        password: password,
      );
      await userCredential.user?.updateDisplayName(fullName);
      await userCredential.user?.updatePhotoURL(kDefaultAvatar);
      await _setUserData(userCredential.user!, email);
    } on FirebaseAuthException catch (e) {
      throw ServerException(
        message: e.message ?? 'An Error Occured',
        statusCode: e.code,
      );
    } catch (e, s) {
      debugPrintStack(stackTrace: s);
      throw ServerException(message: e.toString(), statusCode: '505');
    }
  }

  @override
  Future<void> updateUser({
    required UpdateUserAction action,
    required dynamic userData,
  }) async {
    try {
      switch (action) {
        case UpdateUserAction.email:
          await _authClient.currentUser?.updateEmail(userData as String);
          await _updateUserData({'email': userData});
        case UpdateUserAction.displayName:
          await _authClient.currentUser?.updateDisplayName(userData as String);
          await _updateUserData({'fullName': userData});
        case UpdateUserAction.profilePic:
          final ref = _dbClient
              .ref()
              .child('profile_pics/${_authClient.currentUser?.uid}');
          await ref.putFile(userData as File);
          final url = await ref.getDownloadURL();
          await _authClient.currentUser?.updatePhotoURL(url);
          await _updateUserData({'profilePic': url});
        case UpdateUserAction.password:
          if (_authClient.currentUser?.email != null) {
            final newData = jsonDecode(userData as String) as DataMap;
            await _authClient.currentUser?.reauthenticateWithCredential(
              EmailAuthProvider.credential(
                email: _authClient.currentUser!.email!,
                password: newData['oldPassword'] as String,
              ),
            );
            return await _authClient.currentUser
                ?.updatePassword(newData['newPassword'] as String);
          }

          throw const ServerException(
            message: 'User does not exist',
            statusCode: 'Insufficient Permission',
          );

        case UpdateUserAction.bio:
          await _updateUserData({'bio': userData as String});
      }
    } on ServerException {
      rethrow;
    } on FirebaseException catch (e) {
      throw ServerException(
        message: e.message ?? 'An Error Occured',
        statusCode: e.code,
      );
    } catch (e, s) {
      debugPrintStack(stackTrace: s);
      throw ServerException(message: e.toString(), statusCode: '505');
    }
  }

  Future<DocumentSnapshot<DataMap>> _getUserData(String uid) async {
    return _cloudStoreClient.collection('users').doc(uid).get();
  }

  Future<void> _setUserData(User user, String fallbackEmail) async {
    await _cloudStoreClient.collection('users').doc(user.uid).set(
          LocalUserModel(
            uid: user.uid,
            email: user.email ?? fallbackEmail,
            fullName: user.displayName ?? '',
            profilePic: user.photoURL ?? '',
            points: 0,
          ).toMap(),
        );
  }

  Future<void> _updateUserData(DataMap data) async {
    await _cloudStoreClient
        .collection('users')
        .doc(_authClient.currentUser?.uid)
        .update(data);
  }
}
