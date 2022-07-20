part of 'invite_bloc.dart';

enum InviteStatus {
  initial,
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

  InviteState({
    required this.inviteStatus,
  });

  factory InviteState.initial() {
    return InviteState(inviteStatus: InviteStatus.initial);
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
  List<Object?> get props => [inviteStatus];
}
