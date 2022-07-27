part of 'auth_bloc.dart';

@immutable
class AuthEvent extends Equatable {
  @override
  // TODO: implement props
  List<Object?> get props => throw UnimplementedError();
}

class AuthUserChanged extends AuthEvent {}
