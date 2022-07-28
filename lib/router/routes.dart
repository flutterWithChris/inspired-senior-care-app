import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';
import 'package:inspired_senior_care_app/bloc/auth/auth_bloc.dart';
import 'package:inspired_senior_care_app/bloc/deck/deck_cubit.dart';
import 'package:inspired_senior_care_app/bloc/manage/view_response_deck_cubit.dart';
import 'package:inspired_senior_care_app/bloc/onboarding/onboarding_bloc.dart';
import 'package:inspired_senior_care_app/bloc/view_response/view_response_cubit.dart';
import 'package:inspired_senior_care_app/main.dart';
import 'package:inspired_senior_care_app/view/pages/categories.dart';
import 'package:inspired_senior_care_app/view/pages/dashboard/choose_category.dart';
import 'package:inspired_senior_care_app/view/pages/dashboard/dashboard.dart';
import 'package:inspired_senior_care_app/view/pages/dashboard/members/view_responses.dart';
import 'package:inspired_senior_care_app/view/pages/deck_page.dart';
import 'package:inspired_senior_care_app/view/pages/login/login.dart';
import 'package:inspired_senior_care_app/view/pages/profile.dart';
import 'package:inspired_senior_care_app/view/pages/signup/signup.dart';
import 'package:inspired_senior_care_app/view/pages/view_member.dart';

class MyRouter {
  final AuthBloc _authBloc = AuthBloc();
  late final router = GoRouter(
      initialLocation: '/login',
      urlPathStrategy: UrlPathStrategy.path,
      debugLogDiagnostics: true,
      // errorPageBuilder: ,
      /*    refreshListenable:
          GoRouterRefreshStream(_authBloc.stream.asBroadcastStream()),
      redirect: (state) {
        bool isLoggingIn = state.location == '/login';
        bool loggedIn =
            _authBloc.state == const AuthState.unauthenticated() ? false : true;
        bool isSigningUp = state.subloc == '/signup';
        bool hasBeenOnboarded = true;

        if (!hasBeenOnboarded && !isSigningUp) {
          return '/signup';
        } else if (hasBeenOnboarded && !isLoggingIn && !loggedIn) {
          return '/login';
        }

        if (loggedIn) {
          return '/';
        }

        return null;
      },*/
      routes: [
        GoRoute(
          name: 'login',
          path: '/login',
          pageBuilder: (context, state) =>
              MaterialPage(key: state.pageKey, child: const LoginScreen()),
        ),
        GoRoute(
          name: 'signup',
          path: '/signup',
          pageBuilder: (context, state) => MaterialPage(
              key: state.pageKey,
              child: BlocProvider(
                create: (context) => OnboardingBloc(),
                child: const SignupScreen(),
              )),
        ),
        GoRoute(
          name: 'home',
          path: '/',
          pageBuilder: (context, state) =>
              MaterialPage(key: state.pageKey, child: const MyHomePage()),
        ),
        GoRoute(
            name: 'categories',
            path: '/categories',
            pageBuilder: (context, state) =>
                MaterialPage(key: state.pageKey, child: const Categories()),
            routes: [
              GoRoute(
                name: 'deck-page',
                path: 'deck-page',
                pageBuilder: (context, state) => MaterialPage(
                    key: state.pageKey,
                    child: BlocProvider(
                      create: (context) => DeckCubit(),
                      child: DeckPage(),
                    )),
              ),
            ]),
        GoRoute(
          name: 'profile',
          path: '/profile',
          pageBuilder: (context, state) =>
              MaterialPage(key: state.pageKey, child: const Profile()),
        ),
        GoRoute(
            name: 'dashboard',
            path: '/dashboard',
            pageBuilder: (context, state) =>
                MaterialPage(key: state.pageKey, child: const Dashboard()),
            routes: [
              GoRoute(
                name: 'view-member',
                path: 'view-member',
                pageBuilder: (context, state) =>
                    MaterialPage(key: state.pageKey, child: const ViewMember()),
                routes: [
                  GoRoute(
                      name: 'view-responses',
                      path: 'view-responses',
                      pageBuilder: (context, state) => MaterialPage(
                          key: state.pageKey,
                          child: MultiBlocProvider(
                            providers: [
                              BlocProvider(
                                create: (context) => ViewResponseDeckCubit(),
                              ),
                              BlocProvider(
                                create: (context) => ViewResponseCubit(),
                              )
                            ],
                            child: const ViewResponses(),
                          ))),
                ],
              ),
              GoRoute(
                name: 'choose-category',
                path: 'choose-category',
                pageBuilder: (context, state) => MaterialPage(
                    key: state.pageKey, child: const ChooseCategory()),
              ),
            ]),
      ]);
}
