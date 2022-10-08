part of 'auth_bloc.dart';

@immutable
class AuthEvent extends Equatable {
  @override
  List<Object?> get props => [];
}

class AuthUserChanged extends AuthEvent {
  final auth.User? user;
  AuthUserChanged({required this.user});
  @override
  List<Object?> get props => [user!];
}

class AppLogoutRequested extends AuthEvent {}
