part of 'login_cubit.dart';

enum LoginStatus { initial, submitting, success, error }

@immutable
class LoginState extends Equatable {
  final String email;
  final String password;
  final LoginStatus status;

  const LoginState({
    required this.status,
    required this.email,
    required this.password,
  });

  factory LoginState.initial() {
    return const LoginState(
        status: LoginStatus.initial, email: '', password: '');
  }

  bool get isValid => email.isNotEmpty && password.isNotEmpty;

  @override
  // TODO: implement props
  List<Object?> get props => [email, password, status];

  LoginState copyWith({
    String? email,
    String? password,
    LoginStatus? status,
  }) {
    return LoginState(
      email: email ?? this.email,
      password: password ?? this.password,
      status: status ?? this.status,
    );
  }
}
