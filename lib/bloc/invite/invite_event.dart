part of 'invite_bloc.dart';

@immutable
abstract class InviteEvent extends Equatable {}

class ManagerInviteSent extends InviteEvent {
  final String emailAddress;
  final Group group;
  ManagerInviteSent({
    required this.emailAddress,
    required this.group,
  });
  @override
  // TODO: implement props
  List<Object?> get props => [emailAddress, group];
}

class MemberInviteSent extends InviteEvent {
  final String emailAddress;
  final Group group;
  MemberInviteSent({
    required this.emailAddress,
    required this.group,
  });
  @override
  // TODO: implement props
  List<Object?> get props => [emailAddress, group];
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
