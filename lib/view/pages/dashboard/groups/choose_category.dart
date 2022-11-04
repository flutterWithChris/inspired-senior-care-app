import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:go_router/go_router.dart';
import 'package:infinite_carousel/infinite_carousel.dart';
import 'package:inspired_senior_care_app/bloc/categories/categories_bloc.dart';
import 'package:inspired_senior_care_app/bloc/group/group_bloc.dart';
import 'package:inspired_senior_care_app/bloc/profile/profile_bloc.dart';
import 'package:inspired_senior_care_app/cubits/groups/group_featured_category_cubit.dart';
import 'package:inspired_senior_care_app/data/models/category.dart';
import 'package:inspired_senior_care_app/globals.dart';
import 'package:inspired_senior_care_app/view/widget/main/bottom_app_bar.dart';
import 'package:inspired_senior_care_app/view/widget/main/top_app_bar.dart';
import 'package:loading_animation_widget/loading_animation_widget.dart';
import 'package:showcaseview/showcaseview.dart';

import '../../../../cubits/groups/featured_category_cubit.dart';

class ChooseCategory extends StatefulWidget {
  const ChooseCategory({Key? key}) : super(key: key);

  @override
  State<ChooseCategory> createState() => _ChooseCategoryState();
}

class _ChooseCategoryState extends State<ChooseCategory> {
  final GlobalKey manualSetButtonShowcase = GlobalKey();
  final GlobalKey autoSetButtonShowcase = GlobalKey();
  final GlobalKey categoryCarouselShowcase = GlobalKey();
  BuildContext? showcaseBuildContext;
  final InfiniteScrollController controller = InfiniteScrollController();
  Category? selectedCategory;
  @override
  void initState() {
    // TODO: implement initState

    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<CategoriesBloc, CategoriesState>(
      builder: (context, state) {
        if (state is CategoriesFailed) {
          return const Center(
            child: Text('Error Fetching Categories...'),
          );
        }
        if (state is CategoriesLoaded) {
          final List<Category> categories = state.categories;
          return FutureBuilder<bool?>(
              future: checkSpotlightStatus('chooseCategorySpotlightDone'),
              builder: (context, snapshot) {
                var data = snapshot.data;
                if (snapshot.connectionState == ConnectionState.done &&
                    (data == null || data == false)) {
                  WidgetsBinding.instance.addPostFrameCallback((timeStamp) {
                    ShowCaseWidget.of(showcaseBuildContext!).startShowCase([
                      categoryCarouselShowcase,
                      manualSetButtonShowcase,
                      autoSetButtonShowcase
                    ]);
                  });
                }
                return ShowCaseWidget(
                  onFinish: () async {
                    await setSpotlightStatusToComplete(
                        'chooseCategorySpotlightDone');
                  },
                  builder: Builder(
                    builder: (context) {
                      showcaseBuildContext = context;
                      return Scaffold(
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
                                  padding: const EdgeInsets.symmetric(
                                      vertical: 16.0),
                                  child: Text(
                                    'Change Featured Category:',
                                    style: Theme.of(context)
                                        .textTheme
                                        .headlineSmall,
                                  ),
                                ),
                                Center(
                                  child: SizedBox(
                                    height: 275,
                                    child: Stack(
                                      alignment: AlignmentDirectional.center,
                                      children: [
                                        BlocConsumer<GroupFeaturedCategoryCubit,
                                            GroupFeaturedCategoryState>(
                                          listener: (context, state) {
                                            if (state
                                                is GroupFeaturedCategoryLoaded) {}
                                          },
                                          builder: (context, state) {
                                            if (state
                                                is GroupFeaturedCategoryLoading) {
                                              return Center(
                                                child: LoadingAnimationWidget
                                                    .fourRotatingDots(
                                                        color: Colors.blue,
                                                        size: 30),
                                              );
                                            }
                                            if (state
                                                is GroupFeaturedCategoryUpdated) {
                                              return Center(
                                                child: Wrap(
                                                  crossAxisAlignment:
                                                      WrapCrossAlignment.center,
                                                  direction: Axis.vertical,
                                                  spacing: 8.0,
                                                  children: [
                                                    const Icon(
                                                      Icons
                                                          .check_circle_outline_rounded,
                                                      color: Colors.lightGreen,
                                                      size: 30,
                                                    ),
                                                    Text(
                                                      'Category Updated!',
                                                      style: Theme.of(context)
                                                          .textTheme
                                                          .titleMedium,
                                                    ),
                                                  ],
                                                ),
                                              );
                                            }
                                            if (state
                                                is GroupFeaturedCategoryLoaded) {
                                              String featuredCategory =
                                                  state.featuredCategoryName;
                                              int featuredCategoryIndex =
                                                  categories
                                                      .indexWhere((category) =>
                                                          category.name ==
                                                          featuredCategory);

                                              final List<DashboardCategoryCard>
                                                  cards = [
                                                for (Category category
                                                    in categories)
                                                  DashboardCategoryCard(
                                                    controller: controller,
                                                    assetName:
                                                        category.coverImageUrl,
                                                    featuredCategoryIndex:
                                                        featuredCategoryIndex,
                                                  ),
                                              ];
                                              WidgetsBinding.instance
                                                  .addPostFrameCallback(
                                                      (timeStamp) {
                                                if (controller.hasClients) {
                                                  controller.animateToItem(
                                                      featuredCategoryIndex);
                                                }
                                              });
                                              return Showcase(
                                                descriptionAlignment:
                                                    TextAlign.center,
                                                key: categoryCarouselShowcase,
                                                targetPadding:
                                                    const EdgeInsets.symmetric(
                                                        vertical: 8.0),
                                                description:
                                                    'Swipe to explore all of the categories!',
                                                child: InfiniteCarousel.builder(
                                                  controller: controller,
                                                  onIndexChanged: (p0) {
                                                    selectedCategory =
                                                        categories[p0];
                                                  },
                                                  itemCount: categories.length,
                                                  itemExtent: 175,
                                                  itemBuilder: (context,
                                                      itemIndex, realIndex) {
                                                    return cards[itemIndex];
                                                  },
                                                ),
                                              );
                                            }
                                            return const Center(
                                              child:
                                                  Text('Something Went Wrong'),
                                            );
                                          },
                                        ),
                                        IgnorePointer(
                                          child: Card(
                                              semanticContainer: false,
                                              elevation: 0,
                                              color: Colors.transparent,
                                              shape: RoundedRectangleBorder(
                                                  side: const BorderSide(
                                                      color: Colors
                                                          .lightBlueAccent,
                                                      width: 4.0),
                                                  borderRadius:
                                                      BorderRadius.circular(
                                                          4.0)),
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
                                  padding:
                                      const EdgeInsets.symmetric(vertical: 8.0),
                                  child: Showcase(
                                    descriptionAlignment: TextAlign.center,
                                    targetBorderRadius:
                                        BorderRadius.circular(50),
                                    targetPadding: const EdgeInsets.symmetric(
                                        horizontal: 8.0),
                                    key: manualSetButtonShowcase,
                                    description:
                                        'You can manually set the category here.',
                                    child: ElevatedButton(
                                        onPressed: () {
                                          showDialog(
                                            context: context,
                                            builder: (context) {
                                              return ChangeCategoryDialog(
                                                  selectedCategory:
                                                      selectedCategory!);
                                            },
                                          );
                                        },
                                        child: BlocConsumer<
                                            GroupFeaturedCategoryCubit,
                                            GroupFeaturedCategoryState>(
                                          listener: (context, state) async {
                                            if (state
                                                is GroupFeaturedCategoryUpdated) {
                                              await Future.delayed(
                                                  const Duration(seconds: 1));
                                              if (!mounted) return;
                                              context.pop();
                                            }
                                          },
                                          builder: (context, state) {
                                            if (state
                                                is GroupFeaturedCategoryLoading) {
                                              return Center(
                                                child: LoadingAnimationWidget
                                                    .bouncingBall(
                                                        color: Colors.white,
                                                        size: 18),
                                              );
                                            }
                                            if (state
                                                is GroupFeaturedCategoryUpdated) {
                                              return const Text(
                                                  'Category Updated!');
                                            }
                                            if (state
                                                is GroupFeaturedCategoryFailed) {
                                              return const Center(
                                                child: Text('Error!'),
                                              );
                                            }
                                            if (state
                                                is GroupFeaturedCategoryLoaded) {
                                              return const Text('Set Category');
                                            }
                                            return const Center(
                                              child:
                                                  Text('Something Went Wrong!'),
                                            );
                                          },
                                        )),
                                  ),
                                ),
                                BlocBuilder<GroupFeaturedCategoryCubit,
                                    GroupFeaturedCategoryState>(
                                  builder: (context, state) {
                                    if (state is GroupFeaturedCategoryLoaded) {
                                      return Showcase(
                                        descriptionAlignment: TextAlign.center,
                                        targetBorderRadius:
                                            BorderRadius.circular(50),
                                        targetPadding:
                                            const EdgeInsets.symmetric(
                                                horizontal: 8.0),
                                        key: autoSetButtonShowcase,
                                        description:
                                            'Or choose this to stay on the standard monthly schedule!',
                                        child: OutlinedButton.icon(
                                          style: OutlinedButton.styleFrom(
                                            shape: RoundedRectangleBorder(
                                                borderRadius:
                                                    BorderRadius.circular(20)),
                                            maximumSize: const Size(300, 50),
                                            fixedSize: const Size(250, 32),
                                          ),
                                          onPressed: () async {
                                            int suggestedCategoryIndex =
                                                categories.indexWhere(
                                                    (element) =>
                                                        element.name ==
                                                        state
                                                            .suggestedCategory);
                                            controller.animateToItem(
                                                suggestedCategoryIndex);
                                            await Future.delayed(
                                                const Duration(seconds: 1));
                                            if (!mounted) return;
                                            context
                                                .read<
                                                    GroupFeaturedCategoryCubit>()
                                                .updateFeaturedCategory(
                                                    state.suggestedCategory,
                                                    context
                                                        .read<
                                                            GroupFeaturedCategoryCubit>()
                                                        .currentGroup
                                                        .groupId!);
                                            context.read<GroupBloc>().add(UpdateGroup(
                                                manager: context
                                                    .read<ProfileBloc>()
                                                    .state
                                                    .user,
                                                group: context
                                                    .read<
                                                        GroupFeaturedCategoryCubit>()
                                                    .currentGroup
                                                    .copyWith(
                                                        featuredCategory: state
                                                            .suggestedCategory,
                                                        onSchedule: true)));
                                            context
                                                .read<FeaturedCategoryCubit>()
                                                .loadUserFeaturedCategory();
                                          },
                                          // backgroundColor: Colors.white,
                                          icon: const Icon(
                                            FontAwesomeIcons.calendarCheck,
                                            size: 18,
                                          ),
                                          label: Padding(
                                            padding: const EdgeInsets.symmetric(
                                                horizontal: 4.0),
                                            child: Row(
                                              mainAxisSize: MainAxisSize.min,
                                              mainAxisAlignment:
                                                  MainAxisAlignment.center,
                                              children: const [
                                                Text(
                                                  'Auto-Select Monthly',
                                                ),
                                              ],
                                            ),
                                          ),
                                        ),
                                      );
                                    } else {
                                      return const SizedBox();
                                    }
                                  },
                                ),
                              ],
                            ),
                          ),
                        ),
                      );
                    },
                  ),
                );
              });
        }
        return const Center(
          child: Text('Something Went Wrong..'),
        );
      },
    );
  }
}

