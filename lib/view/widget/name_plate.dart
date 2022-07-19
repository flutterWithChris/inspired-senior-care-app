import 'package:flutter/material.dart';

class NamePlate extends StatelessWidget {
  final String memberName;
  final String memberTitle;

  const NamePlate({
    required this.memberName,
    required this.memberTitle,
    Key? key,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    String getInitials(String name) => name.isNotEmpty
        ? name.trim().split(' ').map((l) => l[0]).take(2).join()
        : '';

    return ListTile(
      minLeadingWidth: 70,
      leading: CircleAvatar(
        radius: 30,
        child: Text(
          getInitials(memberName),
          style: const TextStyle(fontSize: 24),
        ),
      ),
      title: Text(
        memberName,
        style: Theme.of(context).textTheme.titleLarge,
      ),
      subtitle: Text(memberTitle),
    );
  }
}
