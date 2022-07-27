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
        child: Padding(
          padding: const EdgeInsets.symmetric(vertical: 12.0),
          child: ListView(
            shrinkWrap: true,
            children: const [
              NamePlate(
                memberName: 'Chelsea Ranchford',
                memberTitle: 'Home Attendant',
              ),
              Padding(
                padding: EdgeInsets.symmetric(vertical: 12.0),
                child: GroupMemberProgressSection(),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
