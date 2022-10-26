import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:inspired_senior_care_app/bloc/member/bloc/bloc/group_member_bloc.dart';
import 'package:inspired_senior_care_app/data/models/user.dart';
import 'package:inspired_senior_care_app/view/widget/main/bottom_app_bar.dart';
import 'package:inspired_senior_care_app/view/widget/main/top_app_bar.dart';

import 'package:inspired_senior_care_app/view/widget/member_tile.dart';
import 'package:inspired_senior_care_app/view/widget/name_plate.dart';
import 'package:loading_animation_widget/loading_animation_widget.dart';

class ViewMembers extends StatelessWidget {
  const ViewMembers({super.key});

  @override
  Widget build(BuildContext context) {
    // context.read<MemberBloc>().add(ResetMember());
    return Scaffold(
      appBar: const PreferredSize(
        preferredSize: Size.fromHeight(50),
        child: MainTopAppBar(),
      ),
      bottomNavigationBar: const MainBottomAppBar(),
      body: BlocBuilder<GroupMemberBloc, GroupMemberState>(
        builder: (context, state) {
          if (state is GroupMembersLoading) {
            return Center(
              child: LoadingAnimationWidget.discreteCircle(
                  color: Colors.blue, size: 30),
            );
          }
          if (state is GroupMembersLoaded) {
            if (state.groupMembers.isEmpty) {
              return Center(
                  child: Text(
                'No Members Yet!',
                style: Theme.of(context).textTheme.titleLarge,
              ));
            } else {
              return Padding(
                padding: const EdgeInsets.symmetric(horizontal: 8.0),
                child: Column(
                  children: [
                    Padding(
                      padding: const EdgeInsets.symmetric(vertical: 12.0),
                      child: Text(
                        '${state.group.groupName}',
                        style: Theme.of(context).textTheme.headlineMedium,
                      ),
                    ),
                    Card(
                      shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(12.0)),
                      child: ListView.builder(
                        padding: const EdgeInsets.symmetric(vertical: 8.0),
                        shrinkWrap: true,
                        itemCount: state.groupMembers.length,
                        itemBuilder: (context, index) {
                          print(
                              'Building list of ${state.groupMembers.length} members');
                          User user = state.groupMembers[index];

                          return GroupMemberTile(
                            currentGroup: state.group,
                            memberId: user.id!,
                            memberName: user.name!,
                            memberTitle: user.title!,
                            memberProgress: 0.3,
                            memberColor: hexToColor(user.userColor!),
                          );
                        },
                      ),
                    ),
                  ],
                ),
              );
            }
          }
          return const Text('Something Went Wrong...');
        },
      ),
    );
  }
}
