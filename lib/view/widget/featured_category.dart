import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:flutter_animate/flutter_animate.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';
import 'package:inspired_senior_care_app/bloc/cards/card_bloc.dart';
import 'package:inspired_senior_care_app/bloc/categories/categories_bloc.dart';
import 'package:inspired_senior_care_app/bloc/profile/profile_bloc.dart';
import 'package:inspired_senior_care_app/cubits/groups/featured_category_cubit.dart';
import 'package:inspired_senior_care_app/data/models/category.dart';
import 'package:inspired_senior_care_app/data/models/user.dart';
import 'package:loading_animation_widget/loading_animation_widget.dart';

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
    User currentUser = context.watch<ProfileBloc>().state.user;
    // CategoriesBloc categoriesState = context.read<CategoriesBloc>();
    CategoriesState categoriesState = context.watch<CategoriesBloc>().state;

    return BlocBuilder<FeaturedCategoryCubit, FeaturedCategoryState>(
      builder: (context, state) {
        if (state is FeaturedCategoryLoading ||
            categoriesState is CategoriesLoading) {
          return Column(
            children: [
              InkWell(
                splashColor: Colors.lightBlueAccent,
                child: Card(
                  child: LayoutBuilder(
                    builder: (context, constraints) {
                      return ConstrainedBox(
                        constraints: BoxConstraints(
                            maxWidth: constraints.maxWidth > 700 ? 350 : 275),
                        child: Animate(
                          onComplete: (controller) {
                            controller.repeat();
                          },
                          effects: const [ShimmerEffect()],
                          child: Container(
                            color: Colors.white,
                            child: Padding(
                              padding: const EdgeInsets.all(12.0),
                              child: Stack(
                                clipBehavior: Clip.none,
                                alignment: AlignmentDirectional.topEnd,
                                children: [
                                  SizedBox(
                                      height: 400,
                                      width: 350,
                                      child: Container(
                                        color: Colors.grey.shade300,
                                        child: Center(
                                            child:
                                                LoadingAnimationWidget.inkDrop(
                                                    color: Theme.of(context)
                                                        .primaryColor,
                                                    size: 30)),
                                      )),
                                  const Positioned(
                                    top: -35,
                                    right: -25,
                                    child: CircleAvatar(
                                      radius: 35,
                                      backgroundColor: Colors.white,
                                      child: CircleAvatar(
                                        radius: 30,
                                        backgroundColor: Colors.blueGrey,
                                      ),
                                    ),
                                  )
                                ],
                              ),
                            ),
                          ),
                        ),
                      );
                    },
                  ),
                ),
              ),
              const SeeMoreButton(),
            ],
          );
        }
        if (state is FeaturedCategoryFailed ||
            categoriesState is CategoriesFailed) {
          return const Center(
            child: Text('Error Fetching Category!'),
          );
        }
        if (state is FeaturedCategoryLoaded &&
            categoriesState is CategoriesLoaded) {
          Category featuredCategory = categoriesState.categories.singleWhere(
            (category) => category.name == state.featuredCategoryName,
          );
          int progress = currentUser.progress![state.featuredCategoryName] ?? 0;
          return Column(
            children: [
              InkWell(
                splashColor: Colors.lightBlueAccent,
                onTap: (() {
                  BlocProvider.of<CardBloc>(context)
                      .add(LoadCards(category: featuredCategory));
                  context.goNamed('deck-page');
                }),
                child: Animate(
                  effects: const [ShimmerEffect()],
                  child: Card(
                    child: LayoutBuilder(
                      builder: (context, constraints) {
                        return ConstrainedBox(
                          constraints: BoxConstraints(
                              maxWidth: constraints.maxWidth > 700 ? 350 : 275),
                          child: Container(
                            color: Colors.white,
                            child: Padding(
                              padding: const EdgeInsets.all(12.0),
                              child: Stack(
                                clipBehavior: Clip.none,
                                alignment: AlignmentDirectional.topEnd,
                                children: [
                                  SizedBox(
                                    child: CachedNetworkImage(
                                      imageUrl: featuredCategory.coverImageUrl,
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
                                            featuredCategory.progressColor,
                                        child: Text(
                                          '${(progress / featuredCategory.totalCards! * 100).toStringAsFixed(0)}%',
                                          style: const TextStyle(
                                              color: Colors.white,
                                              fontSize: 18,
                                              fontWeight: FontWeight.bold),
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
  }
}

class SeeMoreButton extends StatelessWidget {
  final Category? featuredCategory;
  const SeeMoreButton({
    this.featuredCategory,
    Key? key,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 8.0),
      child: ElevatedButton(
        onPressed: (() {
          BlocProvider.of<CardBloc>(context)
              .add(LoadCards(category: featuredCategory!));
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