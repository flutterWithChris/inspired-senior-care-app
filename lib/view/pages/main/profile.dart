import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:inspired_senior_care_app/bloc/profile/profile_bloc.dart';
import 'package:inspired_senior_care_app/globals.dart';
import 'package:inspired_senior_care_app/view/widget/group_chips.dart';

import 'package:inspired_senior_care_app/view/widget/main/bottom_app_bar.dart';
import 'package:inspired_senior_care_app/view/widget/main/main_app_drawer.dart';
import 'package:inspired_senior_care_app/view/widget/main/top_app_bar.dart';

import 'package:inspired_senior_care_app/view/widget/name_plate.dart';
import 'package:inspired_senior_care_app/view/widget/progress_widgets.dart';
import 'package:showcaseview/showcaseview.dart';

class Profile extends StatefulWidget {
  const Profile({Key? key}) : super(key: key);

  @override
  State<Profile> createState() => _ProfileState();
}

class _ProfileState extends State<Profile> {
  final GlobalKey progressShowcaseKey = GlobalKey();
  BuildContext? showcaseBuildContext;

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
  }

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
          return FutureBuilder<bool?>(
              future: checkSpotlightStatus('profileShowcaseDone'),
              builder: (context, snapshot) {
                var data = snapshot.data;
                if (snapshot.connectionState == ConnectionState.done &&
                    (data == null || data == false)) {
                  WidgetsBinding.instance.addPostFrameCallback((timeStamp) {
                    ShowCaseWidget.of(showcaseBuildContext!)
                        .startShowCase([progressShowcaseKey]);
                  });
                }
                return ShowCaseWidget(onFinish: () async {
                  await setSpotlightStatusToComplete('profileShowcaseDone');
                }, builder: Builder(
                  builder: (context) {
                    showcaseBuildContext = context;
                    return Scaffold(
                      drawer: const MainAppDrawer(),
                      bottomNavigationBar: const MainBottomAppBar(),
                      appBar: const PreferredSize(
                          preferredSize: Size.fromHeight(60),
                          child: MainTopAppBar()),
                      body: Padding(
                        padding: const EdgeInsets.symmetric(horizontal: 16.0),
                        child: ListView(
                          controller: pageScrollController,
                          //  shrinkWrap: true,
                          children: [
                            Padding(
                              padding: const EdgeInsets.only(top: 12.0),
                              child: NamePlate(
                                user: state.user,
                                memberName: state.user.name!,
                                memberTitle: state.user.title!,
                                memberColorHex: state.user.userColor!,
                              ),
                            ),
                            const GroupChips(),
                            //const Badges(),
                            Padding(
                              padding:
                                  const EdgeInsets.symmetric(vertical: 16.0),
                              child: Showcase(
                                targetBorderRadius: const BorderRadius.all(
                                    Radius.circular(20.0)),
                                descriptionAlignment: TextAlign.center,
                                targetPadding: const EdgeInsets.only(
                                    top: 4.0,
                                    left: 8.0,
                                    right: 8.0,
                                    bottom: -1220),
                                key: progressShowcaseKey,
                                description:
                                    'Here you can track your progress in each category!',
                                child: ProgressSection(
                                  pageScrollController: pageScrollController,
                                ),
                              ),
                            )
                          ],
                        ),
                      ),
                    );
                  },
                ));
              });
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
