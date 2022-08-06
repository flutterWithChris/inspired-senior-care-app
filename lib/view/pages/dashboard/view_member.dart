import 'package:flutter/material.dart';
import 'package:inspired_senior_care_app/view/widget/bottom_app_bar.dart';
import 'package:inspired_senior_care_app/view/widget/name_plate.dart';
import 'package:inspired_senior_care_app/view/widget/progress_widgets.dart';

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
      body: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 12.0),
        child: ListView(
          shrinkWrap: true,
          children: const [
            Padding(
              padding: EdgeInsets.only(top: 12.0),
              child: NamePlate(
                memberName: 'Chelsea Ranchford',
                memberTitle: 'Home Attendant',
                memberColorHex: 'ffffff',
              ),
            ),
            Padding(
              padding: EdgeInsets.symmetric(vertical: 12.0),
              child: GroupMemberProgressSection(),
            ),
            RemoveMemberButton(),
          ],
        ),
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
