import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:inspired_senior_care_app/view/pages/view_member.dart';
import 'package:inspired_senior_care_app/view/widget/bottom_app_bar.dart';
import 'package:inspired_senior_care_app/view/widget/name_plate.dart';

class Dashboard extends StatefulWidget {
  const Dashboard({Key? key}) : super(key: key);

  @override
  State<Dashboard> createState() => _DashboardState();
}

class _DashboardState extends State<Dashboard> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      bottomNavigationBar: const MainBottomAppBar(),
      appBar: PreferredSize(
        preferredSize: const Size.fromHeight(50),
        child: AppBar(title: const Text('Inspired Senior Care')),
      ),
      body: Padding(
        padding: const EdgeInsets.symmetric(vertical: 12.0, horizontal: 12.0),
        child: ListView(
          shrinkWrap: true,
          children: [
            const Padding(
              padding: EdgeInsets.symmetric(vertical: 12.0),
              child: NamePlate(
                memberName: 'Jennifer Sample',
                memberTitle: 'Director',
              ),
            ),
            Card(
              child: Padding(
                padding:
                    const EdgeInsets.symmetric(horizontal: 8.0, vertical: 12.0),
                child: Column(children: [
                  Padding(
                    padding: const EdgeInsets.symmetric(vertical: 5),
                    child: Text(
                      'Your Group',
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
                          onPressed: () {},
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
                  const GroupMemberTile(
                    memberName: 'Julia Test',
                    memberTitle: 'Nurse',
                    memberProgress: 0.3,
                    memberColor: Colors.pink,
                  ),
                  const GroupMemberTile(
                    memberName: 'Amanda Sample',
                    memberTitle: 'Nurse',
                    memberProgress: 0.7,
                    memberColor: Colors.indigo,
                  ),
                  const GroupMemberTile(
                    memberName: 'Tracy Chapman',
                    memberTitle: 'Nurse',
                    memberProgress: 0.9,
                    memberColor: Colors.amber,
                  ),
                  const GroupMemberTile(
                    memberName: 'George Costanza',
                    memberTitle: 'Nurse',
                    memberProgress: 0.6,
                    memberColor: Colors.cyanAccent,
                  ),
                  const GroupMemberTile(
                    memberName: 'Ralph Maccio',
                    memberTitle: 'Nurse',
                    memberProgress: 0.2,
                    memberColor: Colors.brown,
                  ),
                ]),
              ),
            )
          ],
        ),
      ),
    );
  }
}

class GroupMemberTile extends StatelessWidget {
  final String memberName;
  final Color memberColor;
  final String memberTitle;
  final double memberProgress;

  const GroupMemberTile({
    Key? key,
    required this.memberName,
    required this.memberTitle,
    required this.memberProgress,
    required this.memberColor,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    String getInitials(String name) => name.isNotEmpty
        ? name.trim().split(' ').map((l) => l[0]).take(2).join()
        : '';

    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 8.0),
      child: InkWell(
        splashColor: Colors.blue,
        onTap: () {},
        child: ClipRRect(
          borderRadius: BorderRadius.circular(25),
          child: Container(
            color: Colors.white,
            child: Padding(
              padding: const EdgeInsets.symmetric(horizontal: 8.0),
              child: ListTile(
                onTap: () => Get.to(() => const ViewMember()),
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
          ),
        ),
      ),
    );
  }
}
