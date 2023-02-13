import 'dart:math';

import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';
import 'package:inspired_senior_care_app/bloc/cards/card_bloc.dart';
import 'package:inspired_senior_care_app/bloc/categories/categories_bloc.dart';
import 'package:inspired_senior_care_app/bloc/member/bloc/member_bloc.dart';
import 'package:inspired_senior_care_app/bloc/profile/profile_bloc.dart';
import 'package:inspired_senior_care_app/data/models/category.dart';
import 'package:inspired_senior_care_app/data/models/user.dart';
import 'package:inspired_senior_care_app/globals.dart';
import 'package:loading_animation_widget/loading_animation_widget.dart';
import 'package:showcaseview/showcaseview.dart';

import '../../bloc/view_response/response_bloc.dart';

class ProgressSection extends StatelessWidget {
  final ScrollController pageScrollController;
  const ProgressSection({
    required this.pageScrollController,
    Key? key,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<CategoriesBloc, CategoriesState>(
        builder: (context, state) {
      if (state is CategoriesLoading) {
        return LoadingAnimationWidget.fourRotatingDots(
            color: Colors.blue, size: 30);
      }
      if (state is CategoriesFailed) {
        return const Center(
          child: Text('Error Loading Categories!..'),
        );
      }
      if (state is CategoriesLoaded) {
        List<Category> categories =
            context.watch<CategoriesBloc>().state.categories!;
        User currentUser = context.watch<ProfileBloc>().state.user;
        return SizedBox(
          height: 1720,
          child: Card(
            shape:
                RoundedRectangleBorder(borderRadius: BorderRadius.circular(33)),
            color: Colors.white,
            child: Padding(
              padding:
                  const EdgeInsets.symmetric(vertical: 12.0, horizontal: 24.0),
              child: Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  Padding(
                    padding: const EdgeInsets.symmetric(vertical: 8.0),
                    child: Text(
                      'Your Progress',
                      textAlign: TextAlign.left,
                      style: Theme.of(context).textTheme.titleLarge,
                    ),
                  ),
                  for (Category category in categories)
                    currentUser.currentCard?[category.name] == null
                        ? ProgressCategory(
                            message: setMessageNorm(0.0),
                            progress: 0.0,
                            category: category,
                            title: category.name,
                            progressColor: category.categoryColor,
                          )
                        : ProgressCategory(
                            message: setMessageNorm(
                                ((((currentUser.currentCard![category.name]!) -
                                            1) /
                                        category.totalCards!) *
                                    100.0)),
                            progress:
                                (((currentUser.currentCard![category.name]! -
                                            1) /
                                        category.totalCards!) *
                                    100.0),
                            category: category,
                            title: category.name,
                            progressColor: category.categoryColor,
                          )
                ],
              ),
            ),
          ),
        );
      } else {
        return const Center(
          child: Text('Error Fetching Progress!'),
        );
      }
    });
  }
}

List<String> getStartedMessages = [
  'Let\'s get started!',
  'Not started yet!',
  'No responses submitted.',
  'Starting is the hardest part!',
  'Let\'s change that!',
  'Get started today!',
  'The loneliest number is..0',
  'Starting is the first step :)'
];
List<String> keepGoingMessages = [
  'You\'re doing great!',
  'Keep up the hard work!',
  'Keep going!',
  'You got this!',
  'You\'re crushing it.',
  'Great job, keep it up!',
  'Don\'t stop now!',
  'You\'re doing great!',
  'Keep up the momentum!',
];
List<String> almostDoneMessages = [
  'You\'re almost done!',
  'You\'re so close!',
  'Your hard work is paying off.',
  'Almost there!',
  'Just a bit more!',
];
List<String> wellDoneMessages = [
  'Job well done!',
  'All Done. Good Job!!',
  'You\'re all done; Awesome!',
  'You finished!',
  'Pat yourself on the back.',
  'You\'re done',
  'Job well done!',
  'Job well done!',
  'Job well done!',
  'Job well done!',
];

