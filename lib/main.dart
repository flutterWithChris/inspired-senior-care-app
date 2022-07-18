import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:get/get.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:inspired_senior_care_app/view/widget/bottom_app_bar.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});
  @override
  Widget build(BuildContext context) {
    return GetMaterialApp(
      title: 'Inspired Senior Care App',
      theme: ThemeData(
        elevatedButtonTheme: ElevatedButtonThemeData(
          style: ElevatedButton.styleFrom(
            minimumSize: const Size(35, 30),
          ),
        ),
        bottomSheetTheme:
            const BottomSheetThemeData(backgroundColor: Colors.white),
        textTheme: GoogleFonts.breeSerifTextTheme(),
        useMaterial3: true,
        colorSchemeSeed: Colors.lightBlue,
        // primarySwatch: Colors.blue,
      ),
      home: const MyHomePage(),
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
      splashColor: Colors.lightBlueAccent.withOpacity(0.8),
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
