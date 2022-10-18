import 'package:bloc/bloc.dart';
import 'package:inspired_senior_care_app/bloc/profile/profile_bloc.dart';
import 'package:inspired_senior_care_app/data/repositories/auth/auth_repository.dart';
import 'package:meta/meta.dart';

part 'settings_state.dart';

class SettingsCubit extends Cubit<SettingsState> {
  final AuthRepository _authRepository;
  final ProfileBloc _profileBloc;
  SettingsCubit(
      {required AuthRepository authRepository,
      required ProfileBloc profileBloc})
      : _authRepository = authRepository,
        _profileBloc = profileBloc,
        super(SettingsLoaded());
  void passwordResetRequest(String email) => _onPasswordResetRequest(email);
  void changeEmail(String email) => _onChangeEmailRequest(email);
  void changeName(String name) => _onChangeNameRequest(name);
  void changeOrganization(String organization) =>
      _onChangeOrganizationRequest(organization);
  void changeTitle(String title) => _onChangeTitleRequest(title);
  void loadSettings() => emit(SettingsLoaded());

  void _onPasswordResetRequest(String email) async {
    //  emit(SettingsLoading());
    try {
      await _authRepository.requestPasswordReset(email);
      emit(SettingsUpdated());
      await Future.delayed(const Duration(seconds: 1));
      emit(SettingsLoaded());
    } catch (e) {
      print(e);
    }
  }

  void _onChangeNameRequest(String name) async {
    // emit(SettingsLoading());
    try {
      _profileBloc.add(
          UpdateProfile(user: _profileBloc.state.user.copyWith(name: name)));
      await _authRepository.currentUser!.updateDisplayName(name);
      emit(SettingsUpdated());
      await Future.delayed(const Duration(seconds: 1));
      loadSettings();
    } catch (e) {
      print(e);
    }
  }

  void _onChangeEmailRequest(String email) async {
    // emit(SettingsLoading());
    try {
      _profileBloc.add(
          UpdateProfile(user: _profileBloc.state.user.copyWith(email: email)));
      await _authRepository.currentUser!.updateEmail(email);
      emit(SettingsUpdated());
      await Future.delayed(const Duration(seconds: 1));
      loadSettings();
    } catch (e) {
      print(e);
    }
  }

  void _onChangeOrganizationRequest(String organization) async {
    //emit(SettingsLoading());
    try {
      _profileBloc.add(UpdateProfile(
          user: _profileBloc.state.user.copyWith(organization: organization)));
      emit(SettingsUpdated());
      await Future.delayed(const Duration(seconds: 1));
      loadSettings();
    } catch (e) {
      print(e);
    }
  }

  void _onChangeTitleRequest(String title) async {
    //  emit(SettingsLoading());
    try {
      _profileBloc.add(
          UpdateProfile(user: _profileBloc.state.user.copyWith(title: title)));
      emit(SettingsUpdated());
      await Future.delayed(const Duration(seconds: 1));
      loadSettings();
    } catch (e) {
      print(e);
    }
  }
}
