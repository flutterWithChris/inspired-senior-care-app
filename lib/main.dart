import 'dart:async';

import 'package:firebase_core/firebase_core.dart';
import 'package:firebase_crashlytics/firebase_crashlytics.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:inspired_senior_care_app/bloc/auth/auth_bloc.dart';
import 'package:inspired_senior_care_app/bloc/cards/card_bloc.dart';
import 'package:inspired_senior_care_app/bloc/categories/categories_bloc.dart';
import 'package:inspired_senior_care_app/bloc/comment_notifications/comment_notification_bloc.dart';
import 'package:inspired_senior_care_app/bloc/deck/deck_cubit.dart';
import 'package:inspired_senior_care_app/bloc/group/group_bloc.dart';
import 'package:inspired_senior_care_app/bloc/invite/invite_bloc.dart';
import 'package:inspired_senior_care_app/bloc/member/bloc/bloc/group_member_bloc.dart';
import 'package:inspired_senior_care_app/bloc/member/bloc/member_bloc.dart';
import 'package:inspired_senior_care_app/bloc/onboarding/onboarding_bloc.dart';
import 'package:inspired_senior_care_app/bloc/profile/profile_bloc.dart';
import 'package:inspired_senior_care_app/bloc/purchases/purchases_bloc.dart';
import 'package:inspired_senior_care_app/bloc/response_comment/response_comment_bloc.dart';
import 'package:inspired_senior_care_app/bloc/share_bloc/share_bloc.dart';
import 'package:inspired_senior_care_app/bloc/view_response/response_bloc.dart';
import 'package:inspired_senior_care_app/cubits/groups/featured_category_cubit.dart';
import 'package:inspired_senior_care_app/cubits/groups/group_featured_category_cubit.dart';
import 'package:inspired_senior_care_app/cubits/login/forgot_password_cubit.dart';
import 'package:inspired_senior_care_app/cubits/login/login_cubit.dart';
import 'package:inspired_senior_care_app/cubits/settings/cubit/settings_cubit.dart';
import 'package:inspired_senior_care_app/cubits/signup/signup_cubit.dart';
import 'package:inspired_senior_care_app/data/repositories/auth/auth_repository.dart';
import 'package:inspired_senior_care_app/data/repositories/database/database_repository.dart';
import 'package:inspired_senior_care_app/data/repositories/notifications/comment_notification_repository.dart';
import 'package:inspired_senior_care_app/data/repositories/purchases/purchases_repository.dart';
import 'package:inspired_senior_care_app/data/repositories/storage/storage_repository.dart';
import 'package:inspired_senior_care_app/firebase_options.dart';
import 'package:inspired_senior_care_app/globals.dart';
import 'package:inspired_senior_care_app/router/router.dart';
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
        RepositoryProvider(
          create: (context) => CommentNotificationRepository(),
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
              )..add(LoadProfile(
                  userId: context.read<AuthBloc>().state.user!.uid)),
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
                ..add(LoadGroups(
                    userId: context.read<AuthBloc>().state.user!.uid)),
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
                  commentNotificationRepository:
                      context.read<CommentNotificationRepository>(),
                  databaseRepository: context.read<DatabaseRepository>()),
            ),
            BlocProvider(
              create: (context) => DeckCubit(
                  profileBloc: context.read<ProfileBloc>(),
                  databaseRepository: context.read<DatabaseRepository>()),
            ),
            BlocProvider(
              create: (context) => CommentNotificationBloc(
                  authBloc: context.read<AuthBloc>(),
                  profileBloc: context.read<ProfileBloc>(),
                  cardBloc: context.read<CardBloc>(),
                  deckCubit: context.read<DeckCubit>(),
                  databaseRepository: context.read<DatabaseRepository>(),
                  commentNotificationRepository:
                      context.read<CommentNotificationRepository>())
                ..add(LoadCommentNotifications(
                    userId: context.read<AuthBloc>().state.user!.uid)),
            ),
          ],
          child: MaterialApp.router(
            debugShowCheckedModeBanner: false,
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
          )),
    );
  }

  late final StreamSubscription<dynamic> _subscription;

  @override
  void dispose() {
    _subscription.cancel();
    super.dispose();
  }
}
