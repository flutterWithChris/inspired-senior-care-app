import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:inspired_senior_care_app/bloc/invite/invite_bloc.dart';
import 'package:inspired_senior_care_app/bloc/share_bloc/share_bloc.dart';
import 'package:inspired_senior_care_app/router/routes.dart';
import 'package:inspired_senior_care_app/view/widget/bottom_app_bar.dart';

void main() {
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  MyRouter myRouter = MyRouter();
  MyApp({super.key});
  @override
  Widget build(BuildContext context) {
    return MultiBlocProvider(
      providers: [
        BlocProvider(
          create: (context) => InviteBloc(),
        ),
        BlocProvider(
          create: (context) => ShareBloc(),
        ),
      ],
      child: MaterialApp.router(
        routeInformationParser: myRouter.router.routeInformationParser,
        routerDelegate: myRouter.router.routerDelegate,
        routeInformationProvider: myRouter.router.routeInformationProvider,
        title: 'Inspired Senior Care App',
        theme: ThemeData(
          progressIndicatorTheme: ProgressIndicatorThemeData(
              circularTrackColor: Colors.grey.shade400),
          elevatedButtonTheme: ElevatedButtonThemeData(
            style: ElevatedButton.styleFrom(
              minimumSize: const Size(35, 30),
            ),
          ),
          bottomSheetTheme: BottomSheetThemeData(
              backgroundColor: Colors.white.withOpacity(0.9)),
          textTheme: GoogleFonts.breeSerifTextTheme(),
          useMaterial3: true,
          colorSchemeSeed: Colors.blue,
          // primarySwatch: Colors.blue,
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
    return Scaffold(
      bottomNavigationBar: const MainBottomAppBar(),
      appBar: AppBar(
        title: const Text('Inspired Senior Care'),
      ),
      body: Center(
        child: SafeArea(
          child: Column(
            //   mainAxisAlignment: MainAxisAlignment.center,
            children: <Widget>[
              const Padding(
                padding: EdgeInsets.all(24.0),
                child: Text(
                  'Featured Category',
                  style: TextStyle(fontSize: 28),
                ),
              ),
              const FeaturedCategory(),
              Padding(
                padding: const EdgeInsets.symmetric(vertical: 8.0),
                child: ElevatedButton(
                  onPressed: (() {}),
                  style:
                      ElevatedButton.styleFrom(fixedSize: const Size(200, 30)),
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
      onTap: (() {}),
      child: Card(
        child: LayoutBuilder(
          builder: (context, constraints) {
            return ConstrainedBox(
              constraints: BoxConstraints(
                  maxWidth: constraints.maxWidth > 700 ? 400 : 300),
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
                        top: -30,
                        right: -25,
                        child: CircleAvatar(
                          radius: 32,
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
