import 'package:firebase_auth/firebase_auth.dart' as auth;
import 'package:flutter/material.dart';
import 'package:inspired_senior_care_app/data/models/user.dart';
import 'package:inspired_senior_care_app/data/repositories/auth/base_auth_repository.dart';
import 'package:inspired_senior_care_app/globals.dart';

class AuthRepository extends BaseAuthRepository {
  final auth.FirebaseAuth _firebaseAuth;

  AuthRepository({auth.FirebaseAuth? firebaseAuth})
      : _firebaseAuth = firebaseAuth ?? auth.FirebaseAuth.instance;

  auth.User? currentUser;

  @override
  Stream<auth.User?> get user => _firebaseAuth.userChanges();

  @override
  Future<auth.User?> signUp({
    required String email,
    required String password,
  }) async {
    try {
      final credential = await _firebaseAuth.createUserWithEmailAndPassword(
          email: email, password: password);
      final auth.User? user = credential.user;
      return user;
    } catch (_) {}
    return null;
  }

  @override
  Future<auth.User?> signInWithEmail({
    required String email,
    required String password,
  }) async {
    try {
      print('Sign in attempted....$email');
      final credential = await _firebaseAuth.signInWithEmailAndPassword(
          email: email, password: password);
      final auth.User? user = credential.user;
      return user;
    } on auth.FirebaseAuthException catch (e) {
      print('Failed with error code: ${e.code}');
      print(e.message);
      final SnackBar snackBar = SnackBar(
        content: Text(e.message!),
        backgroundColor: Colors.redAccent,
      );
      snackbarKey.currentState?.showSnackBar(snackBar);
    }
    return null;
  }

  @override
  Future<auth.User?> reauthenticate({
    required String email,
    required String password,
  }) async {
    try {
      print('Sign in attempted....$email');
      final credential = await _firebaseAuth.signInWithEmailAndPassword(
          email: email, password: password);
      await _firebaseAuth.currentUser!
          .reauthenticateWithCredential(credential.credential!);
      final auth.User? user = credential.user;
      return user;
    } on auth.FirebaseAuthException catch (e) {
      print('Failed with error code: ${e.code}');
      print(e.message);
      final SnackBar snackBar = SnackBar(
        content: Text(e.message!),
        backgroundColor: Colors.redAccent,
      );
      snackbarKey.currentState?.showSnackBar(snackBar);
    }
    return null;
  }

  @override
  Future<void> signOut() async {
    await _firebaseAuth.signOut();
  }

  @override
  Future<void> requestPasswordReset(String email) async {
    try {
      await _firebaseAuth.sendPasswordResetEmail(email: email);
    } on auth.FirebaseAuthException catch (e) {
      print('Failed with error code: ${e.code}');
      print(e.message);
      final SnackBar snackBar = SnackBar(
        content: Text(e.message!),
        backgroundColor: Colors.redAccent,
      );
      snackbarKey.currentState?.showSnackBar(snackBar);
    }
  }

  @override
  Future<void> changeEmail(
      String oldEmail, String newEmail, String password) async {
    try {
      final credential = auth.EmailAuthProvider.credential(
          email: oldEmail, password: password);
      await _firebaseAuth.currentUser!.reauthenticateWithCredential(credential);
      await _firebaseAuth.currentUser!.updateEmail(newEmail);
    } on auth.FirebaseAuthException catch (e) {
      print('Failed with error code: ${e.code}');
      print(e.message);
      final SnackBar snackBar = SnackBar(
        content: Text(e.message!),
        backgroundColor: Colors.redAccent,
      );
      snackbarKey.currentState?.showSnackBar(snackBar);
    }
  }

  @override
  Future<void> deleteAccount(String email, String password) async {
    try {
      // TODO: Reauthenticate user before attempting delete.
      final credential =
          auth.EmailAuthProvider.credential(email: email, password: password);
      await _firebaseAuth.currentUser!.reauthenticateWithCredential(credential);
      await _firebaseAuth.currentUser!.delete();
    } on auth.FirebaseAuthException catch (e) {
      print('Failed with error code: ${e.code}');
      print(e.message);
      final SnackBar snackBar = SnackBar(
        content: Text(e.message!),
        backgroundColor: Colors.redAccent,
      );
      snackbarKey.currentState?.showSnackBar(snackBar);
    }
  }
}

extension on auth.User {
  User get toUser {
    return User(id: uid, email: email, name: displayName);
  }
}
