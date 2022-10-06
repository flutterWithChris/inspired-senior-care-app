import 'package:email_validator/email_validator.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:inspired_senior_care_app/bloc/group/group_bloc.dart';
import 'package:inspired_senior_care_app/bloc/invite/invite_bloc.dart';
import 'package:inspired_senior_care_app/data/models/group.dart';

class AddMemberDialog extends StatefulWidget {
  final Group group;
  final TextEditingController inviteTextFieldController;
  const AddMemberDialog({
    Key? key,
    required this.group,
    required this.inviteTextFieldController,
  }) : super(key: key);

  @override
  State<AddMemberDialog> createState() => _AddMemberDialogState();
}

class _AddMemberDialogState extends State<AddMemberDialog> {
  @override
  Widget build(BuildContext context) {
    final GlobalKey<FormState> addMemberFormKey = GlobalKey<FormState>();
    return AlertDialog(
      actionsPadding: const EdgeInsets.only(bottom: 12.0),
      alignment: AlignmentDirectional.center,
      actionsAlignment: MainAxisAlignment.center,
      // * Main Content
      title: const Text(
        'Add Member',
        textAlign: TextAlign.center,
      ),
      content: const Text(
        'Enter their email to send an invite!',
        textAlign: TextAlign.center,
      ),

      actions: [
        // * Email Text Field
        Center(
          child: BlocBuilder<InviteBloc, InviteState>(
            builder: (context, state) {
              return Form(
                key: addMemberFormKey,
                child: Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 8.0),
                  child: TextFormField(
                    // autovalidateMode: AutovalidateMode.onUserInteraction,
                    validator: (value) {
                      if (value != null && !EmailValidator.validate(value)) {
                        return 'Enter a valid email!';
                      } else if (state.inviteStatus == InviteStatus.failed) {
                        return 'User Not Found!';
                      }
                      return null;
                    },
                    autofocus: true,
                    controller: widget.inviteTextFieldController,
                    style: const TextStyle(color: Colors.black),
                    keyboardType: TextInputType.emailAddress,
                    decoration: InputDecoration(
                      hintText: 'example@email.com',
                      suffixIcon: Padding(
                        padding: const EdgeInsetsDirectional.only(end: 12),
                        child: BlocBuilder<InviteBloc, InviteState>(
                          builder: (context, state) {
                            if (state.inviteStatus == InviteStatus.sending) {
                              return const SizedBox(
                                  height: 8,
                                  width: 8,
                                  child: Center(
                                      child: CircularProgressIndicator()));
                            }
                            if (state.inviteStatus == InviteStatus.sent) {
                              return const Icon(
                                Icons.check,
                                color: Colors.lime,
                              );
                            }
                            return Container(
                              width: 1,
                            );
                          },
                        ),
                      ),
                      filled: true,
                      fillColor: Colors.white,
                      border: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(25),
                      ),
                    ),
                  ),
                ),
              );
            },
          ),
        ),
        const SizedBox(
          height: 15,
        ),
        Center(
          child: Padding(
            padding: const EdgeInsets.all(6.0),
            child: ElevatedButton.icon(
                style: ElevatedButton.styleFrom(
                    onPrimary: Colors.white,
                    backgroundColor: Colors.lightGreen,
                    fixedSize: const Size(175, 40)),
                onPressed: () {
                  if (addMemberFormKey.currentState!.validate()) {
                    context.read<InviteBloc>().add(InviteSent(
                        emailAddress: widget.inviteTextFieldController.text,
                        group: widget.group));

                    context
                        .read<GroupBloc>()
                        .add(UpdateGroup(group: widget.group));
                  }
                },
                icon: BlocConsumer<InviteBloc, InviteState>(
                  listenWhen: (previous, current) =>
                      previous.inviteStatus != current.inviteStatus,
                  listener: (context, state) async {
                    if (state.inviteStatus == InviteStatus.sent) {
                      await Future.delayed(const Duration(seconds: 3));
                      widget.inviteTextFieldController.clear();
                      if (!mounted) return;
                      Navigator.of(context, rootNavigator: true).pop();
                    }
                  },
                  builder: (context, state) {
                    if (state.inviteStatus == InviteStatus.failed) {
                      return const Icon(
                        Icons.warning,
                        color: Colors.red,
                        size: 18,
                      );
                    }
                    if (state.inviteStatus == InviteStatus.sending) {
                      return const SizedBox(
                          height: 18,
                          child: FittedBox(child: CircularProgressIndicator()));
                    }
                    if (state.inviteStatus == InviteStatus.sent) {
                      return const Icon(
                        Icons.check,
                        color: Colors.lime,
                      );
                    } else {
                      return const Icon(
                        Icons.send,
                        size: 18,
                      );
                    }
                  },
                ),
                label: BlocBuilder<InviteBloc, InviteState>(
                  builder: (context, state) {
                    if (state.inviteStatus == InviteStatus.failed) {
                      return const Text('Try Again!');
                    }
                    if (state.inviteStatus == InviteStatus.sending) {
                      return const Text('Sending...');
                    }
                    if (state.inviteStatus == InviteStatus.sent) {
                      return const Text('Invite Sent!');
                    } else {
                      return const Text('Send Invite');
                    }
                  },
                )),
          ),
        ),
      ],
    );
  }
}
