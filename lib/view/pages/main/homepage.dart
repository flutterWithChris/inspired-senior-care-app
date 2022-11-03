import 'package:flutter/material.dart';
import 'package:inspired_senior_care_app/view/widget/featured_category.dart';
import 'package:inspired_senior_care_app/view/widget/main/bottom_app_bar.dart';
import 'package:inspired_senior_care_app/view/widget/main/main_app_drawer.dart';
import 'package:inspired_senior_care_app/view/widget/main/top_app_bar.dart';
import 'package:showcaseview/showcaseview.dart';
import 'package:upgrader/upgrader.dart';

class MyHomePage extends StatefulWidget {
  const MyHomePage({super.key});

  @override
  State<MyHomePage> createState() => _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage> {
  final GlobalKey featuredCategoryShowcaseKey = GlobalKey();
  BuildContext? showcaseBuildContext;

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((timeStamp) {
      ShowCaseWidget.of(showcaseBuildContext!)
          .startShowCase([featuredCategoryShowcaseKey]);
    });
  }

  @override
  Widget build(BuildContext context) {
    return ShowCaseWidget(builder: Builder(builder: (context) {
      showcaseBuildContext = context;
      return UpgradeAlert(
        upgrader: Upgrader(
          shouldPopScope: () => true,
        ),
        child: Scaffold(
          drawer: const MainAppDrawer(),
          bottomNavigationBar: const MainBottomAppBar(),
          appBar: const PreferredSize(
            preferredSize: Size.fromHeight(60),
            child: MainTopAppBar(),
          ),
          body: Center(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: <Widget>[
                const Padding(
                  padding: EdgeInsets.only(top: 16.0, bottom: 24.0),
                  child: Text(
                    'Monthly Category',
                    style: TextStyle(fontSize: 30),
                  ),
                ),
                Showcase(
                    targetBorderRadius:
                        const BorderRadius.all(Radius.circular(20.0)),
                    descriptionAlignment: TextAlign.center,
                    targetPadding: const EdgeInsets.only(
                        top: 24.0, left: 16.0, right: 16.0),
                    description:
                        'Each Monthly Category provides a new topic to help support you as you support your clients.',
                    key: featuredCategoryShowcaseKey,
                    child: const FeaturedCategory()),
              ],
            ),
          ),
        ),
      );
    }));
  }
}
