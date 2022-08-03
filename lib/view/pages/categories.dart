import 'dart:math';

import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';
import 'package:inspired_senior_care_app/bloc/cards/card_bloc.dart';
import 'package:inspired_senior_care_app/bloc/categories/categories_bloc.dart';
import 'package:inspired_senior_care_app/data/models/category.dart';
import 'package:inspired_senior_care_app/view/pages/upgrade_page.dart';
import 'package:inspired_senior_care_app/view/widget/bottom_app_bar.dart';

class Categories extends StatelessWidget {
  const Categories({Key? key}) : super(key: key);

  static Route route() {
    return MaterialPageRoute<void>(builder: (_) => const Categories());
  }

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Scaffold(
        bottomNavigationBar: const MainBottomAppBar(),
        appBar: PreferredSize(
          preferredSize: const Size.fromHeight(50),
          child: AppBar(title: const Text('Inspired Senior Care')),
        ),
        body: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 8.0),
          child: BlocBuilder<CategoriesBloc, CategoriesState>(
            builder: (context, state) {
              if (state is CategoriesLoading) {
                return const Center(
                  child: CircularProgressIndicator(),
                );
              }
              if (state is CategoriesLoaded) {
                int categoryCount = state.categoryImageUrls.length;
                final List<dynamic> categories = [
                  for (int i = 0; i < categoryCount; i++)
                    CategoryCard(
                      categoryIndex: i,
                      category: categoryList[i],
                    ),
                ];

                return ListView(
                  physics: const ScrollPhysics(),
                  shrinkWrap: true,
                  children: [
                    Padding(
                      padding: const EdgeInsets.symmetric(
                          vertical: 18.0, horizontal: 8.0),
                      child: Text(
                        'All Categories',
                        style: Theme.of(context).textTheme.headline5,
                      ),
                    ),
                    LayoutBuilder(builder: (context, constraints) {
                      int crossAxisCount = constraints.maxWidth > 500 ? 4 : 2;
                      return GridView.builder(
                        physics: const ScrollPhysics(),
                        itemCount: categoryCount,
                        shrinkWrap: true,
                        gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                            crossAxisSpacing: 6.0,
                            mainAxisExtent: 285,
                            mainAxisSpacing: 6.0,
                            crossAxisCount: crossAxisCount),
                        itemBuilder: (context, index) {
                          return categories[index];
                        },
                      );
                    }),
                  ],
                );
              } else {
                return const Center(
                  child: Text('Something Went Wrong...'),
                );
              }
            },
          ),
        ),
      ),
    );
  }
}

class CategoryCard extends StatelessWidget {
  final Category category;
  final int categoryIndex;
  Random random = Random();

  CategoryCard({
    Key? key,
    required this.category,
    required this.categoryIndex,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final Color progressBasedColor;

    Color randomColor = Color.fromRGBO(
        random.nextInt(255), random.nextInt(255), random.nextInt(255), 1);
    return BlocBuilder<CategoriesBloc, CategoriesState>(
      builder: (context, state) {
        if (state is CategoriesLoading) {
          return const Center(
            child: CircularProgressIndicator(),
          );
        }
        if (state is CategoriesLoaded) {
          var coverURL = state.categoryImageUrls.elementAt(categoryIndex);
          return BlocBuilder<CardBloc, CardState>(
            builder: (context, state) {
              // context.read<CardBloc>().add(ResetCards());
              return InkWell(
                onTap: () {
                  context
                      .read<CardBloc>()
                      .add(LoadCards(categoryName: category.name));

                  context.goNamed('deck-page');
                },
                child: Card(
                  child: Container(
                    color: Colors.white,
                    height: 275,
                    child: Stack(
                      alignment: AlignmentDirectional.center,
                      children: [
                        Positioned(
                            top: 15,
                            child: Image.network(
                              coverURL,
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
                                '${category.completedCards}/${category.totalCards}',
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
            },
          );
        } else {
          return const Center(
            child: Text('Something Went Wrong!'),
          );
        }
      },
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
      onTap: () => showDialog(
        context: context,
        builder: (context) => const UpgradePage(),
      ),
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
                        child: const Text(
                          '0/16',
                          style: TextStyle(
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
