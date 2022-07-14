import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:get/get.dart';
import 'package:inspired_senior_care_app/main.dart';
import 'package:inspired_senior_care_app/view/pages/categories.dart';
import 'package:inspired_senior_care_app/view/pages/profile.dart';

class MainBottomAppBar extends StatefulWidget {
  const MainBottomAppBar({Key? key}) : super(key: key);

  @override
  State<MainBottomAppBar> createState() => _BottomAppBarState();
}

class _BottomAppBarState extends State<MainBottomAppBar> {
  int currentIndex = 1;

  @override
  Widget build(BuildContext context) {
    return BottomNavigationBar(
        onTap: (index) {
          setState(() {
            currentIndex = index;
          });
          switch (index) {
            case 0:
              {
                Get.to(const Categories());
              }
              break;

            case 1:
              {
                Get.to(const MyHomePage());
              }
              break;

            case 2:
              {
                Get.to(const Profile());
              }
              break;
          }
        },
        currentIndex: currentIndex,
        items: const [
          BottomNavigationBarItem(
              label: 'Categories', icon: Icon(FontAwesomeIcons.layerGroup)),
          BottomNavigationBarItem(label: 'Home', icon: Icon(Icons.home)),
          BottomNavigationBarItem(
              label: 'Profile', icon: Icon(Icons.person_outline_rounded)),
        ]);
  }
}
