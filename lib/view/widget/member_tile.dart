import 'dart:math';

import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';
import 'package:inspired_senior_care_app/bloc/member/bloc/member_bloc.dart';
import 'package:inspired_senior_care_app/data/models/group.dart';

class GroupMemberTile extends StatelessWidget {
  final Group currentGroup;
  final String memberId;
  final String memberName;
  final Color memberColor;
  final String memberTitle;
  final double memberProgress;
  final Random random = Random();
  GroupMemberTile({
    Key? key,
    required this.currentGroup,
    required this.memberId,
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
        padding: const EdgeInsets.symmetric(vertical: 4.0),
        child: ListTile(
          shape:
              RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
          onTap: () {
            context.read<MemberBloc>().add(LoadMember(userId: memberId, group: currentGroup));
            context.goNamed('view-member');
          },
          dense: true,
          minLeadingWidth: 50,
          minVerticalPadding: 12.0,
          leading: CircleAvatar(
            backgroundColor: memberColor,
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
            ],
          ),
          trailing: const SizedBox(
            height: 50,
            child: Icon(Icons.chevron_right_rounded),
          ),
        ));
  }
}
