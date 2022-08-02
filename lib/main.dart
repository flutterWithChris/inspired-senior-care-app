import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:go_router/go_router.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:inspired_senior_care_app/bloc/auth/auth_bloc.dart';
import 'package:inspired_senior_care_app/bloc/group/group_bloc.dart';
import 'package:inspired_senior_care_app/bloc/invite/invite_bloc.dart';
import 'package:inspired_senior_care_app/bloc/share_bloc/share_bloc.dart';
import 'package:inspired_senior_care_app/cubits/login/login_cubit.dart';
import 'package:inspired_senior_care_app/data/repositories/auth/auth_repository.dart';
import 'package:inspired_senior_care_app/firebase_options.dart';
import 'package:inspired_senior_care_app/router/routes.dart';
import 'package:inspired_senior_care_app/view/widget/bottom_app_bar.dart';
import 'package:inspired_senior_care_app/view/widget/top_app_bar.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp(options: DefaultFirebaseOptions.currentPlatform);
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});
  @override
  Widget build(BuildContext context) {
    return MultiRepositoryProvider(
      providers: [
        RepositoryProvider(
          create: (_) => AuthRepository(),
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
            create: (context) => ShareBloc(),
          ),
          BlocProvider(
            create: (context) => GroupBloc(),
          ),
        ],
        child: BlocBuilder<AuthBloc, AuthState>(
          builder: (context, state) {
            final GoRouter router = routes(context.read<AuthBloc>());
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

                colorSchemeSeed: Colors.purple,
                // primarySwatch: Colors.blue,
              ),
            );
          },
        ),
      ),
    );
  }
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
        drawer: Drawer(
          child: Center(
            child:
                Column(mainAxisAlignment: MainAxisAlignment.center, children: [
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
        ),
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
                  padding: EdgeInsets.only(top: 8.0, bottom: 16.0),
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
                        top: -25,
                        right: -20,
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
