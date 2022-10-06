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
      child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 12.0),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Padding(
              padding: const EdgeInsets.symmetric(vertical: 16.0),
              child: Text(
                'Create New Group',
                style: Theme.of(context).textTheme.titleLarge,
              ),
            ),
            TextFormField(
              style: const TextStyle(),
              textCapitalization: TextCapitalization.words,
              autofocus: true,
              keyboardType: TextInputType.text,
              controller: groupNameController,
              decoration: InputDecoration(
                  hintText: 'ABC Senior Care',
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
              padding: const EdgeInsets.symmetric(vertical: 8.0),
              child: ElevatedButton(
                  onPressed: () {
                    print('Group Created: ${groupNameController.text}');
                    // * Create a New Group
                    Group newGroup = Group(
                        groupName: groupNameController.text,
                        groupId: '',
                        featuredCategory: 'Supportive Environment',
                        groupMemberIds: [],
                        groupManagerIds: [currentUser.id!]);
                    BlocProvider.of<GroupBloc>(context).add(
                        CreateGroup(group: newGroup, manager: currentUser));
                    // * Add new group to list
                    //  sampleGroupList.add(newGroup);
                  },
                  child: BlocConsumer<GroupBloc, GroupState>(
                    listenWhen: (previous, current) => previous != current,
                    listener: (context, state) {
                      if (state is GroupInitial) {
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
