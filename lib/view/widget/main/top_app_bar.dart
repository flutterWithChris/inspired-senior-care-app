import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../../../cubits/login/login_cubit.dart';

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
      actions: [
        TextButton.icon(
            onPressed: () {
              context.read<LoginCubit>().signOut();
            },
            icon: const Icon(Icons.logout_rounded),
            label: const Text('Logout'))
      ],
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
