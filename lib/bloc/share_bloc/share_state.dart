part of 'share_bloc.dart';

enum Status { initial, started, cancelled, submitting, submitted, failed }

@immutable
class ShareState extends Equatable {
  final Status status;
  const ShareState({
    required this.status,
  });
  @override
  // TODO: implement props
  List<Object?> get props => [status];

  factory ShareState.initial() {
    return const ShareState(status: Status.initial);
  }

  factory ShareState.started() {
    return const ShareState(status: Status.started);
  }

  factory ShareState.cancelled() {
    return const ShareState(status: Status.started);
  }

  factory ShareState.submitting() {
    // TODO: Pass User to Share State?
    // User user;
    return const ShareState(status: Status.submitting);
  }

  factory ShareState.submitted() {
    return const ShareState(status: Status.submitted);
  }

  factory ShareState.failed() {
    return const ShareState(status: Status.failed);
  }
}
