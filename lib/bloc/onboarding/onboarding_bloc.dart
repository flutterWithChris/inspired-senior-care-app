import 'package:bloc/bloc.dart';
import 'package:equatable/equatable.dart';

import 'package:inspired_senior_care_app/data/models/user.dart';
import 'package:inspired_senior_care_app/data/repositories/database/database_repository.dart';
import 'package:inspired_senior_care_app/data/repositories/storage/storage_repository.dart';

part 'onboarding_event.dart';
part 'onboarding_state.dart';

class OnboardingBloc extends Bloc<OnboardingEvent, OnboardingState> {
  final DatabaseRepository _databaseRepository;
  final StorageRepository _storageRepository;
  OnboardingBloc(
      {required DatabaseRepository databaseRepository,
      required StorageRepository storageRepository})
      : _databaseRepository = databaseRepository,
        _storageRepository = storageRepository,
        super(OnboardingInitial()) {
    on<StartOnboarding>(_onStartOnboarding);
    on<UpdateUser>(_onUpdateUser);
  }

  void _onStartOnboarding(
      StartOnboarding event, Emitter<OnboardingState> emit) async {
    await _databaseRepository.createUser(event.user);
    emit(OnboardingLoaded(user: event.user));
  }

  void _onUpdateUser(UpdateUser event, Emitter<OnboardingState> emit) {
    if (state is OnboardingLoaded) {
      _databaseRepository.updateUser(event.user);
      emit(OnboardingLoaded(user: event.user));
    }
  }
}
