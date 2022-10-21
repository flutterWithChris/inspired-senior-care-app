import 'dart:async';

import 'package:bloc/bloc.dart';
import 'package:equatable/equatable.dart';
import 'package:inspired_senior_care_app/bloc/auth/auth_bloc.dart';
import 'package:inspired_senior_care_app/data/models/user.dart';
import 'package:inspired_senior_care_app/data/repositories/database/database_repository.dart';
import 'package:inspired_senior_care_app/data/repositories/purchases/purchases_repository.dart';
import 'package:meta/meta.dart';

part 'profile_event.dart';
part 'profile_state.dart';

class ProfileBloc extends Bloc<ProfileEvent, ProfileState> {
  final AuthBloc _authBloc;
  final DatabaseRepository _databaseRepository;
  List<String> groupNames = [];
  StreamSubscription? _authSubscription;

  ProfileBloc({
    required AuthBloc authBloc,
    required DatabaseRepository databaseRepository,
    required PurchasesRepository purchasesRepository,
  })  : _authBloc = authBloc,
        _databaseRepository = databaseRepository,
        super(ProfileLoading()) {
    on<LoadProfile>(_onLoadProfile);
    on<UpdateProfile>(_onUpdateProfile);
    on<ResetProfile>((event, emit) => emit(ProfileLoading()));

    _authSubscription = _authBloc.stream.listen((state) {
      state.authStatus == AuthStatus.authenticated
          ? add(LoadProfile(userId: state.user!.uid))
          : add(ResetProfile());
    });
  }
  void _onLoadProfile(LoadProfile event, Emitter<ProfileState> emit) async {
    print('User Loading: ${state.user.id}');

    await emit.forEach(_databaseRepository.getUser(event.userId),
        onData: (User user) {
      return ProfileLoaded(user: user);
    });
  }

  void _onUpdateProfile(UpdateProfile event, Emitter<ProfileState> emit) async {
    print(event.user);
    try {
      _databaseRepository.updateUser(event.user);
      //   emit(ProfileUpdated());
      await Future.delayed(const Duration(seconds: 1));
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
