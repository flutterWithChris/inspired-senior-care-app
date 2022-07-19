import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:inspired_senior_care_app/view/widget/bottom_app_bar.dart';
import 'package:inspired_senior_care_app/view/widget/name_plate.dart';
import 'package:inspired_senior_care_app/view/widget/progress_widgets.dart';

class Profile extends StatelessWidget {
  const Profile({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      bottomNavigationBar: const MainBottomAppBar(),
      appBar: PreferredSize(
          preferredSize: const Size.fromHeight(50),
          child: AppBar(
            title: const Text('Inspired Senior Care'),
          )),
      body: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 16.0, vertical: 12.0),
        child: ListView(
          shrinkWrap: true,
          children: const [
            Padding(
              padding: EdgeInsets.symmetric(vertical: 12.0),
              child: NamePlate(
                memberName: 'Samantha Torres',
                memberTitle: 'Assistant',
              ),
            ),
            Badges(),
            Padding(
              padding: EdgeInsets.symmetric(vertical: 16.0),
              child: ProgressSection(),
            )
          ],
        ),
      ),
    );
  }
}

class Badges extends StatelessWidget {
  const Badges({
    Key? key,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      height: 100,
      child: Card(
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceEvenly,
          children: [
            Wrap(
              direction: Axis.vertical,
              crossAxisAlignment: WrapCrossAlignment.center,
              spacing: 5,
              children: const [
                Icon(
                  FontAwesomeIcons.star,
                  size: 28,
                ),
                Text('New Member')
              ],
            ),
            const VerticalDivider(
              indent: 20,
              endIndent: 20,
            ),
            Wrap(
              direction: Axis.vertical,
              crossAxisAlignment: WrapCrossAlignment.center,
              spacing: 5,
              children: const [
                Icon(
                  FontAwesomeIcons.fire,
                  color: Colors.deepOrangeAccent,
                  size: 28,
                ),
                Text('On Fire!')
              ],
            ),
            const VerticalDivider(
              indent: 20,
              endIndent: 20,
            ),
            Wrap(
              direction: Axis.vertical,
              crossAxisAlignment: WrapCrossAlignment.center,
              spacing: 5,
              children: [
                Icon(
                  FontAwesomeIcons.medal,
                  color: Colors.grey.shade400,
                  size: 28,
                ),
                Text(
                  'Earn More!',
                  style: TextStyle(color: Colors.grey.shade400),
                )
              ],
            ),
          ],
        ),
      ),
    );
  }
}
