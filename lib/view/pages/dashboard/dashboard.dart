import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_speed_dial/flutter_speed_dial.dart';
import 'package:go_router/go_router.dart';
import 'package:inspired_senior_care_app/bloc/group/group_bloc.dart';
import 'package:inspired_senior_care_app/data/models/group.dart';
import 'package:inspired_senior_care_app/view/pages/dashboard/add_member.dart';
import 'package:inspired_senior_care_app/view/pages/dashboard/create_group.dart';
import 'package:inspired_senior_care_app/view/widget/bottom_app_bar.dart';
import 'package:inspired_senior_care_app/view/widget/member_tile.dart';
import 'package:inspired_senior_care_app/view/widget/name_plate.dart';

class Dashboard extends StatefulWidget {
  const Dashboard({Key? key}) : super(key: key);

  @override
  State<Dashboard> createState() => _DashboardState();
}

class _DashboardState extends State<Dashboard> {
  TextEditingController inviteTextFieldController = TextEditingController();
  static List<Group> sampleGroupList = [
    Group(
        groupName: 'Cleveland Senior Care',
        groupId: '5167',
        groupMembers: [''],
        groupManagers: ['']),
  ];
  _showCreateGroupDialog() {
    showDialog(
        context: context,
        builder: (context) {
          return CreateGroupDialog(
            groupList: sampleGroupList,
          );
        });
  }

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Scaffold(
        // * FAB
        floatingActionButton: SpeedDial(
          overlayColor: Colors.black,
          spacing: 12.0,
          backgroundColor: Colors.lightGreen,
          children: [
            SpeedDialChild(
              label: 'Create a Group',
              child: const Icon(Icons.group_add),
              onTap: () => _showCreateGroupDialog(),
            ),
          ],
          child: const Icon(Icons.add),
        ),
        bottomNavigationBar: const MainBottomAppBar(),
        appBar: PreferredSize(
          preferredSize: const Size.fromHeight(50),
          child: AppBar(title: const Text('Inspired Senior Care')),
        ),
        // * Main Content
        body: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 10.0),
          child: ListView(
            shrinkWrap: true,
            children: [
              // * Name Plate
              const Padding(
                padding: EdgeInsets.symmetric(vertical: 6.0),
                child: NamePlate(
                  memberName: 'Jennifer Sample',
                  memberTitle: 'Director',
                ),
              ),
              Padding(
                padding: const EdgeInsets.only(bottom: 10),
                child: Card(
                  shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(33)),
                  color: Colors.lightBlue.shade100,
                  elevation: 1.5,
                  // * Featured Category
                  child: Padding(
                    padding: const EdgeInsets.only(
                        top: 6.0, bottom: 24.0, left: 12.0, right: 12.0),
                    child: Column(children: [
                      Column(
                        children: [
                          Padding(
                            padding: const EdgeInsets.symmetric(
                                vertical: 12.0, horizontal: 12.0),
                            child: Row(
                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                              children: [
                                Wrap(
                                  crossAxisAlignment: WrapCrossAlignment.center,
                                  spacing: 12.0,
                                  children: [
                                    const Icon(
                                      Icons.star,
                                      color: Colors.black87,
                                    ),
                                    Text(
                                      'Featured Category',
                                      textAlign: TextAlign.start,
                                      style:
                                          Theme.of(context).textTheme.headline5,
                                    ),
                                  ],
                                ),
                              ],
                            ),
                          ),
                          const CurrentCategoryCard(),
                        ],
                      ),
                      Padding(
                        padding: const EdgeInsets.symmetric(
                            vertical: 12.0, horizontal: 8.0),
                        child: Row(
                          crossAxisAlignment: CrossAxisAlignment.center,
                          children: [
                            Wrap(
                              spacing: 12.0,
                              runAlignment: WrapAlignment.center,
                              alignment: WrapAlignment.center,
                              crossAxisAlignment: WrapCrossAlignment.center,
                              // mainAxisAlignment: MainAxisAlignment.spaceBetween,
                              children: [
                                const Icon(
                                  Icons.group,
                                  color: Colors.black87,
                                ),
                                Text(
                                  'My Groups',
                                  style: Theme.of(context).textTheme.headline5,
                                ),
                              ],
                            ),
                          ],
                        ),
                      ),
                      // * Groups Section
                      BlocBuilder<GroupBloc, GroupState>(
                        // * Rebuild when groups updated.
                        buildWhen: (previous, current) =>
                            previous is GroupCreated && current is GroupInitial,
                        builder: (context, state) {
                          return Column(
                            mainAxisSize: MainAxisSize.min,
                            children: [
                              // * Build groups
                              for (Group group in sampleGroupList)
                                Padding(
                                  padding:
                                      const EdgeInsets.symmetric(vertical: 8.0),
                                  child: GroupSection(
                                      groupName: group.groupName,
                                      sampleGroupList: sampleGroupList,
                                      inviteTextFieldController:
                                          inviteTextFieldController),
                                ),
                              // TODO: Handle No Groups Created State
                            ],
                          );
                        },
                      ),
                    ]),
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

class GroupSection extends StatefulWidget {
  final String groupName;
  const GroupSection({
    required this.groupName,
    Key? key,
    required this.sampleGroupList,
    required this.inviteTextFieldController,
  }) : super(key: key);

  final List<Group> sampleGroupList;
  final TextEditingController inviteTextFieldController;

  @override
  State<GroupSection> createState() => _GroupSectionState();
}

class _GroupSectionState extends State<GroupSection> {
  @override
  Widget build(BuildContext context) {
    return Card(
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(25)),
      elevation: 2.0,
      child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 8.0, vertical: 12.0),
        child: Column(children: [
          Padding(
            padding: const EdgeInsets.symmetric(vertical: 5),
            child: Text(
              widget.groupName,
              style: Theme.of(context).textTheme.headline5,
            ),
          ),
          Wrap(
            runAlignment: WrapAlignment.end,
            alignment: WrapAlignment.end,
            spacing: 12,
            crossAxisAlignment: WrapCrossAlignment.center,
            children: [
              ElevatedButton.icon(
                  style: ElevatedButton.styleFrom(
                    primary: Colors.lightGreen,
                    onPrimary: Colors.white,
                  ),
                  onPressed: () {
                    showDialog(
                        context: context,
                        builder: (_) => AddMemberDialog(
                            inviteTextFieldController:
                                widget.inviteTextFieldController));
                  },
                  icon: const Icon(
                    Icons.add_circle_rounded,
                    size: 18,
                  ),
                  label: const Text(
                    'Add Member',
                  )),
              ElevatedButton.icon(
                  style: ElevatedButton.styleFrom(
                    primary: Colors.blueAccent,
                    onPrimary: Colors.white,
                  ),
                  onPressed: () {},
                  icon: const Icon(
                    Icons.edit,
                    size: 18,
                  ),
                  label: const Text(
                    'Edit',
                  )),
            ],
          ),
          GroupMemberTile(
            memberName: 'Julia Test',
            memberTitle: 'Nurse',
            memberProgress: 0.3,
            memberColor: Colors.pink,
          ),
          GroupMemberTile(
            memberName: 'Amanda Sample',
            memberTitle: 'Nurse',
            memberProgress: 0.7,
            memberColor: Colors.indigo,
          ),
          /*  GroupMemberTile(
            memberName: 'Tracy Chapman',
            memberTitle: 'Nurse',
            memberProgress: 0.9,
            memberColor: Colors.amber,
          ),
          GroupMemberTile(
            memberName: 'George Costanza',
            memberTitle: 'Nurse',
            memberProgress: 0.6,
            memberColor: Colors.cyanAccent,
          ),
          GroupMemberTile(
            memberName: 'Ralph Maccio',
            memberTitle: 'Nurse',
            memberProgress: 0.2,
            memberColor: Colors.brown,
          ), */
        ]),
      ),
    );
  }
}

class CurrentCategoryCard extends StatelessWidget {
  const CurrentCategoryCard({
    Key? key,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Card(
      shape: const StadiumBorder(),
      elevation: 1,
      child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 16.0, vertical: 10.0),
        child: ListTile(
          minLeadingWidth: 10,
          // dense: true,
          onTap: () => context.goNamed('choose-category'),
          title: const Text(
            'Supportive Environment',
          ),
          subtitle: const Text('Creating a healthy environment.'),
          trailing: const Icon(Icons.chevron_right_rounded),
          leading: SizedBox(
            height: 60,
            child: Image.asset(
              'lib/assets/Supportive_Environment.png',
              fit: BoxFit.fitHeight,
            ),
          ),
        ),
      ),
    );
  }
}
