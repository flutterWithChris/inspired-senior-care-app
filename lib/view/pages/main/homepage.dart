import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:inspired_senior_care_app/view/widget/featured_category.dart';
import 'package:inspired_senior_care_app/view/widget/main/bottom_app_bar.dart';
import 'package:inspired_senior_care_app/view/widget/main/main_app_drawer.dart';
import 'package:inspired_senior_care_app/view/widget/main/top_app_bar.dart';

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
        drawer: const MainAppDrawer(),
        bottomNavigationBar: const MainBottomAppBar(),
        appBar: const PreferredSize(
          preferredSize: Size.fromHeight(60),
          child: MainTopAppBar(),
        ),
        body: Center(
          child: SafeArea(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: const <Widget>[
                Padding(
                  padding: EdgeInsets.only(bottom: 24.0),
                  child: Text(
                    'Featured Category',
                    style: TextStyle(fontSize: 30),
                  ),
                ),
                FeaturedCategory(),
                Icon(FontAwesomeIcons.chevronDown),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