String setMessageNorm(double progress) {
  Random random = Random();

  if (progress.roundToDouble() == 0.0) {
    var randomInt = random.nextInt(getStartedMessages.length);
    return getStartedMessages[randomInt];
  } else if (progress.roundToDouble() < 66) {
    var randomInt = random.nextInt(keepGoingMessages.length);
    return keepGoingMessages[randomInt];
  } else if (progress.roundToDouble() < 100) {
    var randomInt = random.nextInt(almostDoneMessages.length);
    return almostDoneMessages[randomInt];
  } else if (progress.roundToDouble() == 100) {
    var randomInt = random.nextInt(wellDoneMessages.length);
    return wellDoneMessages[randomInt];
  }
  return '';
}

class ProgressCategory extends StatefulWidget {
  final Category category;
  final String title;
  final String message;
  final Color progressColor;
  final double progress;

  const ProgressCategory(
      {Key? key,
      required this.category,
      required this.title,
      required this.message,
      required this.progressColor,
      required this.progress})
      : super(key: key);

  @override
  State<ProgressCategory> createState() => _ProgressCategoryState();
}

class _ProgressCategoryState extends State<ProgressCategory> {
  @override
  Widget build(BuildContext context) {
    return SizedBox(
      height: 125,
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          Padding(
            padding: const EdgeInsets.symmetric(vertical: 4.0),
            child: Row(
              // mainAxisSize: MainAxisSize.min,
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text(
                  widget.title,
                  style: Theme.of(context).textTheme.titleMedium,
                ),
                widget.progress != 0
                    ? ClipRRect(
                        borderRadius: BorderRadius.circular(25),
                        child: Container(
                          color: Colors.grey.shade100,
                          child: Padding(
                            padding: const EdgeInsets.symmetric(
                                horizontal: 12.0, vertical: 2.0),
                            child: widget.progress == 100
                                ? Wrap(
                                    crossAxisAlignment:
                                        WrapCrossAlignment.center,
                                    spacing: 5,
                                    children: [
                                      Text(
                                        '${widget.progress.toStringAsFixed(0)}%',
                                      ),
                                      const Icon(
                                        Icons.check_circle,
                                        color: Colors.lightBlueAccent,
                                        size: 12,
                                      ),
                                    ],
                                  )
                                : ClipRRect(
                                    borderRadius: BorderRadius.circular(25),
                                    child: Container(
                                      color: Colors.grey.shade100,
                                      child: Padding(
                                        padding: const EdgeInsets.symmetric(
                                            horizontal: 12.0, vertical: 2.0),
                                        child: Text(
                                          '${widget.progress.toStringAsFixed(0)}%',
                                        ),
                                      ),
                                    ),
                                  ),
                          ),
                        ),
                      )
                    : ClipRRect(
                        borderRadius: BorderRadius.circular(25),
                        child: Container(
                          color: Colors.grey.shade100,
                          child: const Padding(
                            padding: EdgeInsets.symmetric(
                                horizontal: 12.0, vertical: 2.0),
                            child: Text(
                              '0%',
                            ),
                          ),
                        ),
                      ),
              ],
            ),
          ),
          widget.progress.roundToDouble() > 0.0
              ? Padding(
                  padding: const EdgeInsets.symmetric(vertical: 8),
                  child: Column(
                      crossAxisAlignment: CrossAxisAlignment.end,
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        Padding(
                          padding: const EdgeInsets.symmetric(vertical: 8.0),
                          child: ClipRRect(
                            borderRadius: BorderRadius.circular(525),
                            child: LinearProgressIndicator(
                              minHeight: 12,
                              value: widget.progress / 100,
                              backgroundColor: Colors.grey.shade300,
                              color: widget.progressColor,
                            ),
                          ),
                        ),
                        Padding(
                            padding: const EdgeInsets.symmetric(vertical: 8.0),
                            child: Text(
                              widget.message,
                              textAlign: TextAlign.right,
                            ))
                      ]),
                )
              : Padding(
                  padding: const EdgeInsets.symmetric(vertical: 8),
                  child: Column(
                      mainAxisSize: MainAxisSize.min,
                      crossAxisAlignment: CrossAxisAlignment.end,
                      children: [
                        Padding(
                          padding: const EdgeInsets.symmetric(vertical: 8.0),
                          child: ClipRRect(
                            borderRadius: BorderRadius.circular(525),
                            child: LinearProgressIndicator(
                              minHeight: 12,
                              value: 0,
                              backgroundColor: Colors.grey.shade300,
                              color: widget.progressColor,
                            ),
                          ),
                        ),
                        Padding(
                            padding: const EdgeInsets.symmetric(vertical: 8.0),
                            child: Text(
                              widget.message,
                              textAlign: TextAlign.right,
                            ))
                      ]),
                )
        ],
      ),
    );
  }
}

