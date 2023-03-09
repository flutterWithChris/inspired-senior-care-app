part of 'invite_bloc.dart';

enum InviteStatus {
  initial,
  loading,
  loaded,
  sending,
  sent,
  cancelled,
  received,
  accepted,
  denied,
  failed
}

@immutable
class InviteState extends Equatable {
  InviteStatus inviteStatus;
  List<Invite>? invites;

  Stream<List<Invite>?>? inviteStream;

  InviteState({
    required this.inviteStatus,
    this.inviteStream,
    this.invites,
  });

  factory InviteState.initial() {
    return InviteState(inviteStatus: InviteStatus.initial);
  }
  factory InviteState.loading() {
    return InviteState(inviteStatus: InviteStatus.loading);
  }
  factory InviteState.loaded({required List<Invite> invites}) {
    return InviteState(inviteStatus: InviteStatus.loaded, invites: invites);
  }

  factory InviteState.sending() {
    return InviteState(inviteStatus: InviteStatus.sending);
  }

  factory InviteState.sent() {
    return InviteState(inviteStatus: InviteStatus.sent);
  }

  factory InviteState.cancelled() {
    return InviteState(inviteStatus: InviteStatus.cancelled);
  }

  factory InviteState.receieved() {
    return InviteState(inviteStatus: InviteStatus.received);
  }

  factory InviteState.accepted() {
    return InviteState(inviteStatus: InviteStatus.accepted);
  }

  factory InviteState.denied() {
    return InviteState(inviteStatus: InviteStatus.denied);
  }

  factory InviteState.failed() {
    return InviteState(inviteStatus: InviteStatus.failed);
  }

  @override
  // TODO: implement props
  List<Object?> get props => [inviteStatus, inviteStream];
}
