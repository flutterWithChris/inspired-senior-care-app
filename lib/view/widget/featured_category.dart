import 'dart:math';

import 'package:cached_network_image/cached_network_image.dart';
import 'package:cron/cron.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';
import 'package:inspired_senior_care_app/bloc/cards/card_bloc.dart';
import 'package:inspired_senior_care_app/bloc/categories/categories_bloc.dart';
import 'package:inspired_senior_care_app/bloc/profile/profile_bloc.dart';
import 'package:inspired_senior_care_app/cubits/groups/featured_category_cubit.dart';
import 'package:inspired_senior_care_app/data/models/category.dart';
import 'package:inspired_senior_care_app/data/models/user.dart';
import 'package:loading_animation_widget/loading_animation_widget.dart';
import 'package:shared_preferences/shared_preferences.dart';

class FeaturedCategory extends StatefulWidget {
  const FeaturedCategory({
    Key? key,
  }) : super(key: key);

  @override
  State<FeaturedCategory> createState() => _FeaturedCategoryState();
}

class _FeaturedCategoryState extends State<FeaturedCategory> {
  @override
  Widget build(BuildContext context) {
    return BlocBuilder<ProfileBloc, ProfileState>(
      builder: (context, state) {
        if (state is ProfileLoading) {
          return Center(
            child: LoadingAnimationWidget.fourRotatingDots(
                color: Colors.blue, size: 30),
          );
        }
        /*  if (state is ProfileFailed) {
          return const Center(
            child: Text('Error Fetching Featured Category!'),
          );
        }*/
        if (state is ProfileLoaded) {
          User currentUser = state.user;
          return BlocBuilder<CategoriesBloc, CategoriesState>(
            builder: (context, state) {
              if (state is CategoriesLoading) {
                return Center(
                  child: LoadingAnimationWidget.fourRotatingDots(
                      color: Colors.blue, size: 30),
                );
              }
              if (state is CategoriesFailed) {
                return const Center(
                  child: Text('Error Fetching Categories'),
                );
              }
              if (state is CategoriesLoaded) {
                List<Category> categories = state.categories;

                if (currentUser.groups!.isNotEmpty) {
                  context
                      .read<FeaturedCategoryCubit>()
                      .loadFeaturedCategoryById(currentUser.groups!.first);
                  return BlocBuilder<FeaturedCategoryCubit,
                      FeaturedCategoryState>(
                    builder: (context, state) {
                      if (state is FeaturedCategoryLoading) {
                        return Center(
                          child: LoadingAnimationWidget.fourRotatingDots(
                              color: Colors.blue, size: 30),
                        );
                      }
                      if (state is FeaturedCategoryFailed) {
                        return const Center(
                          child: Text('Error Fetching Category!'),
                        );
                      }
                      if (state is FeaturedCategoryLoaded) {
                        Category featuredCategory = categories.singleWhere(
                          (category) =>
                              category.name == state.featuredCategoryName,
                        );
                        int progress =
                            currentUser.progress![state.featuredCategoryName] ??
                                0;
                        return Column(
                          children: [
                            InkWell(
                              splashColor: Colors.lightBlueAccent,
                              onTap: (() {
                                BlocProvider.of<CardBloc>(context)
                                    .add(LoadCards(category: featuredCategory));
                                context.goNamed('deck-page');
                              }),
                              child: Card(
                                child: LayoutBuilder(
                                  builder: (context, constraints) {
                                    return ConstrainedBox(
                                      constraints: BoxConstraints(
                                          maxWidth: constraints.maxWidth > 700
                                              ? 350
                                              : 275),
                                      child: Container(
                                        color: Colors.white,
                                        child: Padding(
                                          padding: const EdgeInsets.all(12.0),
                                          child: Stack(
                                            clipBehavior: Clip.none,
                                            alignment:
                                                AlignmentDirectional.topEnd,
                                            children: [
                                              SizedBox(
                                                child: CachedNetworkImage(
                                                  imageUrl: featuredCategory
                                                      .coverImageUrl,
                                                ),
                                              ),
                                              Positioned(
                                                top: -35,
                                                right: -25,
                                                child: CircleAvatar(
                                                  radius: 35,
                                                  backgroundColor: Colors.white,
                                                  child: CircleAvatar(
                                                    radius: 30,
                                                    backgroundColor:
                                                        featuredCategory
                                                            .progressColor,
                                                    child: Text(
                                                      '${(progress / featuredCategory.totalCards! * 100).toStringAsFixed(0)}%',
                                                      style: const TextStyle(
                                                          color: Colors.white,
                                                          fontSize: 18,
                                                          fontWeight:
                                                              FontWeight.bold),
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
                                ),
                              ),
                            ),
                            SeeMoreButton(featuredCategory: featuredCategory),
                          ],
                        );
                      }
                      return const Center(
                        child: Text('Something Went Wrong!'),
                      );
                    },
                  );
                } else {
                  Random random = Random();
                  final Cron cron = Cron();
                  int randomInt = 2;
                  _getRandomCategoryMonthly() {
                    cron.schedule(Schedule.parse('15 * * * * *'), () async {
                      SharedPreferences prefs =
                          await SharedPreferences.getInstance();
                      randomInt = random.nextInt(categories.length);
                      prefs.setInt('randomFeaturedCategory', randomInt);
                      print(randomInt);
                    });
                  }

                  final Category featuredCategory = categories[randomInt];
                  int progress =
                      currentUser.progress![featuredCategory.name] ?? 0;
                  return FutureBuilder(
                      future: SharedPreferences.getInstance(),
                      builder: (context, snapshot) {
                        return Column(
                          children: [
                            InkWell(
                              splashColor: Colors.lightBlueAccent,
                              onTap: (() {
                                context.goNamed('deck-page');
                                BlocProvider.of<CardBloc>(context)
                                    .add(LoadCards(category: featuredCategory));
                              }),
                              child: Card(
                                child: LayoutBuilder(
                                  builder: (context, constraints) {
                                    return ConstrainedBox(
                                      constraints: BoxConstraints(
                                          maxWidth: constraints.maxWidth > 700
                                              ? 350
                                              : 275),
                                      child: Container(
                                        color: Colors.white,
                                        child: Padding(
                                          padding: const EdgeInsets.all(12.0),
                                          child: Stack(
                                            clipBehavior: Clip.none,
                                            alignment:
                                                AlignmentDirectional.topEnd,
                                            children: [
                                              SizedBox(
                                                child: CachedNetworkImage(
                                                  imageUrl: featuredCategory
                                                      .coverImageUrl,
                                                ),
                                              ),
                                              Positioned(
                                                top: -35,
                                                right: -25,
                                                child: CircleAvatar(
                                                  radius: 35,
                                                  backgroundColor: Colors.white,
                                                  child: CircleAvatar(
                                                    radius: 30,
                                                    backgroundColor:
                                                        featuredCategory
                                                            .progressColor,
                                                    child: Text(
                                                      '${(progress / featuredCategory.totalCards! * 100).toStringAsFixed(0)}%',
                                                      style: const TextStyle(
                                                          color: Colors.white,
                                                          fontSize: 18,
                                                          fontWeight:
                                                              FontWeight.bold),
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
                                ),
                              ),
                            ),
                            SeeMoreButton(featuredCategory: featuredCategory),
                          ],
                        );
                      });
                }
              }
              return const Center(
                child: Text('Something Went Wrong!'),
              );
            },
          );
        } else {
          return const Center(
            child: Text('Something Went Wrong'),
          );
        }
      },
    );
  }
}

class SeeMoreButton extends StatelessWidget {
  final Category featuredCategory;
  const SeeMoreButton({
    required this.featuredCategory,
    Key? key,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 8.0),
      child: ElevatedButton(
        onPressed: (() {
          BlocProvider.of<CardBloc>(context)
              .add(LoadCards(category: featuredCategory));
          context.goNamed('deck-page');
        }),
        style: ElevatedButton.styleFrom(fixedSize: const Size(200, 30)),
        child: const Text(
          'See More',
          style: TextStyle(fontSize: 16),
        ),
      ),
    );
  }
}
