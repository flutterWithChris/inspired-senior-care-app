import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:go_router/go_router.dart';

class MainBottomAppBar extends StatefulWidget {
  const MainBottomAppBar({Key? key}) : super(key: key);

  @override
  State<MainBottomAppBar> createState() => _BottomAppBarState();
}

class _BottomAppBarState extends State<MainBottomAppBar> {
  static int currentIndex = 1;

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
                context.goNamed('categories');
              }
              break;

            case 1:
              {
                context.goNamed('home');
              }
              break;

            case 2:
              {
                context.goNamed('dashboard');
              }
              break;
          }
        },
        currentIndex: currentIndex,
        items: const [
          BottomNavigationBarItem(
              label: 'Categories', icon: Icon(FontAwesomeIcons.layerGroup)),
          BottomNavigationBarItem(label: 'Home', icon: Icon(Icons.home)),
          /*   BottomNavigationBarItem(
              label: 'Profile', icon: Icon(Icons.person_outline_rounded)),*/
          BottomNavigationBarItem(
              label: 'Dashboard', icon: Icon(Icons.dashboard_rounded)),
        ]);
  }
}
