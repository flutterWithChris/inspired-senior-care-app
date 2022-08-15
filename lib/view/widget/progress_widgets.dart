import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';
import 'package:inspired_senior_care_app/bloc/cards/card_bloc.dart';
import 'package:inspired_senior_care_app/bloc/categories/categories_bloc.dart';
import 'package:inspired_senior_care_app/bloc/member/bloc/member_bloc.dart';
import 'package:inspired_senior_care_app/bloc/profile/profile_bloc.dart';
import 'package:inspired_senior_care_app/data/models/category.dart';
import 'package:inspired_senior_care_app/data/models/user.dart';
import 'package:loading_animation_widget/loading_animation_widget.dart';

import '../../bloc/view_response/response_bloc.dart';

class ProgressSection extends StatelessWidget {
  const ProgressSection({
    Key? key,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<CategoriesBloc, CategoriesState>(
      builder: (context, state) {
        if (state is CategoriesLoading) {
          return LoadingAnimationWidget.discreteCircle(
              color: Colors.blue, size: 30);
        }
        if (state is CategoriesFailed) {
          return const Center(
            child: Text('Error Fetching Categories!'),
          );
        }
        if (state is CategoriesLoaded) {
          List<Category> categoryList = state.categories;
          return SizedBox(
            child: Card(
              shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(33)),
              color: Colors.white,
              child: Padding(
                padding: const EdgeInsets.symmetric(
                    vertical: 12.0, horizontal: 24.0),
                child: Column(
                  children: [
                    Padding(
                      padding: const EdgeInsets.symmetric(vertical: 8.0),
                      child: Text(
                        'Your Progress',
                        textAlign: TextAlign.left,
                        style: Theme.of(context).textTheme.titleLarge,
                      ),
                    ),
                    for (Category category in categoryList)
                      BlocBuilder<ProfileBloc, ProfileState>(
                        builder: (context, state) {
                          if (state is ProfileLoaded) {
                            bool categoryStarted =
                                state.user.progress!.containsKey(category.name);
                            double? progress;
                            if (categoryStarted) {
                              progress = state.user.progress![category.name]! /
                                  category.totalCards! *
                                  100;
                            }

                            return ProgressCategory(
                                title: category.name,
                                progressColor: category.categoryColor,
                                progress: categoryStarted ? progress! : 0,
                                message: 'All Done. Good Job!');
                          }
                          return const Text('Something Went Wrong...');
                        },
                      ),
                  ],
                ),
              ),
            ),
          );
        } else {
          return const Center(
            child: Text('Something Went Wrong!!'),
          );
        }
      },
    );
  }
}

class ProgressCategory extends StatelessWidget {
  final String title;
  Color progressColor;
  double progress;
  String message;
  ProgressCategory({
    Key? key,
    required this.title,
    required this.progressColor,
    required this.progress,
    required this.message,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 6.0),
      child: Column(
        children: [
          Padding(
            padding: const EdgeInsets.symmetric(vertical: 4.0),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text(
                  title,
                  style: Theme.of(context).textTheme.titleMedium,
                ),
                progress == 100
                    ? ClipRRect(
                        borderRadius: BorderRadius.circular(25),
                        child: Container(
                          color: Colors.grey.shade100,
                          child: Padding(
                            padding: const EdgeInsets.symmetric(
                                horizontal: 12.0, vertical: 2.0),
                            child: Wrap(
                              crossAxisAlignment: WrapCrossAlignment.center,
                              spacing: 5,
                              children: [
                                Text(
                                  '${progress.toStringAsFixed(0)}%',
                                ),
                                const Icon(
                                  Icons.check_circle,
                                  color: Colors.lightBlueAccent,
                                  size: 12,
                                ),
                              ],
                            ),
                          ),
                        ),
                      )
                    : ClipRRect(
                        borderRadius: BorderRadius.circular(25),
                        child: Container(
                          color: Colors.grey.shade100,
                          child: Padding(
                            padding: const EdgeInsets.symmetric(
                                horizontal: 12.0, vertical: 2.0),
                            child: Text(
                              '${progress.toStringAsFixed(0)}%',
                            ),
                          ),
                        ),
                      ),
              ],
            ),
          ),
          Padding(
            padding: const EdgeInsets.symmetric(vertical: 8),
            child:
                Column(crossAxisAlignment: CrossAxisAlignment.end, children: [
              Padding(
                padding: const EdgeInsets.symmetric(vertical: 8.0),
                child: ClipRRect(
                  borderRadius: BorderRadius.circular(525),
                  child: LinearProgressIndicator(
                    minHeight: 12,
                    value: progress / 100,
                    backgroundColor: Colors.grey.shade300,
                    color: progressColor,
                  ),
                ),
              ),
              Padding(
                padding: const EdgeInsets.symmetric(vertical: 8.0),
                child: Text(
                  message,
                  textAlign: TextAlign.right,
                ),
              )
            ]),
          ),
        ],
      ),
    );
  }
}

