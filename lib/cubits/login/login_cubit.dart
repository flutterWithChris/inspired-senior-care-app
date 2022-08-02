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

  void signOut() {
    _authRepository.signOut();
  }

  Future<void> signInWithCredentials() async {
    print('Logging in...');
    // if (!state.isValid) return;
    // if (state.status == LoginStatus.submitting) return null;
    emit(state.copyWith(status: LoginStatus.submitting));
    try {
      await _authRepository.signInWithEmail(
          email: state.email, password: state.password);
      emit(state.copyWith(status: LoginStatus.success));

      print('Logged In!');
    } catch (_) {
      print('Something went wrong signing in!');
    }
    return;
  }
}
