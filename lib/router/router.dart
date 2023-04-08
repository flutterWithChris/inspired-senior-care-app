import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';
import 'package:inspired_senior_care_app/bloc/auth/auth_bloc.dart';
import 'package:inspired_senior_care_app/bloc/manage/view_response_deck_cubit.dart';
import 'package:inspired_senior_care_app/view/pages/main/manager_categories.dart';
import 'package:inspired_senior_care_app/view/pages/main/profile.dart';
import 'package:shared_preferences/shared_preferences.dart';

import '../bloc/manage/response_interaction_cubit.dart';
import '../bloc/view_response/view_response_cubit.dart';
import '../cubits/response/response_deck_cubit.dart';
import '../data/models/category.dart';
import '../globals.dart';
import '../view/pages/dashboard/dashboard.dart';
import '../view/pages/dashboard/groups/choose_category.dart';
import '../view/pages/dashboard/members/view_member.dart';
import '../view/pages/dashboard/members/view_members.dart';
import '../view/pages/dashboard/members/view_responses/view_responses.dart';
import '../view/pages/login/login.dart';
import '../view/pages/main/categories.dart';
import '../view/pages/main/deck_page.dart';
import '../view/pages/main/homepage.dart';
import '../view/pages/main/manager_categories_share.dart';
import '../view/pages/main/manager_deck_page.dart';
import '../view/pages/main/manager_share_deck_page.dart';
import '../view/pages/signup/signup.dart';
import '../view/pages/subscriptions.dart';
import '../view/widget/main/settings.dart';

GoRouter router = GoRouter(
  routes: _routes,
  //  routerNeglect: true,
  initialLocation: '/',
  // urlPathStrategy: UrlPathStrategy.path,
  debugLogDiagnostics: true,
  // errorPageBuilder: ,
  // refreshListenable: GoRouterRefreshStream(bloc.stream),
  redirect: (context, state) async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    int? initScreen = prefs.getInt("initScreen");
    bool isLoggingIn = state.location == '/login';
    bool loggedIn =
        context.read<AuthBloc>().state.authStatus == AuthStatus.authenticated;
    bool isOnboarding = state.location == '/login/signup';
    // TODO: Create Onboarding Completed SharedPrefs Value ***
    bool completedOnboarding = initScreen == 1;

    if (!loggedIn) {
      return isLoggingIn
          ? completedOnboarding
              ? null
              : '/login/signup'
          : isOnboarding
              ? null
              : '/login';
    }

    final isLoggedIn = state.location == '/';

    if (loggedIn && isLoggingIn) return isLoggedIn ? null : '/';

    return null;
  },
);
final List<GoRoute> _routes = [
  GoRoute(
      name: 'login',
      path: '/login',
      builder: (context, state) => const LoginScreen(),
      routes: [
        GoRoute(
          name: 'signup',
          path: 'signup',
          builder: (context, state) => const SignupScreen(),
        ),
      ]),
  GoRoute(
    name: 'settings',
    path: '/settings',
    builder: (context, state) => const SettingsPage(),
  ),
  GoRoute(
      name: 'home',
      path: '/',
      builder: (context, state) {
        Globals().index = 1;
        return const MyHomePage();
      },
      routes: const []),
  GoRoute(
      name: 'categories',
      path: '/categories',
      builder: (context, state) {
        Globals().index = 0;
        return const Categories();
      },
      routes: [
        GoRoute(
            name: 'deck-page',
            path: 'deck-page',
            builder: (context, state) {
              return DeckPage(
                category: state.extra as Category,
              );
            }),
      ]),
  GoRoute(
      name: 'manager-categories',
      path: '/manager-categories',
      builder: (context, state) {
        Globals().index = 0;
        return const ManagerCategories();
      },
      routes: [
        GoRoute(
          name: 'manager-deck-page',
          path: 'manager-deck-page',
          builder: (context, state) => const ManagerDeckPage(),
        ),
      ]),
  GoRoute(
      name: 'manager-categories-share',
      path: '/manager-categories-share',
      builder: (context, state) {
        Globals().index = 0;
        return const ManagerCategoriesShare();
      },
      routes: [
        GoRoute(
          name: 'manager-share-deck-page',
          path: 'manager-share-deck-page',
          builder: (context, state) => ManagerShareDeckPage(
            category: state.extra as Category,
          ),
        ),
      ]),
  GoRoute(
    name: 'profile',
    path: '/profile',
    builder: (context, state) {
      Globals().index = 2;
      return const Profile();
    },
  ),
  GoRoute(
    name: 'subscriptions',
    path: '/subscriptions',
    builder: (context, state) => const SubscriptionsPage(),
  ),
  GoRoute(
      name: 'dashboard',
      path: '/dashboard',
      builder: (context, state) {
        Globals().index = 2;
        return const Dashboard();
      },
      routes: [
        GoRoute(
            name: 'view-group-members',
            path: 'view-group-members',
            builder: ((context, state) => const ViewMembers()),
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
                                create: (context) => ResponseDeckCubit(),
                              ),
                              BlocProvider(
                                create: (context) => ViewResponseCubit(),
                              ),
                              BlocProvider(
                                create: (context) => ResponseInteractionCubit(),
                              ),
                            ],
                            child: const ViewResponses(),
                          )),
                ],
              ),
            ]),
        GoRoute(
          name: 'choose-category',
          path: 'choose-category',
          builder: (context, state) => const ChooseCategory(),
        ),
      ]),
];
