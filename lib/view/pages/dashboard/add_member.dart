import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:inspired_senior_care_app/bloc/invite/invite_bloc.dart';

class AddMemberDialog extends StatelessWidget {
  const AddMemberDialog({
    Key? key,
    required this.inviteTextFieldController,
  }) : super(key: key);

  final TextEditingController inviteTextFieldController;

  @override
  Widget build(BuildContext context) {
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
          child: TextField(
            autofocus: true,
            controller: inviteTextFieldController,
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
                          child: Center(child: CircularProgressIndicator()));
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
        const SizedBox(
          height: 15,
        ),
        Center(
          child: Padding(
            padding: const EdgeInsets.all(6.0),
            child: ElevatedButton.icon(
                style: ElevatedButton.styleFrom(
                    onPrimary: Colors.white,
                    primary: Colors.lightGreen,
                    fixedSize: const Size(175, 40)),
                onPressed: () {
                  context.read<InviteBloc>().add(InviteSent());
                },
                icon: BlocConsumer<InviteBloc, InviteState>(
                  listenWhen: (previous, current) =>
                      previous.inviteStatus != current.inviteStatus,
                  listener: (context, state) {
                    if (state.inviteStatus == InviteStatus.initial) {
                      inviteTextFieldController.clear();
                      Navigator.of(context).pop();
                    }
                  },
                  builder: (context, state) {
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
