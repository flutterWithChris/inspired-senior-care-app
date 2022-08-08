import 'dart:math';

import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';

class GroupMemberTile extends StatelessWidget {
  final String memberName;
  final Color memberColor;
  final String memberTitle;
  final double memberProgress;
  final Random random = Random();
  GroupMemberTile({
    Key? key,
    required this.memberName,
    required this.memberTitle,
    required this.memberProgress,
    required this.memberColor,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final Color randomColor = Color.fromRGBO(
        random.nextInt(255), random.nextInt(255), random.nextInt(255), 1);

    String getInitials(String name) => name.isNotEmpty
        ? name.trim().split(' ').map((l) => l[0]).take(2).join()
        : '';

    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 8.0),
      child: Card(
        elevation: 0.5,
        shape: const StadiumBorder(),
        child: ListTile(
          shape: const StadiumBorder(),
          onTap: () => context.goNamed('view-member'),
          dense: true,
          minLeadingWidth: 50,
          minVerticalPadding: 12.0,
          leading: CircleAvatar(
            backgroundColor: randomColor,
            radius: 24.0,
            child: Text(
              getInitials(memberName),
              style: const TextStyle(fontSize: 18),
            ),
          ),
          title: Text(
            memberName,
            style: Theme.of(context).textTheme.titleSmall,
          ),
          subtitle: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(memberTitle),
              Padding(
                padding: const EdgeInsets.symmetric(vertical: 10.0),
                child: ClipRRect(
                  borderRadius: BorderRadius.circular(25),
                  child: LinearProgressIndicator(
                    backgroundColor: Colors.grey.shade300,
                    color: Colors.blueAccent,
                    value: memberProgress,
                  ),
                ),
              ),
            ],
          ),
          trailing: const SizedBox(
            height: 50,
            child: Icon(Icons.chevron_right_rounded),
          ),
        ),
      ),
    );
  }
}
