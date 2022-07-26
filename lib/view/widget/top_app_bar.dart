import 'package:flutter/material.dart';

class MainTopAppBar extends StatelessWidget {
  const MainTopAppBar({
    Key? key,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return AppBar(
      toolbarHeight: 50,
      title: const Text('Inspired Senior Care'),
    );
  }
}
