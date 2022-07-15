import 'package:flutter/material.dart';
import 'package:flutter_layout_grid/flutter_layout_grid.dart';
import 'package:get/get.dart';
import 'package:inspired_senior_care_app/view/pages/deck_page.dart';
import 'package:inspired_senior_care_app/view/widget/bottom_app_bar.dart';

class Categories extends StatelessWidget {
  const Categories({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      bottomNavigationBar: const MainBottomAppBar(),
      appBar: PreferredSize(
        preferredSize: const Size.fromHeight(50),
        child: AppBar(title: const Text('Inspired Senior Care')),
      ),
      body: ListView(
        physics: const ScrollPhysics(),
        shrinkWrap: true,
        children: [
          const Padding(
            padding: EdgeInsets.symmetric(vertical: 8.0, horizontal: 30),
            child: Text(
              'All Categories >',
              style: TextStyle(fontSize: 24),
            ),
          ),
          LayoutBuilder(builder: (context, constraints) {
            int crossAxisCount = constraints.maxWidth > 500 ? 4 : 2;
            return LayoutGrid(
              rowSizes: const [auto, auto],
              columnSizes:
                  crossAxisCount == 2 ? [1.fr, 1.fr] : [1.fr, 1.fr, 1.fr, 1.fr],
              rowGap: 12,
              columnGap: 5,
              children: [
                CategoryCard(
                  progressColor: Colors.lightBlueAccent,
                  assetName: 'Positive_Interactions.png',
                  textColor: Colors.black87,
                  progress: '4/12',
                ),
                CategoryCard(
                  progressColor: Colors.tealAccent,
                  progress: '14/14',
                  assetName: 'Communication.png',
                  textColor: Colors.black87,
                ),
                CategoryCard(
                  progressColor: Colors.grey,
                  assetName: 'Supportive_Environment.png',
                  progress: '8/11',
                ),
                CategoryCard(
                  progressColor: Colors.red,
                  progress: '3/18',
                  assetName: 'Brain.png',
                ),
              ],
            );
          }),
        ],
      ),
    );
  }
}

class CategoryCard extends StatelessWidget {
  String assetName;
  Color progressColor;
  Color? textColor;
  String progress;

  CategoryCard({
    Key? key,
    required this.assetName,
    required this.progressColor,
    required this.progress,
    this.textColor,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: () => Get.to(() => const DeckPage()),
      child: Card(
        child: SizedBox(
          height: 300,
          child: Stack(
            alignment: AlignmentDirectional.center,
            children: [
              Positioned(
                  top: 25,
                  child: Container(
                    decoration: BoxDecoration(boxShadow: [
                      BoxShadow(
                        color: Colors.grey.withOpacity(0.35),
                        spreadRadius: 3,
                        blurRadius: 5,
                        offset: const Offset(0, 3),
                      )
                    ]),
                    child: SizedBox(
                      height: 250,
                      child: Image.asset('lib/assets/$assetName'),
                    ),
                  )),
              Positioned(
                top: 5,
                right: 2,
                child: CircleAvatar(
                  radius: 25,
                  backgroundColor: Colors.white,
                  child: CircleAvatar(
                    radius: 20,
                    backgroundColor: progressColor,
                    child: Text(
                      progress,
                      style: TextStyle(
                          color: textColor ?? Colors.white, fontSize: 14),
                    ),
                  ),
                ),
              )
            ],
          ),
        ),
      ),
    );
  }
}
