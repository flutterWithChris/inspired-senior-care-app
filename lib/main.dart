import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:go_router/go_router.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:inspired_senior_care_app/bloc/auth/auth_bloc.dart';
import 'package:inspired_senior_care_app/bloc/cards/card_bloc.dart';
import 'package:inspired_senior_care_app/bloc/categories/categories_bloc.dart';
import 'package:inspired_senior_care_app/bloc/deck/deck_cubit.dart';
import 'package:inspired_senior_care_app/bloc/group/group_bloc.dart';
import 'package:inspired_senior_care_app/bloc/invite/invite_bloc.dart';
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
import 'package:inspired_senior_care_app/cubits/signup/signup_cubit.dart';
import 'package:inspired_senior_care_app/data/repositories/auth/auth_repository.dart';
import 'package:inspired_senior_care_app/data/repositories/database/database_repository.dart';
import 'package:inspired_senior_care_app/data/repositories/storage/storage_repository.dart';
import 'package:inspired_senior_care_app/firebase_options.dart';
import 'package:inspired_senior_care_app/view/pages/categories.dart';
import 'package:inspired_senior_care_app/view/pages/dashboard/choose_category.dart';
import 'package:inspired_senior_care_app/view/pages/dashboard/dashboard.dart';
import 'package:inspired_senior_care_app/view/pages/dashboard/members/view_members.dart';
import 'package:inspired_senior_care_app/view/pages/dashboard/members/view_responses.dart';
import 'package:inspired_senior_care_app/view/pages/dashboard/view_member.dart';
import 'package:inspired_senior_care_app/view/pages/deck_page.dart';
import 'package:inspired_senior_care_app/view/pages/login/login.dart';
import 'package:inspired_senior_care_app/view/pages/profile.dart';
import 'package:inspired_senior_care_app/view/pages/signup/signup.dart';
import 'package:inspired_senior_care_app/view/widget/bottom_app_bar.dart';
import 'package:inspired_senior_care_app/view/widget/top_app_bar.dart';

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
          create: (context) => AuthRepository(),
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
            create: (context) =>
                AuthBloc(authRepository: context.read<AuthRepository>()),
          ),
          BlocProvider(
              create: (context) =>
                  LoginCubit(authRepository: context.read<AuthRepository>())),
          BlocProvider(
            create: (context) => InviteBloc(),
          ),
          BlocProvider(
            lazy: false,
            create: (context) => ProfileBloc(
              authBloc: context.read<AuthBloc>(),
              databaseRepository: context.read<DatabaseRepository>(),
            )..add(
                LoadProfile(userId: context.read<AuthBloc>().state.user.id!)),
          ),
          BlocProvider(
            create: (context) => ShareBloc(
                databaseRepository: context.read<DatabaseRepository>()),
          ),
          BlocProvider(
            lazy: false,
            create: (context) => CategoriesBloc(
                databaseRepository: context.read<DatabaseRepository>(),
                storageRepository: context.read<StorageRepository>())
              ..add(LoadCategories()),
          ),
          BlocProvider(
            lazy: false,
            create: (context) => GroupBloc(
                databaseRepository: context.read<DatabaseRepository>()),
          ),
          BlocProvider(
            create: (context) => GroupMemberBloc(
                databaseRepository: context.read<DatabaseRepository>()),
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
            create: (context) => FeaturedCategoryCubit(
                databaseRepository: context.read<DatabaseRepository>()),
          ),
        ],
        child: BlocBuilder<AuthBloc, AuthState>(
          builder: (context, state) {
            bloc = context.read<AuthBloc>();
            return MaterialApp.router(
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
      bool isOnboarding = state.location == '/signup';
      bool completedOnboarding = true;

      if (!loggedIn) {
        return isLoggingIn
            ? null
            : isOnboarding
                ? null
                : '/login';
      }

      final isLoggedIn = state.location == '/';

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
    ),
    GoRoute(
      name: 'signup',
      path: '/signup',
      builder: (context, state) => const SignupScreen(),
    ),
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
              builder: (context, state) => MultiBlocProvider(
                    providers: [
                      BlocProvider(
                        create: (context) => DeckCubit(
                            databaseRepository:
                                context.read<DatabaseRepository>()),
                      ),
                    ],
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
                                  create: (context) => ViewResponseCubit(),
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

class MyHomePage extends StatefulWidget {
  const MyHomePage({super.key});

  @override
  State<MyHomePage> createState() => _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage> {
  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Scaffold(
        drawer: const ManagerAppDrawer(),
        bottomNavigationBar: const MainBottomAppBar(),
        appBar: const PreferredSize(
          preferredSize: Size.fromHeight(50),
          child: MainTopAppBar(),
        ),
        body: Center(
          child: SafeArea(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: <Widget>[
                const Padding(
                  padding: EdgeInsets.only(bottom: 24.0),
                  child: Text(
                    'Featured Category',
                    style: TextStyle(fontSize: 30),
                  ),
                ),
                const FeaturedCategory(),
                Padding(
                  padding: const EdgeInsets.symmetric(vertical: 8.0),
                  child: ElevatedButton(
                    onPressed: (() {
                      context.goNamed('deck-page');
                    }),
                    style: ElevatedButton.styleFrom(
                        fixedSize: const Size(200, 30)),
                    child: const Text(
                      'See More',
                      style: TextStyle(fontSize: 16),
                    ),
                  ),
                ),
                const Icon(FontAwesomeIcons.chevronDown),
              ],
            ),
          ),
        ),
      ),
    );
  }
}

class ManagerAppDrawer extends StatelessWidget {
  const ManagerAppDrawer({
    Key? key,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Drawer(
      child: Center(
        child: Column(mainAxisAlignment: MainAxisAlignment.center, children: [
          Text(
            'Settings',
            style: Theme.of(context).textTheme.titleMedium,
          ),
          TextButton(
              onPressed: () => context.goNamed('profile'),
              child: Text(
                'Profile',
                style: Theme.of(context).textTheme.titleMedium,
              )),
          TextButton.icon(
              onPressed: () {
                context.read<LoginCubit>().signOut();
              },
              icon: const Icon(Icons.logout_rounded),
              label: const Text('Logout'))
        ]),
      ),
    );
  }
}

class FeaturedCategory extends StatelessWidget {
  const FeaturedCategory({
    Key? key,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return InkWell(
      splashColor: Colors.lightBlueAccent,
      onTap: (() {
        context.goNamed('deck-page');
      }),
      child: Card(
        child: LayoutBuilder(
          builder: (context, constraints) {
            return ConstrainedBox(
              constraints: BoxConstraints(
                  maxWidth: constraints.maxWidth > 700 ? 350 : 275),
              child: Container(
                color: Colors.white,
                child: Padding(
                  padding: const EdgeInsets.all(12.0),
                  child: Stack(
                    clipBehavior: Clip.none,
                    alignment: AlignmentDirectional.topEnd,
                    children: [
                      SizedBox(
                        child: Image.asset(
                            'lib/assets/Supportive_Environment.png'),
                      ),
                      const Positioned(
                        top: -35,
                        right: -25,
                        child: CircleAvatar(
                          radius: 30,
                          backgroundColor: Colors.white,
                          child: CircleAvatar(
                            radius: 25,
                            backgroundColor: Colors.lightBlue,
                            child: Text(
                              '8/11',
                              style: TextStyle(
                                  color: Colors.white,
                                  fontSize: 18,
                                  fontWeight: FontWeight.bold),
                            ),
                          ),
                        ),
                      )
                    ],
                  ),
                ),
              ),
            );
          },
        ),
      ),
    );
  }
}
