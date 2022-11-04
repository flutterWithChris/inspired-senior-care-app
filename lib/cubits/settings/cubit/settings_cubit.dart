import 'package:bloc/bloc.dart';
import 'package:flutter/material.dart';
import 'package:inspired_senior_care_app/bloc/profile/profile_bloc.dart';
import 'package:inspired_senior_care_app/data/models/bug_report.dart';
import 'package:inspired_senior_care_app/data/repositories/auth/auth_repository.dart';
import 'package:inspired_senior_care_app/data/repositories/database/database_repository.dart';
import 'package:inspired_senior_care_app/globals.dart';

part 'settings_state.dart';

class SettingsCubit extends Cubit<SettingsState> {
  final AuthRepository _authRepository;
  final DatabaseRepository _databaseRepository;
  final ProfileBloc _profileBloc;
  SettingsCubit(
      {required AuthRepository authRepository,
      required DatabaseRepository databaseRepository,
      required ProfileBloc profileBloc})
      : _authRepository = authRepository,
        _databaseRepository = databaseRepository,
        _profileBloc = profileBloc,
        super(SettingsLoaded());
  void passwordResetRequest(String email) => _onPasswordResetRequest(email);
  void changeEmail(String oldEmail, String newEmail, String password) =>
      _onChangeEmailRequest(oldEmail, newEmail, password);
  void changeName(String name) => _onChangeNameRequest(name);
  void changeOrganization(String organization) =>
      _onChangeOrganizationRequest(organization);
  void changeTitle(String title) => _onChangeTitleRequest(title);
  void loadSettings() => emit(SettingsLoaded());
  void deleteAccount(String email, String password) =>
      _onDeleteAccountRequest(email, password);
  void sendBugReport(String report, String deviceType, String userId,
          String userEmail, String userName) =>
      _onSendBugReport(report, deviceType, userId, userEmail, userName);

  void _onSendBugReport(String report, String deviceType, String userId,
      String userEmail, String userName) async {
    await _databaseRepository.sendBugReport(BugReport(
        report: report,
        deviceType: deviceType,
        userId: userId,
        userEmail: userEmail,
        userName: userName));
    emit(SettingsUpdated());
    await Future.delayed(const Duration(seconds: 2));
    emit(SettingsLoaded());
  }

  void _onPasswordResetRequest(String email) async {
    await _authRepository.requestPasswordReset(email);
    emit(SettingsUpdated());
    await Future.delayed(const Duration(seconds: 3));
    emit(SettingsLoaded());
  }

  void _onDeleteAccountRequest(String email, String password) async {
    await _databaseRepository.deleteUser(_profileBloc.state.user);
    await _authRepository.deleteAccount(email, password);
    emit(SettingsUpdated());
    await Future.delayed(const Duration(seconds: 2));
    emit(SettingsLoaded());
  }

  void _onChangeNameRequest(String name) async {
    try {
      _profileBloc.add(
          UpdateProfile(user: _profileBloc.state.user.copyWith(name: name)));
      // await _authRepository.currentUser!.updateDisplayName(name);
      emit(SettingsUpdated());
      await Future.delayed(const Duration(seconds: 2));
      loadSettings();
    } catch (e) {
      final SnackBar snackBar = SnackBar(
        content: Text(e.toString()),
        backgroundColor: Colors.redAccent,
      );
      snackbarKey.currentState?.showSnackBar(snackBar);
    }
  }

  void _onChangeEmailRequest(
      String oldEmail, String newEmail, String password) async {
    try {
      _profileBloc.add(UpdateProfile(
          user: _profileBloc.state.user.copyWith(email: newEmail)));
      await _authRepository.changeEmail(oldEmail, newEmail, password);
      emit(SettingsUpdated());
      await Future.delayed(const Duration(seconds: 2));
      loadSettings();
    } catch (e) {
      final SnackBar snackBar = SnackBar(
        content: Text(e.toString()),
        backgroundColor: Colors.redAccent,
      );
      snackbarKey.currentState?.showSnackBar(snackBar);
    }
  }

  void _onChangeOrganizationRequest(String organization) async {
    try {
      _profileBloc.add(UpdateProfile(
          user: _profileBloc.state.user.copyWith(organization: organization)));
      emit(SettingsUpdated());
      await Future.delayed(const Duration(seconds: 2));
      loadSettings();
    } catch (e) {
      final SnackBar snackBar = SnackBar(
        content: Text(e.toString()),
        backgroundColor: Colors.redAccent,
      );
      snackbarKey.currentState?.showSnackBar(snackBar);
    }
  }

  void _onChangeTitleRequest(String title) async {
    try {
      _profileBloc.add(
          UpdateProfile(user: _profileBloc.state.user.copyWith(title: title)));
      emit(SettingsUpdated());
      await Future.delayed(const Duration(seconds: 2));
      loadSettings();
    } catch (e) {
      final SnackBar snackBar = SnackBar(
        content: Text(e.toString()),
        backgroundColor: Colors.redAccent,
      );
      snackbarKey.currentState?.showSnackBar(snackBar);
    }
  }
}
