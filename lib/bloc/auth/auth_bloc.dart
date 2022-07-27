import 'dart:async';

import 'package:bloc/bloc.dart';
import 'package:equatable/equatable.dart';
import 'package:inspired_senior_care_app/data/models/user.dart';
import 'package:meta/meta.dart';

part 'auth_event.dart';
part 'auth_state.dart';

class AuthBloc extends Bloc<AuthEvent, AuthState> {
  bool loggedIn = false;
  StreamController<bool> userStream = StreamController.broadcast();
  StreamSubscription<User?>? _userSubscription;
  AuthBloc() : super(const AuthState.unauthenticated()) {
    on<AuthUserChanged>(_onUserChanged);
    on<AuthEvent>((event, emit) {
      if (event is AuthUserChanged) {
        loggedIn = true;
      }
    });
  }
}

void _onUserChanged(AuthUserChanged event, Emitter<AuthState> emit) {
  // TODO: event.user.isNotEmpty null check
  print('User Authenticated');
  emit(const AuthState.authenticated());
}
