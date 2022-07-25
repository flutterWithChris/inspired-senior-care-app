import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_speed_dial/flutter_speed_dial.dart';
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
          padding: const EdgeInsets.symmetric(vertical: 12.0, horizontal: 12.0),
          child: ListView(
            shrinkWrap: true,
            children: [
              // * Name Plate
              const Padding(
                padding: EdgeInsets.symmetric(vertical: 12.0),
                child: NamePlate(
                  memberName: 'Jennifer Sample',
                  memberTitle: 'Director',
                ),
              ),
              // * Current Category
              Column(
                children: const [
                  Padding(
                    padding: EdgeInsets.symmetric(vertical: 8),
                    child: Text(
                      'Currently Featured Category:',
                      textAlign: TextAlign.start,
                      style: TextStyle(fontSize: 18),
                    ),
                  ),
                  CurrentCategoryCard(),
                ],
              ),
              const SizedBox(
                height: 15,
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
                        GroupSection(
                            groupName: group.groupName,
                            sampleGroupList: sampleGroupList,
                            inviteTextFieldController:
                                inviteTextFieldController),
                      // TODO: Handle No Groups Created State
                    ],
                  );
                },
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
              style: Theme.of(context).textTheme.titleLarge,
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
      elevation: 1,
      child: ListTile(
        title: const Text('Supportive Environment'),
        subtitle: const Text('Creating a healthy environment.'),
        trailing: const Icon(Icons.chevron_right_rounded),
        leading: SizedBox(
          height: 100,
          child: Image.asset('lib/assets/Supportive_Environment.png'),
        ),
      ),
    );
  }
}
