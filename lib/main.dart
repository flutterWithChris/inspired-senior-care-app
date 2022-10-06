import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:inspired_senior_care_app/bloc/auth/auth_bloc.dart';
import 'package:inspired_senior_care_app/bloc/cards/card_bloc.dart';
import 'package:inspired_senior_care_app/bloc/categories/categories_bloc.dart';
import 'package:inspired_senior_care_app/bloc/deck/deck_cubit.dart';
import 'package:inspired_senior_care_app/bloc/group/group_bloc.dart';
import 'package:inspired_senior_care_app/bloc/manage/response_interaction_cubit.dart';
import 'package:inspired_senior_care_app/bloc/manage/view_response_deck_cubit.dart';
import 'package:inspired_senior_care_app/bloc/member/bloc/bloc/group_member_bloc.dart';
import 'package:inspired_senior_care_app/bloc/member/bloc/member_bloc.dart';
import 'package:inspired_senior_care_app/bloc/onboarding/onboarding_bloc.dart';
import 'package:inspired_senior_care_app/bloc/profile/profile_bloc.dart';
import 'package:inspired_senior_care_app/bloc/share_bloc/share_bloc.dart';
import 'package:inspired_senior_care_app/bloc/view_response/response_bloc.dart';
import 'package:inspired_senior_care_app/bloc/view_response/view_response_cubit.dart';
import 'package:inspired_senior_care_app/cubits/groups/featured_category_cubit.dart';
import 'package:inspired_senior_care_app/cubits/login/login_cubit.dart';
import 'package:inspired_senior_care_app/cubits/response/response_deck_cubit.dart';
import 'package:inspired_senior_care_app/cubits/settings/cubit/settings_cubit.dart';
import 'package:inspired_senior_care_app/cubits/signup/signup_cubit.dart';
import 'package:inspired_senior_care_app/data/repositories/auth/auth_repository.dart';
import 'package:inspired_senior_care_app/data/repositories/database/database_repository.dart';
import 'package:inspired_senior_care_app/data/repositories/storage/storage_repository.dart';
import 'package:inspired_senior_care_app/firebase_options.dart';
import 'package:inspired_senior_care_app/globals.dart';
import 'package:inspired_senior_care_app/view/pages/dashboard/groups/choose_category.dart';
import 'package:inspired_senior_care_app/view/pages/dashboard/dashboard.dart';
import 'package:inspired_senior_care_app/view/pages/dashboard/members/view_members.dart';
import 'package:inspired_senior_care_app/view/pages/dashboard/members/view_responses/view_responses.dart';
import 'package:inspired_senior_care_app/view/pages/dashboard/members/view_member.dart';
import 'package:inspired_senior_care_app/view/pages/login/login.dart';
import 'package:inspired_senior_care_app/view/pages/main/categories.dart';
import 'package:inspired_senior_care_app/view/pages/main/deck_page.dart';
import 'package:inspired_senior_care_app/view/pages/main/homepage.dart';
import 'package:inspired_senior_care_app/view/pages/main/manager_categories.dart';
import 'package:inspired_senior_care_app/view/pages/main/manager_deck_page.dart';
import 'package:inspired_senior_care_app/view/pages/main/profile.dart';
import 'package:inspired_senior_care_app/view/pages/signup/signup.dart';
import 'package:inspired_senior_care_app/view/widget/main/settings.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp(options: DefaultFirebaseOptions.currentPlatform);
  runApp(const MyApp());
}

class MyApp extends StatefulWidget {
  const MyApp({
    Key? key,
  }) : super(key: key);

  @override
  State<MyApp> createState() => _MyAppState();
}

class _MyAppState extends State<MyApp> {
  late AuthBloc bloc;
  late OnboardingBloc _onboardingBloc;

