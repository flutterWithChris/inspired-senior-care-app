import 'package:bloc/bloc.dart';
import 'package:equatable/equatable.dart';
import 'package:inspired_senior_care_app/data/repositories/auth/auth_repository.dart';
import 'package:meta/meta.dart';

part 'forgot_password_state.dart';

class ForgotPasswordCubit extends Cubit<ForgotPasswordState> {
  final AuthRepository _authRepository;
  ForgotPasswordCubit({required AuthRepository authRepository})
      : _authRepository = authRepository,
        super(ForgotPasswordState.initial());
  void requestPasswordReset(String email) => _onRequestPasswordReset(email);

  void _onRequestPasswordReset(String email) async {
    emit(ForgotPasswordState.sending());
    bool resetEmailSent = await _authRepository.requestPasswordReset(email);
    resetEmailSent == true
        ? emit(ForgotPasswordState.sent())
        : emit(ForgotPasswordState.failed());
    await Future.delayed(const Duration(seconds: 2), () {
      emit(ForgotPasswordState.initial());
    });
  }
}
