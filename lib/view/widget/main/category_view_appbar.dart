import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';

class CategoryViewAppBar extends StatelessWidget {
  final String? title;
  const CategoryViewAppBar({
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
      actions: const [],
      title: title != null
          ? Text(title!)
          : Image.asset(
              'lib/assets/Inspired-Senior-care.png',
              height: 40,
              fit: BoxFit.contain,
            ),
    );
  }
}
