part of 'auth_bloc.dart';

enum AuthStatus { unknown, unauthenticated, authenticated }

@immutable
class AuthState extends Equatable {
  final AuthStatus authStatus;
  final auth.User? user;
  const AuthState._({
    this.user,
    this.authStatus = AuthStatus.unknown,
  });

  const AuthState.unknown() : this._();

  const AuthState.unauthenticated()
      : this._(authStatus: AuthStatus.unauthenticated);

  const AuthState.authenticated({required auth.User user})
      : this._(authStatus: AuthStatus.authenticated, user: user);

  @override
  List<Object?> get props => [authStatus, user];
}