class GroupMemberProgressSection extends StatefulWidget {
  const GroupMemberProgressSection({
    Key? key,
  }) : super(key: key);

  @override
  State<GroupMemberProgressSection> createState() =>
      _GroupMemberProgressSectionState();
}

class _GroupMemberProgressSectionState
    extends State<GroupMemberProgressSection> {
  final GlobalKey viewResponsesShowcaseKey = GlobalKey();
  BuildContext? showcaseBuildContext;

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    double calculateProgress(int currentCardIndex, int totalCards) {
      double progress = (currentCardIndex / totalCards * 100).roundToDouble();
      return progress;
    }

    return FutureBuilder<bool?>(
        future: checkSpotlightStatus('viewMemberSpotlightDone'),
        builder: (context, snapshot) {
          var data = snapshot.data;
          if (snapshot.connectionState == ConnectionState.done &&
              (data == null || data == false)) {
            WidgetsBinding.instance.addPostFrameCallback((timeStamp) {
              ShowCaseWidget.of(showcaseBuildContext!)
                  .startShowCase([viewResponsesShowcaseKey]);
            });
          }
          return ShowCaseWidget(onFinish: () async {
            await setSpotlightStatusToComplete('viewMemberSpotlightDone');
          }, builder: Builder(
            builder: (context) {
              showcaseBuildContext = context;
              return BlocBuilder<MemberBloc, MemberState>(
                builder: (context, state) {
                  if (state is MemberFailed) {
                    return const Center(
                      child: Text('Error Fetching Member!'),
                    );
                  }
                  if (state is MemberRemoved) {
                    return Container();
                  }
                  if (state is MemberLoading) {
                    return LoadingAnimationWidget.discreteCircle(
                        color: Colors.blue, size: 30);
                  }
                  if (state is MemberLoaded) {
                    User groupMember = state.user;
                    return BlocBuilder<CategoriesBloc, CategoriesState>(
                      builder: (context, state) {
                        if (state is CategoriesLoading) {
                          return LoadingAnimationWidget.threeRotatingDots(
                              color: Colors.blue, size: 30);
                        }
                        if (state is CategoriesLoaded) {
                          List<Category> categoryList = state.categories;

                          return Showcase(
                            targetBorderRadius:
                                const BorderRadius.all(Radius.circular(20.0)),
                            descriptionAlignment: TextAlign.center,
                            targetPadding: const EdgeInsets.all(4.0),
                            key: viewResponsesShowcaseKey,
                            description:
                                'Your Group Members will earn completion awards for each category they complete. \n\n Congratulate them when you see they have earned awards!',
                            child: SizedBox(
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
                                        padding: const EdgeInsets.symmetric(
                                            vertical: 8.0),
                                        child: Text(
                                          '${groupMember.name!.split(" ")[0]}\'s Progress',
                                          textAlign: TextAlign.left,
                                          style: Theme.of(context)
                                              .textTheme
                                              .titleLarge,
                                        ),
                                      ),
                                      for (Category category in categoryList)
                                        GroupMemberProgressCategory(
                                            category: category,
                                            member: groupMember,
                                            title: category.name,
                                            progressColor:
                                                category.categoryColor,
                                            progress: groupMember.currentCard!
                                                        .containsKey(
                                                            category.name) ==
                                                    true
                                                ? calculateProgress(
                                                    groupMember.currentCard![
                                                            category.name]! -
                                                        1,
                                                    category.totalCards!)
                                                : 0,
                                            message: 'All Done. Good Job!'),
                                    ],
                                  ),
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
            },
          ));
        });
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
      padding: const EdgeInsets.symmetric(vertical: 6.0),
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
                        onPressed: progress > 0
                            ? () {
                                context.read<ResponseBloc>().add(FetchResponse(
                                    user: member,
                                    category: category,
                                    cardNumber: 1));
                                context.read<CardBloc>().add(LoadCards(
                                      category: category,
                                    ));
                                context.pushNamed('view-responses');
                              }
                            : null,
                        child: const Text('View Responses >'))
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
