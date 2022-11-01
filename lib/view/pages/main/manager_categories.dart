import 'dart:math';

import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:go_router/go_router.dart';
import 'package:inspired_senior_care_app/bloc/cards/card_bloc.dart';
import 'package:inspired_senior_care_app/bloc/categories/categories_bloc.dart';
import 'package:inspired_senior_care_app/data/models/category.dart';
import 'package:inspired_senior_care_app/view/pages/IAP/upgrade_page.dart';
import 'package:inspired_senior_care_app/view/widget/main/bottom_app_bar.dart';
import 'package:inspired_senior_care_app/view/widget/main/main_app_drawer.dart';

import 'package:loading_animation_widget/loading_animation_widget.dart';
import 'package:once/once.dart';

import '../../widget/main/top_app_bar.dart';

class ManagerCategories extends StatelessWidget {
  const ManagerCategories({Key? key}) : super(key: key);

  static Route route() {
    return MaterialPageRoute<void>(builder: (_) => const ManagerCategories());
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      drawer: const MainAppDrawer(),
      bottomNavigationBar: const MainBottomAppBar(),
      appBar: const PreferredSize(
        preferredSize: Size.fromHeight(60),
        child: MainTopAppBar(),
      ),
      body: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 8.0),
        child: BlocBuilder<CategoriesBloc, CategoriesState>(
          builder: (context, state) {
            if (state is CategoriesLoading) {
              return Center(
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    LoadingAnimationWidget.inkDrop(
                        color: Colors.blueAccent, size: 30.0),
                    const SizedBox(
                      height: 8.0,
                    ),
                    const Text('Loading Categories...')
                  ],
                ),
              );
            }
            if (state is CategoriesLoaded) {
              List<Category> allCategories = state.categories;
              int categoryCount = state.categoryImageUrls.length;
              // Shuffle Categories Weekly
              Once.runWeekly(
                'shuffleCategories',
                callback: () {
                  allCategories.shuffle();
                },
              );
              final List<CategoryCard> categoryCards = [
                for (Category category in allCategories)
                  CategoryCard(category: category),
              ];

              return ListView(
                physics: const ScrollPhysics(),
                shrinkWrap: true,
                children: [
                  Padding(
                    padding: const EdgeInsets.symmetric(
                        vertical: 24.0, horizontal: 8.0),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Text(
                          'All Categories',
                          style: Theme.of(context)
                              .textTheme
                              .headlineMedium!
                              .copyWith(color: Colors.black87, fontSize: 32),
                        ),
                        SizedBox(
                          height: 40,
                          width: 140,
                          child: FittedBox(
                            child: PopupMenuButton(
                              position: PopupMenuPosition.under,
                              itemBuilder: (context) {
                                return [
                                  PopupMenuItem(
                                    child: const Text('Share Mode'),
                                    onTap: () {
                                      context
                                          .goNamed('manager-categories-share');
                                    },
                                  )
                                ];
                              },
                              child: IgnorePointer(
                                child: ElevatedButton.icon(
                                    style: ElevatedButton.styleFrom(
                                        minimumSize: const Size(0, 0),
                                        fixedSize: const Size(140, 42)),
                                    onPressed: () {},
                                    label: const Text('View Mode'),
                                    icon: const Icon(
                                      FontAwesomeIcons.eye,
                                      size: 12.0,
                                    )),
                              ),
                            ),
                          ),
                        )
                      ],
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
                        return categoryCards[index];
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
    );
  }
}

class CategoryCard extends StatelessWidget {
  final Category category;

  Random random = Random();

  CategoryCard({
    Key? key,
    required this.category,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final Color progressBasedColor;
    double percentComplete = 0.0;

    Color randomColor = Color.fromRGBO(
        random.nextInt(255), random.nextInt(255), random.nextInt(255), 1);
    return BlocBuilder<CategoriesBloc, CategoriesState>(
      builder: (context, state) {
        if (state is CategoriesLoading) {
          return Center(
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                LoadingAnimationWidget.inkDrop(
                    color: Colors.blueAccent, size: 30.0),
                const Text('Loading...')
              ],
            ),
          );
        }
        if (state is CategoriesLoaded) {
          return BlocBuilder<CardBloc, CardState>(
            builder: (context, state) {
              return InkWell(
                onTap: () {
                  BlocProvider.of<CardBloc>(context)
                      .add(LoadCards(category: category));

                  context.goNamed('manager-deck-page');
                },
                child: Card(
                  shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(12.0)),
                  child: Padding(
                    padding: const EdgeInsets.all(16.0),
                    child: CachedNetworkImage(
                      placeholder: (context, url) => Center(
                        child: LoadingAnimationWidget.inkDrop(
                            color: Colors.blueAccent, size: 30.0),
                      ),
                      imageUrl: category.coverImageUrl,
                      height: 250,
                      fit: BoxFit.fitHeight,
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
        shape:
            RoundedRectangleBorder(borderRadius: BorderRadius.circular(12.0)),
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