class ChangeCategoryDialog extends StatelessWidget {
  final Category selectedCategory;
  const ChangeCategoryDialog({
    Key? key,
    required this.selectedCategory,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return AlertDialog(
      actionsAlignment: MainAxisAlignment.spaceEvenly,
      titlePadding: const EdgeInsets.fromLTRB(24.0, 24.0, 24.0, 4.0),
      contentPadding: const EdgeInsets.fromLTRB(24.0, 16.0, 24.0, 16),
      actionsPadding: const EdgeInsets.only(bottom: 24.0),
      title: Wrap(
        spacing: 10.0,
        crossAxisAlignment: WrapCrossAlignment.center,
        children: [
          const Icon(
            Icons.warning_rounded,
            color: Colors.orange,
            size: 20,
          ),
          Text(
            'Change Category?',
            style: Theme.of(context).textTheme.headlineSmall,
          ),
        ],
      ),
      content: const Text.rich(TextSpan(children: [
        TextSpan(
            text:
                'Just to be sure you\'re about to manually set the category.'),
        TextSpan(
            text: ' It will not auto-update monthly!',
            style: TextStyle(fontStyle: FontStyle.italic)),
      ])),
      actions: [
        OutlinedButton(
            style: OutlinedButton.styleFrom(fixedSize: const Size(120, 30)),
            onPressed: () {
              Navigator.pop(context);
            },
            child: const Text('Cancel')),
        ElevatedButton(
            style: ElevatedButton.styleFrom(fixedSize: const Size(120, 30)),
            onPressed: () {
              context.read<GroupFeaturedCategoryCubit>().updateFeaturedCategory(
                  selectedCategory.name,
                  context
                      .read<GroupFeaturedCategoryCubit>()
                      .currentGroup
                      .groupId!);
              context.read<GroupBloc>().add(UpdateGroup(
                  manager: context.read<ProfileBloc>().state.user,
                  group: context
                      .read<GroupFeaturedCategoryCubit>()
                      .currentGroup
                      .copyWith(
                          featuredCategory: selectedCategory.name,
                          onSchedule: false)));
              context.read<FeaturedCategoryCubit>().loadUserFeaturedCategory();
              Navigator.pop(context);
            },
            child: const Text('I know!')),
      ],
    );
  }
}

class DashboardCategoryCard extends StatefulWidget {
  String assetName;

  bool? selected;
  final InfiniteScrollController controller;
  int featuredCategoryIndex;

  DashboardCategoryCard({
    Key? key,
    required this.assetName,
    required this.controller,
    required this.featuredCategoryIndex,
  }) : super(key: key);

  @override
  State<DashboardCategoryCard> createState() => _DashboardCategoryCardState();
}

class _DashboardCategoryCardState extends State<DashboardCategoryCard> {
  @override
  Widget build(BuildContext context) {
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
        child: CachedNetworkImage(
          imageUrl: widget.assetName,
          height: 300,
          fit: BoxFit.fitHeight,
        ),
      ),
    );
  }
}
