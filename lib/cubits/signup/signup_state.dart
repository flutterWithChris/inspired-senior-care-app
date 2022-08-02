part of 'signup_cubit.dart';

enum SignupStatus { initial, submitting, success, error }

@immutable
class SignupState extends Equatable {
  final String email;
  final String password;
  final SignupStatus status;
  final auth.User? user;

  const SignupState({
    this.user,
    required this.email,
    required this.password,
    required this.status,
  });

  factory SignupState.initial() {
    return const SignupState(
        email: '', password: '', status: SignupStatus.initial, user: null);
  }

  SignupState copyWith({
    String? email,
    String? password,
    SignupStatus? status,
    auth.User? user,
  }) {
    return SignupState(
      email: email ?? this.email,
      password: password ?? this.password,
      status: status ?? this.status,
      user: user ?? this.user,
    );
  }

  bool get isValid => email.isNotEmpty && password.isNotEmpty;

  @override
  // TODO: implement props
  List<Object?> get props => [email, password, status, user];
}
