import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';
import 'package:inspired_senior_care_app/bloc/member/bloc/bloc/group_member_bloc.dart';
import 'package:inspired_senior_care_app/bloc/member/bloc/member_bloc.dart';
import 'package:inspired_senior_care_app/data/models/group.dart';
import 'package:inspired_senior_care_app/data/models/user.dart';
import 'package:inspired_senior_care_app/view/widget/main/bottom_app_bar.dart';
import 'package:inspired_senior_care_app/view/widget/main/top_app_bar.dart';
import 'package:inspired_senior_care_app/view/widget/name_plate.dart';
import 'package:inspired_senior_care_app/view/widget/progress_widgets.dart';
import 'package:loading_animation_widget/loading_animation_widget.dart';
import 'package:showcaseview/showcaseview.dart';

class ViewMember extends StatefulWidget {
  const ViewMember({Key? key}) : super(key: key);

  @override
  State<ViewMember> createState() => _ViewMemberState();
}

class _ViewMemberState extends State<ViewMember> {
  final GlobalKey viewResponsesShowcaseKey = GlobalKey();
  BuildContext? showcaseBuildContext;

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((timeStamp) {
      ShowCaseWidget.of(showcaseBuildContext!)
          .startShowCase([viewResponsesShowcaseKey]);
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      bottomNavigationBar: const MainBottomAppBar(),
      appBar: const PreferredSize(
        preferredSize: Size.fromHeight(60),
        child: MainTopAppBar(),
      ),
      body: BlocConsumer<MemberBloc, MemberState>(
        listener: (context, state) async {
          if (state is MemberRemoved) {
            await Future.delayed(const Duration(seconds: 2));
            if (!mounted) return;
            context.pop();
          }
        },
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
                        user: thisUser,
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
                ));
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
    BuildContext? dialogContext;
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
                    dialogContext = context;
                    return RemoveMemberDialog(
                      group: currentGroup,
                    );
                  },
                );
              },
              style: ElevatedButton.styleFrom(
                  fixedSize: const Size(175, 32),
                  backgroundColor: Colors.redAccent),
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
        if (state is MemberRemoved) {
          return Container();
        }
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
            child: Padding(
              padding:
                  const EdgeInsets.symmetric(vertical: 16.0, horizontal: 8.0),
              child: Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  Padding(
                    padding: const EdgeInsets.all(8.0),
                    child: Text(
                      'Remove Member?',
                      style: Theme.of(context).textTheme.headlineSmall,
                    ),
                  ),
                  const Padding(
                    padding: EdgeInsets.only(bottom: 8.0),
                    child: Text('This cannot be undone.'),
                  ),
                  Padding(
                    padding: const EdgeInsets.all(8.0),
                    child: ElevatedButton(
                        style: ElevatedButton.styleFrom(
                            backgroundColor: Colors.redAccent),
                        onPressed: () async {
                          context.read<MemberBloc>().add(
                              RemoveMemberFromGroup(group: group, user: user));
                          List<String> updatedMembers = group.groupMemberIds!
                            ..remove(user.id);
                          context.read<GroupMemberBloc>().add(LoadGroupMembers(
                              userIds: updatedMembers, group: group));

                          await Future.delayed(
                              const Duration(milliseconds: 1000));
                          if (!mounted) return;
                          context.goNamed('dashboard');
                        },
                        child: BlocConsumer<MemberBloc, MemberState>(
                          listener: (context, state) async {
                            if (state is MemberRemoved) {
                              // context.pop();
                            }
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
