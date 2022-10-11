import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';

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
      actions: const [
        // TextButton.icon(
        //     onPressed: () {
        //       context.read<LoginCubit>().signOut();
        //     },
        //     icon: const Icon(Icons.logout_rounded),
        //     label: const Text('Logout'))
        // IconButton(
        //     onPressed: () {},
        //     icon: Icon(
        //       FontAwesomeIcons.inbox,
        //       color: Theme.of(context).iconTheme.color,
        //     ))
      ],
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
