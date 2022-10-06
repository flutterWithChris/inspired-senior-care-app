import 'package:bloc/bloc.dart';
import 'package:inspired_senior_care_app/data/repositories/auth/auth_repository.dart';
import 'package:meta/meta.dart';

part 'settings_state.dart';

class EditPassCubit extends Cubit<SettingsState> {
  final AuthRepository _authRepository;
  EditPassCubit({required AuthRepository authRepository})
      : _authRepository = authRepository,
        super(SettingsInitial());
  void passwordResetRequest(String email) => _onPasswordResetRequest(email);

  void _onPasswordResetRequest(String email) async {
    try {
      await _authRepository.requestPasswordReset(email);
    } catch (e) {
      print(e);
    }
  }
}
