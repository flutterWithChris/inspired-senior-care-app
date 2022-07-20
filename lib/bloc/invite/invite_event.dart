part of 'invite_bloc.dart';

@immutable
abstract class InviteEvent extends Equatable {}

class InviteSent extends InviteEvent {
  @override
  // TODO: implement props
  List<Object?> get props => throw UnimplementedError();
}

class InviteReceived extends InviteEvent {
  @override
  // TODO: implement props
  List<Object?> get props => throw UnimplementedError();
}

class InviteAccepted extends InviteEvent {
  @override
  // TODO: implement props
  List<Object?> get props => throw UnimplementedError();
}

class InviteCancelled extends InviteEvent {
  @override
  // TODO: implement props
  List<Object?> get props => throw UnimplementedError();
}

class InviteDenied extends InviteEvent {
  @override
  // TODO: implement props
  List<Object?> get props => throw UnimplementedError();
}
