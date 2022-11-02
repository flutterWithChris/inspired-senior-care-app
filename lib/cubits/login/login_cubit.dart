import 'package:bloc/bloc.dart';
import 'package:equatable/equatable.dart';
import 'package:inspired_senior_care_app/data/repositories/auth/auth_repository.dart';
import 'package:meta/meta.dart';
part 'login_state.dart';

class LoginCubit extends Cubit<LoginState> {
  final AuthRepository _authRepository;
  LoginCubit({required AuthRepository authRepository})
      : _authRepository = authRepository,
        super(LoginState.initial());

  void emailChanged(String value) {
    emit(state.copyWith(email: value, status: LoginStatus.initial));
  }

  void passwordChanged(String value) {
    emit(state.copyWith(password: value, status: LoginStatus.initial));
  }

  void signOut() async {
    await _authRepository.signOut();
  }

  Future<void> signInWithCredentials() async {
    emit(state.copyWith(status: LoginStatus.submitting));
    var user = await _authRepository.signInWithEmail(
        email: state.email, password: state.password);
    if (user != null) {
      emit(state.copyWith(status: LoginStatus.success));
    } else {
      emit(state.copyWith(status: LoginStatus.error));
    }
    await Future.delayed(const Duration(seconds: 1));
    emit(state.copyWith(status: LoginStatus.initial));
  }
}
