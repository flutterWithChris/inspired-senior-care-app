import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';
import 'package:inspired_senior_care_app/bloc/profile/profile_bloc.dart';
import 'package:inspired_senior_care_app/data/models/category.dart';

import '../../bloc/view_response/response_bloc.dart';

class ProgressSection extends StatelessWidget {
  const ProgressSection({
    Key? key,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      child: Card(
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(33)),
        color: Colors.white,
        child: Padding(
          padding: const EdgeInsets.symmetric(vertical: 12.0, horizontal: 24.0),
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
                          progressColor: category.progressColor,
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
    return SizedBox(
      child: Card(
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(25)),
        color: Colors.white,
        child: Padding(
          padding: const EdgeInsets.symmetric(vertical: 12.0, horizontal: 24.0),
          child: Column(
            children: [
              Padding(
                padding: const EdgeInsets.symmetric(vertical: 8.0),
                child: Text(
                  'Chelsea\'s Progress',
                  textAlign: TextAlign.left,
                  style: Theme.of(context).textTheme.titleLarge,
                ),
              ),
              GroupMemberProgressCategory(
                  title: 'Communication',
                  progressColor: Colors.deepOrange,
                  progress: 100,
                  message: 'All Done. Good Job!'),
              GroupMemberProgressCategory(
                  title: 'Positive Interactions',
                  progressColor: Colors.redAccent,
                  progress: 33,
                  message: '8 more to go.'),
              GroupMemberProgressCategory(
                  title: 'Supportive Environment',
                  progressColor: Colors.lightGreen,
                  progress: 70,
                  message: 'Only 3 More!'),
              GroupMemberProgressCategory(
                  title: 'Brain Change',
                  progressColor: Colors.lightGreen,
                  progress: 40,
                  message: 'Only 3 More!'),
              GroupMemberProgressCategory(
                  title: 'Damaging Interactions',
                  progressColor: Colors.grey,
                  progress: 10,
                  message: 'Only 3 More!'),
              GroupMemberProgressCategory(
                  title: 'Genuine Relationships',
                  progressColor: Colors.red,
                  progress: 70,
                  message: 'Only 3 More!'),
            ],
          ),
        ),
      ),
    );
  }
}

class GroupMemberProgressCategory extends StatelessWidget {
  final String title;
  Color progressColor;
  int progress;
  String message;
  GroupMemberProgressCategory({
    Key? key,
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
                                  '${progress.toString()}%',
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
                              '${progress.toString()}%',
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
                              userId: 'nzeeburQleQBVF6UekJ51OjICYI3',
                              categoryName: title,
                              cardNumber: 2));
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
