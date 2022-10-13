import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:inspired_senior_care_app/bloc/group/group_bloc.dart';
import 'package:inspired_senior_care_app/data/models/group.dart';
import 'package:loading_animation_widget/loading_animation_widget.dart';

class GroupChips extends StatelessWidget {
  const GroupChips({
    Key? key,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<GroupBloc, GroupState>(
      builder: (context, state) {
        if (state is GroupLoading) {
          return LoadingAnimationWidget.prograssiveDots(
              color: Colors.blue, size: 20);
        }
        if (state is GroupFailed) {
          return const Center(
            child: Text('Error Loading Groups!'),
          );
        }
        if (state is GroupLoaded) {
          if (state.myGroups.isNotEmpty) {
            return Padding(
              padding: const EdgeInsets.symmetric(horizontal: 24.0),
              child: Wrap(
                crossAxisAlignment: WrapCrossAlignment.center,
                children: [
                  Wrap(
                    crossAxisAlignment: WrapCrossAlignment.center,
                    spacing: 6.0,
                    children: [
                      const Icon(
                        Icons.group,
                        size: 14,
                      ),
                      Text(
                        'Groups:',
                        style: Theme.of(context).textTheme.titleMedium,
                      )
                    ],
                  ),
                  const SizedBox(width: 12.0),
                  for (Group group in state.myGroups)
                    Padding(
                      padding: const EdgeInsets.symmetric(horizontal: 4.0),
                      child: Chip(
                          visualDensity: VisualDensity.compact,
                          label: Text(group.groupName!)),
                    ),
                ],
              ),
            );
          } else {
            return const SizedBox();
          }
        } else {
          return const Center(
            child: Text('Something Went Wrong!'),
          );
        }
      },
    );
  }
}
