part of 'invite_bloc.dart';

@immutable
abstract class InviteEvent extends Equatable {
  final User? user;
  final Invite? invite;
  final String? emailAddress;
  final Group? group;
  const InviteEvent({
    this.user,
    this.invite,
    this.emailAddress,
    this.group,
  });
  @override
  List<Object?> get props => [invite];
}

class LoadInvites extends InviteEvent {
  @override
  final User user;
  const LoadInvites({
    required this.user,
  });
  @override
  List<Object?> get props => [user];
}

class ManagerInviteSent extends InviteEvent {
  @override
  final User user;
  @override
  final String emailAddress;
  @override
  final Group group;
  const ManagerInviteSent({
    required this.user,
    required this.emailAddress,
    required this.group,
  });
  @override
  List<Object?> get props => [emailAddress, group];
}

class MemberInviteSent extends InviteEvent {
  @override
  final User user;
  @override
  final String emailAddress;
  @override
  final Group group;
  const MemberInviteSent({
    required this.user,
    required this.emailAddress,
    required this.group,
  });
  @override
  List<Object?> get props => [emailAddress, group, user];
}

class InviteReceived extends InviteEvent {
  @override
  List<Object?> get props => throw UnimplementedError();
}

class InviteDeleted extends InviteEvent {
  @override
  final User user;
  @override
  final Invite invite;
  const InviteDeleted({
    required this.user,
    required this.invite,
  });
  @override
  List<Object?> get props => [invite, user];
}

class InviteAccepted extends InviteEvent {
  @override
  final User user;
  @override
  Invite invite;
  InviteAccepted({
    required this.user,
    required this.invite,
  });
  @override
  List<Object?> get props => [invite, user];
}

class InviteCancelled extends InviteEvent {
  @override
  Invite invite;
  InviteCancelled({
    required this.invite,
  });
  @override
  // TODO: implement props
  List<Object?> get props => throw UnimplementedError();
}

class InviteDenied extends InviteEvent {
  @override
  final User user;
  @override
  Invite invite;
  InviteDenied({
    required this.user,
    required this.invite,
  });
  @override
  // TODO: implement props
  List<Object?> get props => [invite, user];
}
