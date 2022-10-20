import 'dart:async';
import 'package:bloc/bloc.dart';
import 'package:equatable/equatable.dart';
import 'package:flutter/cupertino.dart';
import 'package:firebase_auth/firebase_auth.dart' as auth;

import 'package:inspired_senior_care_app/data/repositories/auth/auth_repository.dart';
import 'package:inspired_senior_care_app/data/repositories/purchases/purchases_repository.dart';

part 'auth_event.dart';
part 'auth_state.dart';

class AuthBloc extends Bloc<AuthEvent, AuthState> with ChangeNotifier {
  final AuthRepository _authRepository;
  final PurchasesRepository _purchasesRepository;
  StreamSubscription<auth.User?>? _userSubscription;

  AuthBloc({
    required AuthRepository authRepository,
    required PurchasesRepository purchasesRepository,
  })  : _authRepository = authRepository,
        _purchasesRepository = purchasesRepository,
        super(
          authRepository.currentUser != null
              ? AuthState.authenticated(user: authRepository.currentUser!)
              : const AuthState.unauthenticated(),
        ) {
    on<AuthUserChanged>(_onUserChanged);
    on<AppLogoutRequested>(_onLogoutRequested);

    _userSubscription =
        _authRepository.user.listen((user) => add(AuthUserChanged(user: user)));
  }

  @override
  Future<void> close() {
    _userSubscription?.cancel();
    return super.close();
  }

  void _onUserChanged(AuthUserChanged event, Emitter<AuthState> emit) {
    print('User Authenticated');

    emit(event.user != null
        ? AuthState.authenticated(user: event.user!)
        : const AuthState.unauthenticated());
    notifyListeners();
  }

  void _onLogoutRequested(
      AppLogoutRequested event, Emitter<AuthState> emit) async {
    print('User Authenticated');
    await _purchasesRepository.logoutOfRevCat();
    unawaited(_authRepository.signOut());
    emit(const AuthState.unauthenticated());
  }
}
