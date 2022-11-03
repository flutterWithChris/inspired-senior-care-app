part of 'forgot_password_cubit.dart';

enum ForgotPasswordStatus { initial, sending, sent, failed }

@immutable
class ForgotPasswordState extends Equatable {
  ForgotPasswordStatus status;
  ForgotPasswordState({
    required this.status,
  });

  factory ForgotPasswordState.initial() {
    return ForgotPasswordState(status: ForgotPasswordStatus.initial);
  }
  factory ForgotPasswordState.sending() {
    return ForgotPasswordState(status: ForgotPasswordStatus.sending);
  }
  factory ForgotPasswordState.sent() {
    return ForgotPasswordState(status: ForgotPasswordStatus.sent);
  }
  factory ForgotPasswordState.failed() {
    return ForgotPasswordState(status: ForgotPasswordStatus.failed);
  }
  @override
  // TODO: implement props
  List<Object?> get props => [status];
}
