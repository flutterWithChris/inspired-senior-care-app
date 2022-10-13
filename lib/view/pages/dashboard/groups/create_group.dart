import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:inspired_senior_care_app/bloc/group/group_bloc.dart';
import 'package:inspired_senior_care_app/data/models/group.dart';
import 'package:inspired_senior_care_app/data/models/user.dart';

class CreateGroupDialog extends StatefulWidget {
  final User manager;

  const CreateGroupDialog({
    required this.manager,
    Key? key,
  }) : super(key: key);

  @override
  State<CreateGroupDialog> createState() => _CreateGroupDialogState();
}

class _CreateGroupDialogState extends State<CreateGroupDialog> {
  final TextEditingController groupNameController = TextEditingController();

  @override
  Widget build(BuildContext context) {
    final currentUser = widget.manager;
    return Dialog(
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20.0)),
      child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 12.0, vertical: 12.0),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Padding(
              padding: const EdgeInsets.only(top: 8.0, bottom: 24.0),
              child: Text(
                'Create a Group',
                style: Theme.of(context).textTheme.headline4!.copyWith(
                    color: Theme.of(context).textTheme.bodyMedium!.color),
              ),
            ),
            TextFormField(
              style: const TextStyle(),
              textCapitalization: TextCapitalization.words,
              autofocus: true,
              keyboardType: TextInputType.text,
              controller: groupNameController,
              decoration: InputDecoration(
                  hintText: 'Example: Nurses',
                  label: const Text('Group Name'),
                  suffixIcon: BlocBuilder<GroupBloc, GroupState>(
                    builder: (context, state) {
                      if (state is GroupSubmitting) {
                        return const SizedBox(
                            height: 5,
                            width: 5,
                            child: Center(child: CircularProgressIndicator()));
                      }
                      if (state is GroupCreated) {
                        return const Icon(
                          Icons.check_circle_outline_rounded,
                          color: Colors.lightGreen,
                          size: 20,
                        );
                      }
                      return Container(
                        width: 1,
                      );
                    },
                  )),
            ),
            Padding(
              padding: const EdgeInsets.symmetric(vertical: 12.0),
              child: ElevatedButton.icon(
                  onPressed: () {
                    print('Group Created: ${groupNameController.text}');
                    // * Create a New Group
                    Group newGroup = Group(
                        groupName: groupNameController.text,
                        groupId: '',
                        onSchedule: true,
                        featuredCategory: '',
                        groupMemberIds: [],
                        groupManagerIds: [currentUser.id!]);
                    BlocProvider.of<GroupBloc>(context).add(
                        CreateGroup(group: newGroup, manager: currentUser));
                    // * Add new group to list
                    //  sampleGroupList.add(newGroup);
                  },
                  icon: const Icon(
                    Icons.group_add_rounded,
                    size: 20.0,
                  ),
                  label: BlocConsumer<GroupBloc, GroupState>(
                    listenWhen: (previous, current) => previous != current,
                    listener: (context, state) {
                      if (state is GroupCreated) {
                        Future.delayed(const Duration(seconds: 1));
                        Navigator.pop(context);
                        // TODO: Dispose?
                      }
                    },
                    builder: (context, state) {
                      // TODO: Error Handling
                      if (state is GroupLoaded) {
                        return const Text('Create Group');
                      }
                      if (state is GroupSubmitting) {
                        return const Text('Submitting...');
                      }
                      if (state is GroupCreated) {
                        return const Text('Group Created!');
                      }
                      return const Text('Something\'s Wrong!');
                    },
                  )),
            ),
          ],
        ),
      ),
    );
  }

  @override
  void dispose() {
    groupNameController.dispose();
    super.dispose();
  }
}
