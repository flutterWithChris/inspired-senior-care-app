import 'package:firebase_auth/firebase_auth.dart' as auth;
import 'package:inspired_senior_care_app/data/models/user.dart';
import 'package:inspired_senior_care_app/data/repositories/auth/base_auth_repository.dart';

class AuthRepository extends BaseAuthRepository {
  final auth.FirebaseAuth _firebaseAuth;

  AuthRepository({auth.FirebaseAuth? firebaseAuth})
      : _firebaseAuth = firebaseAuth ?? auth.FirebaseAuth.instance;

  var currentUser = User.empty;

  @override
  Stream<User> get user {
    return _firebaseAuth.authStateChanges().map((firebaseUser) {
      final user = firebaseUser == null ? User.empty : firebaseUser.toUser;
      currentUser = user;
      return user;
    });
  }

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
    } catch (_) {}
    return null;
  }

  @override
  Future<void> signOut() async {
    try {
      await _firebaseAuth.signOut();
    } catch (_) {}
  }
}

extension on auth.User {
  User get toUser {
    return User(id: uid, email: email, name: displayName);
  }
}
