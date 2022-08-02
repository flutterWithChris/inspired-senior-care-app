import 'package:firebase_auth/firebase_auth.dart' as auth;
import 'package:inspired_senior_care_app/data/models/user.dart';

abstract class BaseAuthRepository {
  Stream<User> get user;
  Future<auth.User?> signUp({
    required String email,
    required String password,
  });
  Future<auth.User?> signInWithEmail({
    required String email,
    required String password,
  });
  void signOut();
}
