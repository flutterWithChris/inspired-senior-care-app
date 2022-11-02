import 'package:flutter/material.dart';
import 'package:inspired_senior_care_app/view/widget/featured_category.dart';
import 'package:inspired_senior_care_app/view/widget/main/bottom_app_bar.dart';
import 'package:inspired_senior_care_app/view/widget/main/main_app_drawer.dart';
import 'package:inspired_senior_care_app/view/widget/main/top_app_bar.dart';
import 'package:upgrader/upgrader.dart';

class MyHomePage extends StatefulWidget {
  const MyHomePage({super.key});

  @override
  State<MyHomePage> createState() => _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage> {
  @override
  Widget build(BuildContext context) {
    return UpgradeAlert(
      upgrader: Upgrader(
        shouldPopScope: () => true,
      ),
      child: Scaffold(
        drawer: const MainAppDrawer(),
        bottomNavigationBar: const MainBottomAppBar(),
        appBar: const PreferredSize(
          preferredSize: Size.fromHeight(60),
          child: MainTopAppBar(),
        ),
        body: Center(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: const <Widget>[
              Padding(
                padding: EdgeInsets.only(top: 16.0, bottom: 24.0),
                child: Text(
                  'Monthly Category',
                  style: TextStyle(fontSize: 30),
                ),
              ),
              FeaturedCategory(),
            ],
          ),
        ),
      ),
    );
  }
}
