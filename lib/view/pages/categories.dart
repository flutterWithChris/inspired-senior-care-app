import 'dart:math';
import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:inspired_senior_care_app/view/widget/bottom_app_bar.dart';

class Categories extends StatelessWidget {
  const Categories({Key? key}) : super(key: key);

  static Route route() {
    return MaterialPageRoute<void>(builder: (_) => const Categories());
  }

  @override
  Widget build(BuildContext context) {
    final List<dynamic> categories = [
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
        assetName: 'Brain_Change.png',
      ),
      CategoryCard(
        progressColor: Colors.red,
        progress: '3/18',
        assetName: 'Damaging_Interactions.png',
      ),
      CategoryCard(
        progressColor: Colors.red,
        progress: '3/18',
        assetName: 'Genuine_Relationships.png',
      ),
      LockedCategoryCard(
        progressColor: Colors.red,
        progress: '3/18',
        assetName: 'Language_Matters.png',
      ),
      LockedCategoryCard(
        progressColor: Colors.red,
        progress: '3/18',
        assetName: 'Strengths_Based.png',
      ),
      LockedCategoryCard(
        progressColor: Colors.red,
        progress: '3/18',
        assetName: 'Building_Blocks_2.png',
      ),
      LockedCategoryCard(
        progressColor: Colors.red,
        progress: '3/18',
        assetName: 'Meaningful_Engagement.png',
      ),
      LockedCategoryCard(
        progressColor: Colors.red,
        progress: '3/18',
        assetName: 'Well_Being.png',
      ),
      LockedCategoryCard(
        progressColor: Colors.red,
        progress: '3/18',
        assetName: 'What_if.png',
      ),
      LockedCategoryCard(
        progressColor: Colors.red,
        progress: '3/18',
        assetName: 'Wildly_Curious.png',
      ),
    ];
    List<String> titleList = [];
    for (int i = 0; i < categories.length; i++) {
      titleList.add('');
    }
    return SafeArea(
      child: Scaffold(
        bottomNavigationBar: const MainBottomAppBar(),
        appBar: PreferredSize(
          preferredSize: const Size.fromHeight(50),
          child: AppBar(title: const Text('Inspired Senior Care')),
        ),
        body: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 8.0),
          child: ListView(
            physics: const ScrollPhysics(),
            shrinkWrap: true,
            children: [
              Padding(
                padding: const EdgeInsets.symmetric(
                    vertical: 18.0, horizontal: 12.0),
                child: Text(
                  'All Categories >',
                  style: Theme.of(context).textTheme.titleLarge,
                ),
              ),
              LayoutBuilder(builder: (context, constraints) {
                int crossAxisCount = constraints.maxWidth > 500 ? 4 : 2;
                return GridView.builder(
                  physics: const ScrollPhysics(),
                  itemCount: categories.length,
                  shrinkWrap: true,
                  gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                      crossAxisSpacing: 6.0,
                      mainAxisExtent: 285,
                      mainAxisSpacing: 8.0,
                      crossAxisCount: crossAxisCount),
                  itemBuilder: (context, index) {
                    return categories[index];
                  },
                );
              }),
            ],
          ),
        ),
      ),
    );
  }
}

class CategoryCard extends StatelessWidget {
  String assetName;
  Color progressColor;
  Color? textColor;
  String progress;
  Random random = Random();

  CategoryCard({
    Key? key,
    required this.assetName,
    required this.progressColor,
    required this.progress,
    this.textColor,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final Color progressBasedColor;
    Color randomColor = Color.fromRGBO(
        random.nextInt(255), random.nextInt(255), random.nextInt(255), 1);
    return InkWell(
      onTap: () => context.goNamed('deck-page'),
      child: Card(
        child: Container(
          color: Colors.white,
          height: 275,
          child: Stack(
            alignment: AlignmentDirectional.center,
            children: [
              Positioned(
                  top: 15,
                  child: Image.asset(
                    'lib/assets/card_covers/$assetName',
                    height: 250,
                    fit: BoxFit.fitHeight,
                  )),
              Positioned(
                top: 5,
                right: 2,
                child: CircleAvatar(
                  radius: 26,
                  backgroundColor: Colors.white,
                  child: CircleAvatar(
                    radius: 23,
                    backgroundColor: randomColor,
                    child: Text(
                      '${random.nextInt(16)}/16',
                      style: const TextStyle(
                          fontWeight: FontWeight.bold, fontSize: 14),
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

class LockedCategoryCard extends StatelessWidget {
  String assetName;
  Color progressColor;
  Color? textColor;
  String progress;
  Random random = Random();

  LockedCategoryCard({
    Key? key,
    required this.assetName,
    required this.progressColor,
    required this.progress,
    this.textColor,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final Color progressBasedColor;
    Color randomColor = Color.fromRGBO(
        random.nextInt(255), random.nextInt(255), random.nextInt(255), 1);
    return InkWell(
      onTap: () => context.goNamed('deck-page'),
      child: Card(
        child: Container(
          color: Colors.white,
          height: 275,
          child: Stack(
            alignment: AlignmentDirectional.center,
            children: [
              Stack(
                alignment: AlignmentDirectional.center,
                children: [
                  Positioned(
                      top: 15,
                      child: SizedBox(
                        height: 250,
                        child: Image.asset('lib/assets/card_covers/$assetName'),
                      )),
                  Positioned(
                    top: 5,
                    right: 2,
                    child: CircleAvatar(
                      radius: 26,
                      backgroundColor: Colors.white,
                      child: CircleAvatar(
                        radius: 23,
                        backgroundColor: randomColor,
                        child: Text(
                          '${random.nextInt(16)}/16',
                          style: const TextStyle(
                              fontWeight: FontWeight.bold, fontSize: 14),
                        ),
                      ),
                    ),
                  )
                ],
              ),
              Stack(
                alignment: AlignmentDirectional.center,
                children: [
                  Container(
                    color: Colors.black45,
                    height: 275,
                  ),
                  Padding(
                    padding: const EdgeInsets.only(bottom: 30),
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Icon(
                          Icons.lock_outline_rounded,
                          color: Colors.grey.shade200,
                          size: 60,
                        ),
                        const Text(
                          'Unlock Now!',
                          style: TextStyle(
                              color: Colors.white, fontWeight: FontWeight.bold),
                        )
                      ],
                    ),
                  )
                ],
              )
            ],
          ),
        ),
      ),
    );
  }
}
