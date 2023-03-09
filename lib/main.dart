import 'dart:async';

import 'package:firebase_core/firebase_core.dart';
import 'package:firebase_crashlytics/firebase_crashlytics.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:inspired_senior_care_app/bloc/auth/auth_bloc.dart';
import 'package:inspired_senior_care_app/bloc/cards/card_bloc.dart';
import 'package:inspired_senior_care_app/bloc/categories/categories_bloc.dart';
import 'package:inspired_senior_care_app/bloc/deck/deck_cubit.dart';
import 'package:inspired_senior_care_app/bloc/group/group_bloc.dart';
import 'package:inspired_senior_care_app/bloc/invite/invite_bloc.dart';
import 'package:inspired_senior_care_app/bloc/manage/response_interaction_cubit.dart';
import 'package:inspired_senior_care_app/bloc/manage/view_response_deck_cubit.dart';
import 'package:inspired_senior_care_app/bloc/member/bloc/bloc/group_member_bloc.dart';
import 'package:inspired_senior_care_app/bloc/member/bloc/member_bloc.dart';
import 'package:inspired_senior_care_app/bloc/onboarding/onboarding_bloc.dart';
import 'package:inspired_senior_care_app/bloc/profile/profile_bloc.dart';
import 'package:inspired_senior_care_app/bloc/purchases/purchases_bloc.dart';
import 'package:inspired_senior_care_app/bloc/response_comment/response_comment_bloc.dart';
import 'package:inspired_senior_care_app/bloc/share_bloc/share_bloc.dart';
import 'package:inspired_senior_care_app/bloc/view_response/response_bloc.dart';
import 'package:inspired_senior_care_app/bloc/view_response/view_response_cubit.dart';
import 'package:inspired_senior_care_app/cubits/groups/featured_category_cubit.dart';
import 'package:inspired_senior_care_app/cubits/groups/group_featured_category_cubit.dart';
import 'package:inspired_senior_care_app/cubits/login/forgot_password_cubit.dart';
import 'package:inspired_senior_care_app/cubits/login/login_cubit.dart';
import 'package:inspired_senior_care_app/cubits/response/response_deck_cubit.dart';
import 'package:inspired_senior_care_app/cubits/settings/cubit/settings_cubit.dart';
import 'package:inspired_senior_care_app/cubits/signup/signup_cubit.dart';
import 'package:inspired_senior_care_app/data/models/category.dart';
import 'package:inspired_senior_care_app/data/repositories/auth/auth_repository.dart';
import 'package:inspired_senior_care_app/data/repositories/database/database_repository.dart';
import 'package:inspired_senior_care_app/data/repositories/purchases/purchases_repository.dart';
import 'package:inspired_senior_care_app/data/repositories/storage/storage_repository.dart';
import 'package:inspired_senior_care_app/firebase_options.dart';
import 'package:inspired_senior_care_app/globals.dart';
import 'package:inspired_senior_care_app/view/pages/dashboard/dashboard.dart';
import 'package:inspired_senior_care_app/view/pages/dashboard/groups/choose_category.dart';
import 'package:inspired_senior_care_app/view/pages/dashboard/members/view_member.dart';
import 'package:inspired_senior_care_app/view/pages/dashboard/members/view_members.dart';
import 'package:inspired_senior_care_app/view/pages/dashboard/members/view_responses/view_responses.dart';
import 'package:inspired_senior_care_app/view/pages/login/login.dart';
import 'package:inspired_senior_care_app/view/pages/main/categories.dart';
import 'package:inspired_senior_care_app/view/pages/main/deck_page.dart';
import 'package:inspired_senior_care_app/view/pages/main/homepage.dart';
import 'package:inspired_senior_care_app/view/pages/main/manager_categories.dart';
import 'package:inspired_senior_care_app/view/pages/main/manager_categories_share.dart';
import 'package:inspired_senior_care_app/view/pages/main/manager_deck_page.dart';
import 'package:inspired_senior_care_app/view/pages/main/manager_share_deck_page.dart';
import 'package:inspired_senior_care_app/view/pages/main/profile.dart';
import 'package:inspired_senior_care_app/view/pages/signup/signup.dart';
import 'package:inspired_senior_care_app/view/pages/subscriptions.dart';
import 'package:inspired_senior_care_app/view/widget/main/settings.dart';
import 'package:shared_preferences/shared_preferences.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp(options: DefaultFirebaseOptions.currentPlatform);
  SharedPreferences prefs = await SharedPreferences.getInstance();
  var initScreen = prefs.getInt("initScreen");

  // await prefs.remove('initScreen');
  // print('initScreen $initScreen');
  // Pass all uncaught errors from the framework to Crashlytics.
  // TODO: Uncomment this line to enable Crashlytics in your application.
  FlutterError.onError = FirebaseCrashlytics.instance.recordFlutterFatalError;

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
  @override
  Widget build(BuildContext context) {
    return MultiRepositoryProvider(
      providers: [
        RepositoryProvider(
          create: (context) => AuthRepository(),
        ),
        RepositoryProvider(
          // lazy: false,
          create: (context) => PurchasesRepository()..initPlatformState(),
        ),
        RepositoryProvider(
          create: (context) => DatabaseRepository(),
        ),
        RepositoryProvider(
          create: (context) => StorageRepository(),
        ),
      ],
      child: MultiBlocProvider(
        providers: [
          BlocProvider(
            create: (context) => AuthBloc(
                purchasesRepository: context.read<PurchasesRepository>(),
                authRepository: context.read<AuthRepository>()),
          ),
          BlocProvider(
            create: (context) => ProfileBloc(
              purchasesRepository: context.read<PurchasesRepository>(),
              authBloc: context.read<AuthBloc>(),
              databaseRepository: context.read<DatabaseRepository>(),
            )..add(
                LoadProfile(userId: context.read<AuthBloc>().state.user!.uid)),
          ),
          BlocProvider(
              create: (context) =>
                  LoginCubit(authRepository: context.read<AuthRepository>())),
          BlocProvider(
              create: (context) => PurchasesBloc(
                  profileBloc: context.read<ProfileBloc>(),
                  databaseRepository: context.read<DatabaseRepository>(),
                  authBloc: context.read<AuthBloc>(),
                  purchasesRepository: context.read<PurchasesRepository>())
                ..add(LoadPurchases())),
          BlocProvider(
            create: (context) => ShareBloc(
                databaseRepository: context.read<DatabaseRepository>()),
          ),
          BlocProvider(
            create: (context) => CategoriesBloc(
                profileBloc: context.read<ProfileBloc>(),
                databaseRepository: context.read<DatabaseRepository>(),
                storageRepository: context.read<StorageRepository>())
              ..add(LoadCategories()),
          ),
          BlocProvider(
            create: (context) => InviteBloc(
                authBloc: context.read<AuthBloc>(),
                profileBloc: context.read<ProfileBloc>(),
                authRepository: context.read<AuthRepository>(),
                databaseRepository: context.read<DatabaseRepository>()),
          ),
          BlocProvider(
            create: (context) => GroupBloc(
                profileBloc: context.read<ProfileBloc>(),
                inviteBloc: context.read<InviteBloc>(),
                authBloc: context.read<AuthBloc>(),
                databaseRepository: context.read<DatabaseRepository>())
              ..add(
                  LoadGroups(userId: context.read<AuthBloc>().state.user!.uid)),
          ),
          BlocProvider(
            create: (context) => GroupMemberBloc(
                inviteBloc: context.read<InviteBloc>(),
                databaseRepository: context.read<DatabaseRepository>()),
          ),
          BlocProvider(
            create: (context) => GroupFeaturedCategoryCubit(
                databaseRepository: context.read<DatabaseRepository>()),
          ),
          BlocProvider(
            create: (context) => FeaturedCategoryCubit(
                groupFeaturedCategoryCubit:
                    context.read<GroupFeaturedCategoryCubit>(),
                authBloc: context.read<AuthBloc>(),
                profileBloc: context.read<ProfileBloc>(),
                categoriesBloc: context.read<CategoriesBloc>(),
                databaseRepository: context.read<DatabaseRepository>())
              ..loadUserFeaturedCategory(),
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
            create: (context) => SettingsCubit(
                databaseRepository: context.read<DatabaseRepository>(),
                authRepository: context.read<AuthRepository>(),
                profileBloc: context.read<ProfileBloc>()),
          ),
          BlocProvider(
            create: (context) =>
                SignupCubit(authRepository: context.read<AuthRepository>()),
          ),
          BlocProvider(
            create: (context) => ForgotPasswordCubit(
                authRepository: context.read<AuthRepository>()),
          ),
          BlocProvider(
            create: (context) => ResponseBloc(
                databaseRepository: context.read<DatabaseRepository>()),
          ),
          BlocProvider(
            create: (context) => ResponseCommentBloc(
                databaseRepository: context.read<DatabaseRepository>()),
          ),
          BlocProvider(
            create: (context) => DeckCubit(
                profileBloc: context.read<ProfileBloc>(),
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
                  scaffoldBackgroundColor: Colors.grey.shade100,
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
                      minimumSize: const Size(25, 30),
                    ),
                  ),
                  outlinedButtonTheme: OutlinedButtonThemeData(
                    style: OutlinedButton.styleFrom(
                      shape: const StadiumBorder(),
                      fixedSize: const Size(200, 30),
                      minimumSize: const Size(25, 30),
                    ),
                  ),
                  bottomSheetTheme: const BottomSheetThemeData(
                      backgroundColor: Colors.transparent),
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
    // urlPathStrategy: UrlPathStrategy.path,
    debugLogDiagnostics: true,
    // errorPageBuilder: ,
    refreshListenable: GoRouterRefreshStream(bloc.stream),
    redirect: (context, state) async {
      SharedPreferences prefs = await SharedPreferences.getInstance();
      int? initScreen = prefs.getInt("initScreen");
      bool isLoggingIn = state.location == '/login';
      bool loggedIn = bloc.state.authStatus == AuthStatus.authenticated;
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
            builder: (context, state) => DeckPage(
              category: state.extra as Category,
            ),
          ),
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
                                  create: (context) =>
                                      ResponseInteractionCubit(),
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
}

class GoRouterRefreshStream extends ChangeNotifier {
  GoRouterRefreshStream(Stream<dynamic> stream) {
    notifyListeners();
    _subscription = stream.asBroadcastStream().listen(
          (dynamic _) => notifyListeners(),
        );
  }

  late final StreamSubscription<dynamic> _subscription;

  @override
  void dispose() {
    _subscription.cancel();
    super.dispose();
  }
}
