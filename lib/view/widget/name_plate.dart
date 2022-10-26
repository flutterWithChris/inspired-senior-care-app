import 'package:flutter/material.dart';
import 'package:inspired_senior_care_app/data/models/user.dart';

class NamePlate extends StatelessWidget {
  final String memberName;
  final String memberTitle;
  final String memberColorHex;
  final User user;

  const NamePlate({
    required this.memberName,
    required this.memberTitle,
    required this.memberColorHex,
    required this.user,
    Key? key,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    Color userColor = hexToColor(memberColorHex);
    return Column(
      children: [
        ListTile(
            minLeadingWidth: 70,
            leading: InitialsIcon(userColor: userColor, memberName: memberName),
            title: Text(
              memberName,
              style: Theme.of(context).textTheme.titleLarge,
            ),
            subtitle: Wrap(
              spacing: 4.0,
              children: [
                Text(memberTitle),
                user.organization != '' ? const Text('•') : const SizedBox(),
                user.organization != ''
                    ? Text(
                        user.organization!,
                      )
                    : const SizedBox(),
              ],
            )),
      ],
    );
  }
}

class InitialsIcon extends StatelessWidget {
  const InitialsIcon({
    Key? key,
    required this.userColor,
    required this.memberName,
  }) : super(key: key);

  final Color userColor;
  final String memberName;

  @override
  Widget build(BuildContext context) {
    String getInitials(String name) => name.isNotEmpty
        ? name.trim().split(' ').map((l) => l[0]).take(2).join()
        : '';

    return CircleAvatar(
      backgroundColor: userColor,
      radius: 30,
      child: Text(
        getInitials(memberName),
        style: const TextStyle(fontSize: 24),
      ),
    );
  }
}

/// Construct a color from a hex code string, of the format RRGGBB.
Color hexToColor(String code) {
  return Color(int.parse(code.substring(1, 6), radix: 16) + 0xFF000000);
}
