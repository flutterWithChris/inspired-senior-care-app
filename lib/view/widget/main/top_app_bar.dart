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
      toolbarHeight: 50,
      title: Text(title ?? 'Inspired Senior Care'),
    );
  }
}
