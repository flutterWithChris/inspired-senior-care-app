part of 'auth_bloc.dart';

enum AuthStatus { unauthenticated, authenticated }

@immutable
class AuthState extends Equatable {
  final AuthStatus authStatus;
  const AuthState._({
    required this.authStatus,
  });

  const AuthState.unauthenticated()
      : this._(authStatus: AuthStatus.unauthenticated);

  const AuthState.authenticated()
      : this._(authStatus: AuthStatus.authenticated);

  @override
  List<Object?> get props => [authStatus];
}
