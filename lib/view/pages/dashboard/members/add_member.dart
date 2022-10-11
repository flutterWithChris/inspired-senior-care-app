import 'package:email_validator/email_validator.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
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
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20.0)),
      // contentPadding: const EdgeInsets.symmetric(horizontal: 16.0),
      actionsPadding: const EdgeInsets.symmetric(horizontal: 12.0),
      alignment: AlignmentDirectional.center,
      actionsAlignment: MainAxisAlignment.center,
      // * Main Content
      title: Text(
        'Add Member',
        textAlign: TextAlign.center,
        style: Theme.of(context)
            .textTheme
            .headline4!
            .copyWith(color: Theme.of(context).textTheme.bodyMedium!.color),
      ),
      content: const Text(
        'Enter a member\'s email!',
        textAlign: TextAlign.center,
      ),

      actions: [
        // * Email Text Field
        Center(
          child: BlocBuilder<InviteBloc, InviteState>(
            builder: (context, state) {
              return Form(
                key: addMemberFormKey,
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
                    prefixIcon: const Icon(Icons.email_rounded),
                    hintText: 'example@email.com',
                    filled: true,
                    fillColor: Colors.white,
                    border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(25),
                    ),
                    suffixIcon: BlocBuilder<InviteBloc, InviteState>(
                      builder: (context, state) {
                        if (state.inviteStatus == InviteStatus.sending) {
                          return const SizedBox(
                              height: 8,
                              width: 8,
                              child:
                                  Center(child: CircularProgressIndicator()));
                        }
                        if (state.inviteStatus == InviteStatus.sent) {
                          return const Icon(
                            Icons.check,
                            color: Colors.lime,
                          );
                        } else {
                          return const SizedBox();
                        }
                      },
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
            padding: const EdgeInsets.only(bottom: 24.0, top: 4.0),
            child: ElevatedButton.icon(
                style: ElevatedButton.styleFrom(
                    foregroundColor: Colors.white,
                    // foregroundColor: Colors.white,
                    backgroundColor: Colors.lightGreen,
                    fixedSize: const Size(175, 40)),
                onPressed: () {
                  if (addMemberFormKey.currentState!.validate()) {
                    context.read<InviteBloc>().add(MemberInviteSent(
                        emailAddress:
                            widget.inviteTextFieldController.value.text,
                        group: widget.group));

                    // context.read<GroupBloc>().add(UpdateGroup(
                    //       group: widget.group,
                    //       manager: context.read<ProfileBloc>().state.user,
                    //     ));
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
                        Icons.group_add_rounded,
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
                      return const Text('Member Invited!');
                    } else {
                      return const Text('Add Member');
                    }
                  },
                )),
          ),
        ),
      ],
    );
  }
}
