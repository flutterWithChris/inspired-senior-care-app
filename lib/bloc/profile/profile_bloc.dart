import 'dart:async';

import 'package:bloc/bloc.dart';
import 'package:equatable/equatable.dart';
import 'package:inspired_senior_care_app/bloc/auth/auth_bloc.dart';
import 'package:inspired_senior_care_app/data/models/user.dart';
import 'package:inspired_senior_care_app/data/repositories/database/database_repository.dart';
import 'package:meta/meta.dart';

part 'profile_event.dart';
part 'profile_state.dart';

class ProfileBloc extends Bloc<ProfileEvent, ProfileState> {
  final AuthBloc _authBloc;
  final DatabaseRepository _databaseRepository;
  StreamSubscription? _authSubscription;
  ProfileBloc({
    required AuthBloc authBloc,
    required DatabaseRepository databaseRepository,
  })  : _authBloc = authBloc,
        _databaseRepository = databaseRepository,
        super(ProfileLoading()) {
    on<LoadProfile>(_onLoadProfile);
    on<UpdateProfile>(_onUpdateProfile);

    _authSubscription = _authBloc.stream.listen((state) {
      state.authStatus == AuthStatus.authenticated
          ? add(LoadProfile(userId: state.user.id!))
          : null;
    });
  }
  void _onLoadProfile(LoadProfile event, Emitter<ProfileState> emit) {
    print('User Loading: ${state.user.id}');
    _databaseRepository.getUser(event.userId).listen((user) {
      add(UpdateProfile(user: user));
    });
  }

  void _onUpdateProfile(UpdateProfile event, Emitter<ProfileState> emit) {
    print(event.user);
    try {
      _databaseRepository.updateUser(event.user);
      emit(ProfileLoaded(user: event.user));
    } catch (e) {
      emit(ProfileFailed());
    }
  }

  @override
  Future<void> close() {
    _authSubscription?.cancel();
    return super.close();
  }
}
