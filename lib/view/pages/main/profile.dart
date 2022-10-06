import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:inspired_senior_care_app/bloc/profile/profile_bloc.dart';

import 'package:inspired_senior_care_app/view/widget/main/bottom_app_bar.dart';
import 'package:inspired_senior_care_app/view/widget/main/main_app_drawer.dart';
import 'package:inspired_senior_care_app/view/widget/main/top_app_bar.dart';

import 'package:inspired_senior_care_app/view/widget/name_plate.dart';
import 'package:inspired_senior_care_app/view/widget/progress_widgets.dart';

class Profile extends StatelessWidget {
  const Profile({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final ScrollController pageScrollController = ScrollController();
    return BlocBuilder<ProfileBloc, ProfileState>(
      builder: (context, state) {
        if (state is ProfileLoading) {
          return const Center(
            child: CircularProgressIndicator(),
          );
        }
        if (state is ProfileLoaded) {
          return SafeArea(
            child: Scaffold(
              drawer: const MainAppDrawer(),
              bottomNavigationBar: const MainBottomAppBar(),
              appBar: const PreferredSize(
                  preferredSize: Size.fromHeight(60), child: MainTopAppBar()),
              body: Padding(
                padding: const EdgeInsets.symmetric(horizontal: 16.0),
                child: ListView(
                  controller: pageScrollController,
                  shrinkWrap: true,
                  children: [
                    Padding(
                      padding: const EdgeInsets.symmetric(vertical: 12.0),
                      child: NamePlate(
                        user: state.user,
                        memberName: state.user.name!,
                        memberTitle: state.user.title!,
                        memberColorHex: state.user.userColor!,
                      ),
                    ),
                    //const Badges(),
                    Padding(
                      padding: const EdgeInsets.symmetric(vertical: 16.0),
                      child: ProgressSection(
                        pageScrollController: pageScrollController,
                      ),
                    )
                  ],
                ),
              ),
            ),
          );
        } else {
          return const Center(
            child: Text('Something Went Wrong!...'),
          );
        }
      },
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
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(33)),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceEvenly,
          children: [
            Wrap(
              direction: Axis.vertical,
              crossAxisAlignment: WrapCrossAlignment.center,
              spacing: 8.0,
              children: const [
                Icon(
                  FontAwesomeIcons.solidStarHalfStroke,
                  color: Colors.yellow,
                  size: 30,
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
              spacing: 8.0,
              children: const [
                Icon(
                  FontAwesomeIcons.fire,
                  color: Colors.deepOrangeAccent,
                  size: 30,
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
              spacing: 8.0,
              children: [
                Icon(
                  FontAwesomeIcons.medal,
                  color: Colors.grey.shade400,
                  size: 30,
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
