import 'package:flutter/material.dart';

class NamePlate extends StatelessWidget {
  final String memberName;
  final String memberTitle;
  final String memberColorHex;

  const NamePlate({
    required this.memberName,
    required this.memberTitle,
    required this.memberColorHex,
    Key? key,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    String getInitials(String name) => name.isNotEmpty
        ? name.trim().split(' ').map((l) => l[0]).take(2).join()
        : '';

    Color userColor = hexToColor(memberColorHex);
    return ListTile(
      minLeadingWidth: 70,
      leading: CircleAvatar(
        backgroundColor: userColor,
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

/// Construct a color from a hex code string, of the format RRGGBB.
Color hexToColor(String code) {
  return Color(int.parse(code.substring(1, 6), radix: 16) + 0xFF000000);
}
