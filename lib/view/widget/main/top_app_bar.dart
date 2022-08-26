import 'package:flutter/material.dart';

class MainTopAppBar extends StatelessWidget {
  final String? title;
  const MainTopAppBar({
    this.title,
    Key? key,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return AppBar(
      backgroundColor: Colors.white,
      foregroundColor: Colors.black87,
      centerTitle: true,
      toolbarHeight: 60,
      title: title != null
          ? Text(title!)
          : Image.asset(
              'lib/assets/Logo-01.png',
              height: 40,
              fit: BoxFit.contain,
            ),
    );
  }
}