class GroupMemberProgressSection extends StatelessWidget {
  const GroupMemberProgressSection({
    Key? key,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    double calculateProgress(int currentCardIndex, int totalCards) {
      double progress = (currentCardIndex / totalCards * 100).roundToDouble();
      print('Progress: $progress');
      return progress;
    }

    return BlocBuilder<MemberBloc, MemberState>(
      builder: (context, state) {
        if (state is MemberLoading) {
          return LoadingAnimationWidget.discreteCircle(
              color: Colors.blue, size: 30);
        }
        if (state is MemberLoaded) {
          User groupMember = state.user;

          print(groupMember.progress!['Brain Change']);
          return BlocBuilder<CategoriesBloc, CategoriesState>(
            builder: (context, state) {
              if (state is CategoriesLoading) {
                return LoadingAnimationWidget.threeRotatingDots(
                    color: Colors.blue, size: 30);
              }
              if (state is CategoriesLoaded) {
                List<Category> categoryList = state.categories;

                return SizedBox(
                  child: Card(
                    shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(25)),
                    color: Colors.white,
                    child: Padding(
                      padding: const EdgeInsets.symmetric(
                          vertical: 12.0, horizontal: 24.0),
                      child: Column(
                        children: [
                          Padding(
                            padding: const EdgeInsets.symmetric(vertical: 8.0),
                            child: Text(
                              '${groupMember.name!.split(" ")[0]}\'s Progress',
                              textAlign: TextAlign.left,
                              style: Theme.of(context).textTheme.titleLarge,
                            ),
                          ),
                          for (Category category in categoryList)
                            GroupMemberProgressCategory(
                                category: category,
                                member: groupMember,
                                title: category.name,
                                progressColor: category.categoryColor,
                                progress: groupMember.progress!
                                            .containsKey(category.name) ==
                                        true
                                    ? calculateProgress(
                                        groupMember.progress![category.name]!,
                                        category.totalCards!)
                                    : 0,
                                message: 'All Done. Good Job!'),
                        ],
                      ),
                    ),
                  ),
                );
              } else {
                return const Center(
                  child: Text('Something Went Wrong..'),
                );
              }
            },
          );
        } else {
          return const Center(
            child: Text('Error Fetching Member!'),
          );
        }
      },
    );
  }
}

class GroupMemberProgressCategory extends StatelessWidget {
  Category category;
  final User member;
  final String title;
  Color progressColor;
  double progress;
  String message;
  GroupMemberProgressCategory({
    Key? key,
    required this.category,
    required this.member,
    required this.title,
    required this.progressColor,
    required this.progress,
    required this.message,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 8.0),
      child: Column(
        children: [
          Padding(
            padding: const EdgeInsets.symmetric(vertical: 8.0),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text(
                  title,
                  style: Theme.of(context).textTheme.titleMedium,
                ),
                progress == 100
                    ? ClipRRect(
                        borderRadius: BorderRadius.circular(25),
                        child: Container(
                          color: Colors.grey.shade100,
                          child: Padding(
                            padding: const EdgeInsets.symmetric(
                                horizontal: 12.0, vertical: 2.0),
                            child: Wrap(
                              crossAxisAlignment: WrapCrossAlignment.center,
                              spacing: 5,
                              children: [
                                Text(
                                  '${progress.toStringAsFixed(0)}%',
                                ),
                                const Icon(
                                  Icons.check_circle,
                                  color: Colors.lightGreen,
                                  size: 12,
                                ),
                              ],
                            ),
                          ),
                        ),
                      )
                    : ClipRRect(
                        borderRadius: BorderRadius.circular(25),
                        child: Container(
                          color: Colors.grey.shade100,
                          child: Padding(
                            padding: const EdgeInsets.symmetric(
                                horizontal: 10.0, vertical: 2.0),
                            child: Text(
                              '${progress.toStringAsFixed(0)}%',
                            ),
                          ),
                        ),
                      ),
              ],
            ),
          ),
          Padding(
            padding: const EdgeInsets.only(top: 8),
            child:
                Column(crossAxisAlignment: CrossAxisAlignment.end, children: [
              ClipRRect(
                borderRadius: BorderRadius.circular(525),
                child: LinearProgressIndicator(
                  minHeight: 12,
                  value: progress / 100,
                  backgroundColor: Colors.grey.shade300,
                  color: progressColor,
                ),
              ),
              Padding(
                padding: const EdgeInsets.only(top: 12.0),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.end,
                  children: [
                    ElevatedButton(
                        onPressed: () {
                          context.read<ResponseBloc>().add(FetchResponse(
                              user: member, category: category, cardNumber: 2));
                          context.read<CardBloc>().add(LoadCards(
                                category: category,
                              ));
                          context.goNamed('view-responses');
                        },
                        child: const Text('View Responses >')),
                  ],
                ),
              )
            ]),
          ),
        ],
      ),
    );
  }
}
