import 'dart:async';

import 'package:bloc/bloc.dart';
import 'package:equatable/equatable.dart';
import 'package:firebase_auth/firebase_auth.dart' as auth;
import 'package:flutter/cupertino.dart';
import 'package:inspired_senior_care_app/data/repositories/auth/auth_repository.dart';
import 'package:inspired_senior_care_app/data/repositories/purchases/purchases_repository.dart';
import 'package:inspired_senior_care_app/router/router.dart';

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
  Future<void> close() async {
    await _userSubscription?.cancel();
    return super.close();
  }

  void _onUserChanged(AuthUserChanged event, Emitter<AuthState> emit) async {
    bool? isUserAnonymous = await _purchasesRepository.isUserAnonymous();
    if (event.user != null) {
      await _purchasesRepository.loginToRevCat(event.user!.uid);
    } else if (isUserAnonymous == false) {
      await _purchasesRepository.logoutOfRevCat();
    }

    emit(event.user != null
        ? AuthState.authenticated(user: event.user!)
        : const AuthState.unauthenticated());
    notifyListeners();
    router.refresh();
  }

  void _onLogoutRequested(
      AppLogoutRequested event, Emitter<AuthState> emit) async {
    emit(const AuthState.unauthenticated());
    unawaited(_authRepository.signOut());
  }
}
