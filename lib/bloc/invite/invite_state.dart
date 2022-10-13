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
  List<Invite> invites;

  InviteState({
    required this.inviteStatus,
    required this.invites,
  });

  factory InviteState.initial() {
    return InviteState(inviteStatus: InviteStatus.initial, invites: const []);
  }
  factory InviteState.loading() {
    return InviteState(inviteStatus: InviteStatus.loading, invites: const []);
  }
  factory InviteState.loaded(List<Invite> invites) {
    return InviteState(inviteStatus: InviteStatus.loaded, invites: invites);
  }

  factory InviteState.sending() {
    return InviteState(inviteStatus: InviteStatus.sending, invites: const []);
  }

  factory InviteState.sent() {
    return InviteState(inviteStatus: InviteStatus.sent, invites: const []);
  }

  factory InviteState.cancelled() {
    return InviteState(inviteStatus: InviteStatus.cancelled, invites: const []);
  }

  factory InviteState.receieved() {
    return InviteState(inviteStatus: InviteStatus.received, invites: const []);
  }

  factory InviteState.accepted() {
    return InviteState(inviteStatus: InviteStatus.accepted, invites: const []);
  }

  factory InviteState.denied() {
    return InviteState(inviteStatus: InviteStatus.denied, invites: const []);
  }

  factory InviteState.failed() {
    return InviteState(inviteStatus: InviteStatus.failed, invites: const []);
  }

  @override
  // TODO: implement props
  List<Object?> get props => [inviteStatus, invites];
}
