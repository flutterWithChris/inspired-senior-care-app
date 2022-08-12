import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:inspired_senior_care_app/bloc/member/bloc/member_bloc.dart';
import 'package:inspired_senior_care_app/data/models/user.dart';
import 'package:inspired_senior_care_app/view/widget/bottom_app_bar.dart';
import 'package:inspired_senior_care_app/view/widget/name_plate.dart';
import 'package:inspired_senior_care_app/view/widget/progress_widgets.dart';
import 'package:loading_animation_widget/loading_animation_widget.dart';

class ViewMember extends StatelessWidget {
  const ViewMember({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      bottomNavigationBar: const MainBottomAppBar(),
      appBar: PreferredSize(
        preferredSize: const Size.fromHeight(50),
        child: AppBar(title: const Text('Inspired Senior Care')),
      ),
      body: BlocBuilder<MemberBloc, MemberState>(
        builder: (context, state) {
          if (state is MemberLoading) {
            return Center(
              child: LoadingAnimationWidget.discreteCircle(
                  color: Colors.blue, size: 30),
            );
          }
          if (state is MemberLoaded) {
            User thisUser = state.user;
            return Padding(
              padding: const EdgeInsets.symmetric(horizontal: 12.0),
              child: ListView(
                shrinkWrap: true,
                children: [
                  Padding(
                    padding: const EdgeInsets.only(top: 12.0),
                    child: NamePlate(
                      memberName: thisUser.name!,
                      memberTitle: thisUser.title!,
                      memberColorHex: thisUser.userColor!,
                    ),
                  ),
                  const Padding(
                    padding: EdgeInsets.symmetric(vertical: 12.0),
                    child: GroupMemberProgressSection(),
                  ),
                  const RemoveMemberButton(),
                ],
              ),
            );
          }
          return const Text('Something Went Wrong!');
        },
      ),
    );
  }
}

class RemoveMemberButton extends StatelessWidget {
  const RemoveMemberButton({
    Key? key,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 10.0),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          ElevatedButton.icon(
              onPressed: () {},
              style: ElevatedButton.styleFrom(
                  fixedSize: const Size(175, 32), primary: Colors.redAccent),
              icon: const Icon(Icons.group_remove_outlined),
              label: const Text('Remove Member')),
        ],
      ),
    );
  }
}
