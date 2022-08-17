import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';
import 'package:inspired_senior_care_app/bloc/member/bloc/bloc/group_member_bloc.dart';
import 'package:inspired_senior_care_app/bloc/member/bloc/member_bloc.dart';
import 'package:inspired_senior_care_app/data/models/group.dart';
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
          if (state is MemberRemoved) {
            return Center(
              child: Wrap(
                  direction: Axis.vertical,
                  spacing: 8.0,
                  crossAxisAlignment: WrapCrossAlignment.center,
                  children: const [
                    Icon(
                      Icons.delete,
                      size: 30,
                    ),
                    Text('Removed From Group!')
                  ]),
            );
          }
          if (state is MemberFailed) {
            return const Center(
              child: Text('Error Fetching Member!'),
            );
          }
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
                  RemoveMemberButton(currentGroup: state.group),
                  const Padding(
                    padding: EdgeInsets.symmetric(vertical: 12.0),
                    child: GroupMemberProgressSection(),
                  ),
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
  final Group currentGroup;
  const RemoveMemberButton({
    Key? key,
    required this.currentGroup,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 10.0),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.end,
        children: [
          ElevatedButton.icon(
              onPressed: () {
                showDialog(
                  context: context,
                  builder: (context) {
                    return RemoveMemberDialog(
                      group: currentGroup,
                    );
                  },
                );
              },
              style: ElevatedButton.styleFrom(
                  fixedSize: const Size(175, 32), primary: Colors.redAccent),
              icon: const Icon(Icons.group_remove_outlined),
              label: const Text('Remove Member')),
        ],
      ),
    );
  }
}

class RemoveMemberDialog extends StatefulWidget {
  final Group group;
  const RemoveMemberDialog({
    Key? key,
    required this.group,
  }) : super(key: key);

  @override
  State<RemoveMemberDialog> createState() => _RemoveMemberDialogState();
}

class _RemoveMemberDialogState extends State<RemoveMemberDialog> {
  @override
  Widget build(BuildContext context) {
    final GlobalKey<FormState> removeMemberForm = GlobalKey<FormState>();
    final TextEditingController textFieldController = TextEditingController();
    return BlocBuilder<MemberBloc, MemberState>(
      builder: (context, state) {
        if (state is MemberLoading) {
          return LoadingAnimationWidget.fourRotatingDots(
              color: Colors.blue, size: 30);
        }
        if (state is MemberFailed) {
          return const Center(
            child: Text('Error Loading Member!'),
          );
        }
        if (state is MemberLoaded) {
          User user = state.user;
          Group group = state.group;
          return Dialog(
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: Text(
                    'Remove Member?',
                    style: Theme.of(context).textTheme.headline5,
                  ),
                ),
                Padding(
                  padding: const EdgeInsets.only(bottom: 8.0),
                  child: Text('Type ${user.name} to confirm.'),
                ),
                Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: Form(
                    key: removeMemberForm,
                    child: TextFormField(
                      autovalidateMode: AutovalidateMode.onUserInteraction,
                      validator: (value) {
                        if (value != user.name) {
                          return 'Name doesn\'t match!';
                        } else {
                          return null;
                        }
                      },
                      controller: textFieldController,
                      decoration: InputDecoration(hintText: '${user.name}'),
                    ),
                  ),
                ),
                Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: ElevatedButton(
                      style:
                          ElevatedButton.styleFrom(primary: Colors.redAccent),
                      onPressed: () async {
                        if (removeMemberForm.currentState!.validate()) {
                          print('Remove Member Fired');
                          context.read<MemberBloc>().add(
                              RemoveMemberFromGroup(group: group, user: user));
                          List<String> updatedMembers = group.groupMemberIds!
                            ..remove(user.id);
                          context.read<GroupMemberBloc>().add(LoadGroupMembers(
                              userIds: updatedMembers, group: group));
                          await Future.delayed(const Duration(seconds: 3));
                          // TODO: Improve State Status on Removed
                          if (!mounted) return;
                          context.pop();
                        } else {
                          print('Form not valid');
                        }
                      },
                      child: BlocConsumer<MemberBloc, MemberState>(
                        listener: (context, state) async {
                          if (state is MemberRemoved) {}
                        },
                        builder: (context, state) {
                          if (state is MemberFailed) {
                            return const Text('Error Removing Member!');
                          }
                          if (state is MemberLoading) {
                            return LoadingAnimationWidget.fourRotatingDots(
                                color: Colors.blue, size: 15);
                          }
                          if (state is MemberLoaded) {
                            return const Text('Confirm Removal');
                          }
                          if (state is MemberRemoved) {
                            return Wrap(
                              spacing: 8.0,
                              crossAxisAlignment: WrapCrossAlignment.center,
                              children: const [
                                Text('Member Removed!'),
                                Icon(Icons.check_circle_rounded),
                              ],
                            );
                          } else {
                            return const Center(
                              child: Text('Something Went Wrong!'),
                            );
                          }
                        },
                      )),
                ),
              ],
            ),
          );
        } else {
          return const Center(
            child: Text('Something Went Wrong!'),
          );
        }
      },
    );
  }
}
