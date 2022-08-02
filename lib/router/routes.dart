import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';
import 'package:inspired_senior_care_app/bloc/auth/auth_bloc.dart';
import 'package:inspired_senior_care_app/bloc/deck/deck_cubit.dart';
import 'package:inspired_senior_care_app/bloc/manage/view_response_deck_cubit.dart';
import 'package:inspired_senior_care_app/bloc/onboarding/onboarding_bloc.dart';
import 'package:inspired_senior_care_app/bloc/view_response/view_response_cubit.dart';
import 'package:inspired_senior_care_app/cubits/signup/signup_cubit.dart';
import 'package:inspired_senior_care_app/data/repositories/auth/auth_repository.dart';
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

GoRouter routes(AuthBloc bloc) {
  return GoRouter(
      //  routerNeglect: true,
      initialLocation: '/',
      urlPathStrategy: UrlPathStrategy.path,
      debugLogDiagnostics: true,
      // errorPageBuilder: ,
      refreshListenable: GoRouterRefreshStream(bloc.stream),
      redirect: (state) {
        bool isLoggingIn = state.location == '/login';
        bool loggedIn = bloc.state.authStatus == AuthStatus.authenticated;
        bool isOnboarding = state.location == '/signup';

        if (!loggedIn) {
          return isLoggingIn
              ? null
              : isOnboarding
                  ? null
                  : '/login';
        }

        final isLoggedIn = state.location == '/';

        if (loggedIn && isLoggingIn) return isLoggedIn ? null : '/';
        if (loggedIn && isOnboarding) return isLoggedIn ? null : '/';

        return null;
      },
      routes: [
        GoRoute(
          name: 'login',
          path: '/login',
          builder: (context, state) => const LoginScreen(),
        ),
        GoRoute(
            name: 'signup',
            path: '/signup',
            builder: (context, state) => MultiBlocProvider(
                  providers: [
                    BlocProvider(
                      create: (context) => OnboardingBloc(),
                    ),
                    BlocProvider(
                      create: (context) => SignupCubit(
                          authRepository: context.read<AuthRepository>()),
                    ),
                  ],
                  child: const SignupScreen(),
                )),
        GoRoute(
          name: 'home',
          path: '/',
          builder: (context, state) => const MyHomePage(),
        ),
        GoRoute(
            name: 'categories',
            path: '/categories',
            builder: (context, state) => const Categories(),
            routes: [
              GoRoute(
                  name: 'deck-page',
                  path: 'deck-page',
                  builder: (context, state) => BlocProvider(
                        create: (context) => DeckCubit(),
                        child: DeckPage(),
                      )),
            ]),
        GoRoute(
          name: 'profile',
          path: '/profile',
          builder: (context, state) => const Profile(),
        ),
        GoRoute(
            name: 'dashboard',
            path: '/dashboard',
            builder: (context, state) => const Dashboard(),
            routes: [
              GoRoute(
                name: 'view-member',
                path: 'view-member',
                builder: (context, state) => const ViewMember(),
                routes: [
                  GoRoute(
                      name: 'view-responses',
                      path: 'view-responses',
                      builder: (context, state) => MultiBlocProvider(
                            providers: [
                              BlocProvider(
                                create: (context) => ViewResponseDeckCubit(),
                              ),
                              BlocProvider(
                                create: (context) => ViewResponseCubit(),
                              )
                            ],
                            child: const ViewResponses(),
                          )),
                ],
              ),
              GoRoute(
                name: 'choose-category',
                path: 'choose-category',
                builder: (context, state) => const ChooseCategory(),
              ),
            ]),
      ]);
}
