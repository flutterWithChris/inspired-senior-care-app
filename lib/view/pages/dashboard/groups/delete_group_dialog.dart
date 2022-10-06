import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:inspired_senior_care_app/bloc/group/group_bloc.dart';
import 'package:inspired_senior_care_app/data/models/group.dart';
import 'package:inspired_senior_care_app/data/models/user.dart';
import 'package:loading_animation_widget/loading_animation_widget.dart';

class DeleteGroupDialog extends StatefulWidget {
  final User currentUser;
  final Group currentGroup;
  const DeleteGroupDialog({
    Key? key,
    required this.currentUser,
    required this.currentGroup,
  }) : super(key: key);

  @override
  State<DeleteGroupDialog> createState() => _DeleteGroupDialogState();
}

class _DeleteGroupDialogState extends State<DeleteGroupDialog> {
  final TextEditingController groupNameController = TextEditingController();
  bool isButtonDisabled = true;

  @override
  void initState() {
    // TODO: implement initState
    groupNameController.addListener(() {
      if (groupNameController.value.text == widget.currentGroup.groupName) {
        setState(() {
          isButtonDisabled = false;
        });
      } else {
        setState(() {
          isButtonDisabled = true;
        });
      }
    });
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Dialog(
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20.0)),
      child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 12.0, vertical: 12.0),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Padding(
              padding: const EdgeInsets.symmetric(vertical: 16.0),
              child: Text(
                'Delete Group',
                style: Theme.of(context).textTheme.titleLarge,
              ),
            ),
            Text(
                'Type "${widget.currentGroup.groupName}" to confirm deletion.'),
            const SizedBox(
              height: 20.0,
            ),
            TextFormField(
              style: const TextStyle(),
              textCapitalization: TextCapitalization.words,
              controller: groupNameController,
              autofocus: true,
              keyboardType: TextInputType.text,
              decoration: InputDecoration(
                  hintText: widget.currentGroup.groupName,
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
                  style: ElevatedButton.styleFrom(backgroundColor: Colors.red),
                  onPressed: isButtonDisabled
                      ? null
                      : () {
                          print('Group Created: ');

                          BlocProvider.of<GroupBloc>(context).add(DeleteGroup(
                              group: widget.currentGroup,
                              manager: widget.currentUser));
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
                        return const Text('Delete Group');
                      }
                      if (state is GroupLoading) {
                        return LoadingAnimationWidget.discreteCircle(
                            color: Theme.of(context).primaryColor, size: 30);
                      }
                      if (state is GroupSubmitting) {
                        return const Text('Deleting...');
                      }
                      if (state is GroupDeleted) {
                        return const Text('Group Deleted!');
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
}
