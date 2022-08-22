import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:inspired_senior_care_app/bloc/group/group_bloc.dart';
import 'package:inspired_senior_care_app/data/models/group.dart';
import 'package:inspired_senior_care_app/data/models/user.dart';

class EditGroupDialog extends StatelessWidget {
  final User currentUser;
  final Group currentGroup;
  const EditGroupDialog({
    Key? key,
    required this.currentUser,
    required this.currentGroup,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final TextEditingController groupNameController = TextEditingController();
    groupNameController.text = currentGroup.groupName!;
    return Dialog(
      child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 12.0),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Padding(
              padding: const EdgeInsets.symmetric(vertical: 16.0),
              child: Text(
                'Edit Group',
                style: Theme.of(context).textTheme.titleLarge,
              ),
            ),
            TextFormField(
              style: const TextStyle(),
              textCapitalization: TextCapitalization.words,
              controller: groupNameController,
              autofocus: true,
              keyboardType: TextInputType.text,
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
                      if (state is GroupUpdated) {
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
                    print('Group Created: ');
                    // * Create a New Group
                    Group editedGroup = currentGroup.copyWith(
                        groupName: groupNameController.text);
                    BlocProvider.of<GroupBloc>(context)
                        .add(UpdateGroup(group: editedGroup));
                  },
                  child: BlocConsumer<GroupBloc, GroupState>(
                    listenWhen: (previous, current) => previous != current,
                    listener: (context, state) {
                      if (state is GroupLoaded) {
                        Navigator.pop(context);
                        // TODO: Dispose?
                      }
                    },
                    builder: (context, state) {
                      // TODO: Error Handling
                      if (state is GroupLoaded) {
                        return const Text('Update Group');
                      }
                      if (state is GroupSubmitting) {
                        return const Text('Submitting...');
                      }
                      if (state is GroupUpdated) {
                        return const Text('Group Updated!');
                      }
                      return const Text('Something\'s Wrong!');
                    },
                  )),
            ),
            ElevatedButton(
              onPressed: () {
                context.read<GroupBloc>().add(DeleteGroup());
              },
              style: ElevatedButton.styleFrom(primary: Colors.redAccent),
              child: const Text('Delete Group'),
            ),
          ],
        ),
      ),
    );
  }
}
