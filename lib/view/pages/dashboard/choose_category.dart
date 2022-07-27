import 'dart:math';

import 'package:flutter/material.dart';
import 'package:infinite_carousel/infinite_carousel.dart';
import 'package:inspired_senior_care_app/view/widget/bottom_app_bar.dart';
import 'package:inspired_senior_care_app/view/widget/top_app_bar.dart';

class ChooseCategory extends StatefulWidget {
  const ChooseCategory({Key? key}) : super(key: key);

  @override
  State<ChooseCategory> createState() => _ChooseCategoryState();
}

class _ChooseCategoryState extends State<ChooseCategory> {
  @override
  Widget build(BuildContext context) {
    final List<DashboardCategoryCard> categories = [
      DashboardCategoryCard(
        progressColor: Colors.lightBlueAccent,
        assetName: 'Positive_Interactions.png',
        textColor: Colors.black87,
        progress: '4/12',
      ),
      DashboardCategoryCard(
        progressColor: Colors.tealAccent,
        progress: '14/14',
        assetName: 'Communication.png',
        textColor: Colors.black87,
      ),
      DashboardCategoryCard(
        progressColor: Colors.grey,
        assetName: 'Supportive_Environment.png',
        progress: '8/11',
      ),
      DashboardCategoryCard(
        progressColor: Colors.red,
        progress: '3/18',
        assetName: 'Brain_Change.png',
      ),
      DashboardCategoryCard(
        progressColor: Colors.red,
        progress: '3/18',
        assetName: 'Damaging_Interactions.png',
      ),
      DashboardCategoryCard(
        progressColor: Colors.red,
        progress: '3/18',
        assetName: 'Genuine_Relationships.png',
      ),
      DashboardCategoryCard(
        progressColor: Colors.red,
        progress: '3/18',
        assetName: 'Language_Matters.png',
      ),
      DashboardCategoryCard(
        progressColor: Colors.red,
        progress: '3/18',
        assetName: 'Strengths_Based.png',
      ),
      DashboardCategoryCard(
        progressColor: Colors.red,
        progress: '3/18',
        assetName: 'Building_Blocks_2.png',
      ),
      DashboardCategoryCard(
        progressColor: Colors.red,
        progress: '3/18',
        assetName: 'Meaningful_Engagement.png',
      ),
      DashboardCategoryCard(
        progressColor: Colors.red,
        progress: '3/18',
        assetName: 'Well_Being.png',
      ),
      DashboardCategoryCard(
        progressColor: Colors.red,
        progress: '3/18',
        assetName: 'What_if.png',
      ),
      DashboardCategoryCard(
        progressColor: Colors.red,
        progress: '3/18',
        assetName: 'Wildly_Curious.png',
      ),
    ];
    return SafeArea(
      child: Scaffold(
        bottomNavigationBar: const MainBottomAppBar(),
        appBar: const PreferredSize(
          preferredSize: Size.fromHeight(50),
          child: MainTopAppBar(),
        ),
        body: Center(
          child: Padding(
            padding: const EdgeInsets.only(bottom: 60.0),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Padding(
                  padding: const EdgeInsets.symmetric(vertical: 16.0),
                  child: Text(
                    'Change Featured Category:',
                    style: Theme.of(context).textTheme.headline5,
                  ),
                ),
                Center(
                  child: SizedBox(
                    height: 275,
                    child: Stack(
                      alignment: AlignmentDirectional.center,
                      children: [
                        InfiniteCarousel.builder(
                          onIndexChanged: (p0) {
                            DashboardCategoryCard currentCategory =
                                categories[p0];
                            setState(() {
                              currentCategory.selected = true;
                            });
                          },
                          velocityFactor: 0.5,
                          itemCount: categories.length,
                          itemExtent: 175,
                          itemBuilder: (context, itemIndex, realIndex) {
                            return categories[itemIndex];
                          },
                        ),
                        IgnorePointer(
                          child: Card(
                              semanticContainer: false,
                              elevation: 0,
                              color: Colors.transparent,
                              shape: RoundedRectangleBorder(
                                  side: const BorderSide(
                                      color: Colors.lightBlueAccent,
                                      width: 4.0),
                                  borderRadius: BorderRadius.circular(4.0)),
                              child: const SizedBox(
                                width: 168,
                                height: 300,
                              )),
                        ),
                      ],
                    ),
                  ),
                ),
                Padding(
                  padding: const EdgeInsets.symmetric(vertical: 8.0),
                  child: ElevatedButton(
                      onPressed: () {}, child: const Text('Set Category')),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}

class DashboardCategoryCard extends StatefulWidget {
  String assetName;
  Color progressColor;
  Color? textColor;
  String progress;
  bool? selected;

  DashboardCategoryCard({
    Key? key,
    this.selected,
    required this.assetName,
    required this.progressColor,
    required this.progress,
    this.textColor,
  }) : super(key: key);

  @override
  State<DashboardCategoryCard> createState() => _DashboardCategoryCardState();
}

class _DashboardCategoryCardState extends State<DashboardCategoryCard> {
  Random random = Random();

  @override
  Widget build(BuildContext context) {
    final Color progressBasedColor;
    Color randomColor = Color.fromRGBO(
        random.nextInt(255), random.nextInt(255), random.nextInt(255), 1);
    return InkWell(
      onTap: () {
        if (widget.selected == true) {
          setState(() {
            widget.selected = false;
          });
        } else if (widget.selected == false) {
          setState(() {
            widget.selected = true;
          });
        }
      },
      child: Card(
        shape: widget.selected == true
            ? RoundedRectangleBorder(
                side: const BorderSide(color: Colors.blue, width: 4.0),
                borderRadius: BorderRadius.circular(4.0))
            : null,
        child: Image.asset(
          'lib/assets/card_covers/${widget.assetName}',
          height: 300,
          fit: BoxFit.fitHeight,
        ),
      ),
    );
  }
}
