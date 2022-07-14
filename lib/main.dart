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
        textTheme: GoogleFonts.breeSerifTextTheme(),
        useMaterial3: true,
        primarySwatch: Colors.blue,
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
          child: FittedBox(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: <Widget>[
                const Padding(
                  padding: EdgeInsets.all(8.0),
                  child: Text(
                    'Featured Category',
                    style: TextStyle(fontSize: 30),
                  ),
                ),
                Padding(
                  padding: const EdgeInsets.symmetric(vertical: 12.0),
                  child: InkWell(
                    splashColor: Colors.lightBlueAccent.withOpacity(0.8),
                    onTap: (() {}),
                    child: Card(
                      child: LayoutBuilder(
                        builder: (context, constraints) {
                          return ConstrainedBox(
                            constraints: BoxConstraints(
                                maxWidth:
                                    constraints.maxWidth > 700 ? 400 : 250),
                            child: Container(
                              decoration: BoxDecoration(
                                boxShadow: [
                                  BoxShadow(
                                    color: Colors.grey.withOpacity(0.35),
                                    offset: const Offset(0, 3),
                                    spreadRadius: 5,
                                    blurRadius: 7,
                                  )
                                ],
                              ),
                              child: Stack(
                                clipBehavior: Clip.none,
                                alignment: AlignmentDirectional.topEnd,
                                children: [
                                  SizedBox(
                                    child: Image.asset(
                                        'lib/assets/Supportive_Environment.png'),
                                  ),
                                  const Positioned(
                                    top: -20,
                                    right: -20,
                                    child: CircleAvatar(
                                      radius: 30,
                                      backgroundColor: Colors.white,
                                      child: CircleAvatar(
                                        radius: 25,
                                        backgroundColor: Colors.lightBlue,
                                        child: Text(
                                          '8/11',
                                          style: TextStyle(color: Colors.white),
                                        ),
                                      ),
                                    ),
                                  )
                                ],
                              ),
                            ),
                          );
                        },
                      ),
                    ),
                  ),
                ),
                Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: ElevatedButton(
                    onPressed: (() {}),
                    style: ElevatedButton.styleFrom(
                        fixedSize: const Size(200, 42)),
                    child: const Text('See More'),
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