  @override
  void initState() {
    // TODO: implement initState

    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return MultiRepositoryProvider(
      providers: [
        RepositoryProvider(
          // lazy: false,
          create: (context) => AuthRepository(),
        ),
        RepositoryProvider(
          // lazy: false,
          create: (context) => DatabaseRepository(),
        ),
        RepositoryProvider(
          create: (context) => StorageRepository(),
        ),
      ],
      child: MultiBlocProvider(
        providers: [
          BlocProvider(
            create: (context) =>
                AuthBloc(authRepository: context.read<AuthRepository>()),
          ),
          BlocProvider(
            create: (context) => ProfileBloc(
              authBloc: context.read<AuthBloc>(),
              databaseRepository: context.read<DatabaseRepository>(),
            )..add(
                LoadProfile(userId: context.read<AuthBloc>().state.user.id!)),
          ),
          BlocProvider(
              create: (context) =>
                  LoginCubit(authRepository: context.read<AuthRepository>())),
          BlocProvider(
            create: (context) => ShareBloc(
                databaseRepository: context.read<DatabaseRepository>()),
          ),
          BlocProvider(
            create: (context) => CategoriesBloc(
                databaseRepository: context.read<DatabaseRepository>(),
                storageRepository: context.read<StorageRepository>())
              ..add(LoadCategories()),
          ),
          BlocProvider(
            create: (context) => GroupBloc(
                databaseRepository: context.read<DatabaseRepository>())
              ..add(LoadGroups(
                  currentUser: context.read<ProfileBloc>().state.user)),
          ),
          BlocProvider(
            create: (context) => GroupMemberBloc(
                databaseRepository: context.read<DatabaseRepository>()),
          ),
          BlocProvider(
            create: (context) => FeaturedCategoryCubit(
                categoriesBloc: context.read<CategoriesBloc>(),
                databaseRepository: context.read<DatabaseRepository>())
              ..loadUserFeaturedCategory(
                  context.read<ProfileBloc>().state.user),
          ),
          BlocProvider(
            create: (context) => MemberBloc(
                databaseRepository: context.read<DatabaseRepository>()),
          ),
          BlocProvider(
              create: (context) => CardBloc(
                  databaseRepository: context.read<DatabaseRepository>(),
                  storageRepository: context.read<StorageRepository>())),
          BlocProvider(
            create: (context) => OnboardingBloc(
                databaseRepository: context.read<DatabaseRepository>(),
                storageRepository: context.read<StorageRepository>()),
          ),
          BlocProvider(
            create: (context) =>
                SignupCubit(authRepository: context.read<AuthRepository>()),
          ),
          BlocProvider(
            create: (context) => ResponseBloc(
                databaseRepository: context.read<DatabaseRepository>()),
          ),
          BlocProvider(
            create: (context) => DeckCubit(
                databaseRepository: context.read<DatabaseRepository>()),
          ),
        ],
        child: BlocBuilder<AuthBloc, AuthState>(
          builder: (context, state) {
            bloc = context.read<AuthBloc>();
            return MaterialApp.router(
              scaffoldMessengerKey: snackbarKey,
              routeInformationParser: router.routeInformationParser,
              routerDelegate: router.routerDelegate,
              routeInformationProvider: router.routeInformationProvider,
              title: 'Inspired Senior Care App',
              theme: ThemeData(
                  scaffoldBackgroundColor: Colors.grey.shade200,
                  inputDecorationTheme: InputDecorationTheme(
                    filled: true,
                    fillColor: Colors.white,
                    border: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(25)),
                  ),
                  progressIndicatorTheme: ProgressIndicatorThemeData(
                      circularTrackColor: Colors.grey.shade400),
                  elevatedButtonTheme: ElevatedButtonThemeData(
                    style: ElevatedButton.styleFrom(
                      shape: const StadiumBorder(),
                      fixedSize: const Size(200, 30),
                      minimumSize: const Size(35, 30),
                    ),
                  ),
                  bottomSheetTheme:
                      const BottomSheetThemeData(backgroundColor: Colors.white),
                  textTheme: GoogleFonts.breeSerifTextTheme(),
                  //  useMaterial3: true,

                  primaryColor: const Color(0xffC27A63)),
            );
          },
        ),
      ),
    );
  }

  late final router = GoRouter(
    routes: _routes,
    //  routerNeglect: true,
    initialLocation: '/',
    urlPathStrategy: UrlPathStrategy.path,
    debugLogDiagnostics: true,
    // errorPageBuilder: ,
    refreshListenable: GoRouterRefreshStream(bloc.stream),
    redirect: (state) {
      bool isLoggingIn = state.location == '/login';
      bool loggedIn = bloc.state.authStatus == AuthStatus.authenticated;
      bool isOnboarding = state.location == '/login/signup';
      // TODO: Create Onboarding Completed SharedPrefs Value ***
      bool completedOnboarding = false;
      // if (!completedOnboarding) return '/login/signup';
      if (!loggedIn) {
        return isLoggingIn
            ? null
            : isOnboarding
                ? null
                : '/login';
      }

      final isLoggedIn = state.location == '/';
      //  if (!completedOnboarding) return '/login/signup';
      if (loggedIn && completedOnboarding == false) return null;
      if (loggedIn && isLoggingIn) return isLoggedIn ? null : '/';
      if (loggedIn && isOnboarding) return isLoggedIn ? null : '/';

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
        name: 'home',
        path: '/',
        builder: (context, state) => const MyHomePage(),
        routes: [
          GoRoute(
            name: 'settings',
            path: 'settings',
            builder: (context, state) => BlocProvider(
              create: (context) =>
                  EditPassCubit(authRepository: context.read<AuthRepository>()),
              child: const SettingsPage(),
            ),
          ),
        ]),
    GoRoute(
        name: 'categories',
        path: '/categories',
        builder: (context, state) => const Categories(),
        routes: [
          GoRoute(
            name: 'deck-page',
            path: 'deck-page',
            builder: (context, state) => DeckPage(),
          ),
        ]),
    GoRoute(
        name: 'manager-categories',
        path: '/manager-categories',
        builder: (context, state) => const ManagerCategories(),
        routes: [
          GoRoute(
            name: 'manager-deck-page',
            path: 'manager-deck-page',
            builder: (context, state) => ManagerDeckPage(),
          ),
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
                                  create: (context) =>
                                      ResponseInteractionCubit(),
                                ),
                              ],
                              child: ViewResponses(),
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
}
