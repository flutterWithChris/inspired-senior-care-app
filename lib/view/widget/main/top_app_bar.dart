import 'package:flutter/material.dart';
import 'package:flutter_animate/flutter_animate.dart';

import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:inspired_senior_care_app/bloc/invite/invite_bloc.dart';
import 'package:loading_animation_widget/loading_animation_widget.dart';

import '../../../bloc/profile/profile_bloc.dart';
import '../../../data/models/invite.dart';

class MainTopAppBar extends StatelessWidget {
  final String? title;
  const MainTopAppBar({
    this.title,
    Key? key,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return AppBar(
      backgroundColor: Colors.white,
      foregroundColor: Colors.black87,
      centerTitle: true,
      toolbarHeight: 60,
      actions: const [
        Padding(
          padding: EdgeInsets.only(right: 8.0),
          child: InboxButton(),
        )
      ],
      title: title != null
          ? Text(title!)
          : Image.asset(
              'lib/assets/Logo-01.png',
              height: 40,
              fit: BoxFit.contain,
            ),
    );
  }
}

class InboxButton extends StatelessWidget {
  const InboxButton({
    Key? key,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<InviteBloc, InviteState>(
      builder: (context, state) {
        List<Invite> invites = context.watch<InviteBloc>().state.invites;
        return Stack(
          fit: StackFit.passthrough,
          clipBehavior: Clip.none,
          alignment: AlignmentDirectional.topStart,
          children: [
            PopupMenuButton(
              color: Colors.grey.shade100,
              shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(20)),
              position: PopupMenuPosition.under,
              itemBuilder: (context) {
                return [
                  PopupMenuItem(
                      child: SizedBox(
                    // height: 150,
                    width: 300,
                    child: Column(children: [
                      Padding(
                        padding: const EdgeInsets.all(8.0),
                        child: Text(
                          'Group Invites',
                          textAlign: TextAlign.center,
                          style: Theme.of(context).textTheme.titleLarge,
                        ),
                      ),
                      const SizedBox(
                        height: 8.0,
                      ),
                      const InviteList()
                    ]),
                  ))
                ];
              },
              child: IgnorePointer(
                child: IconButton(
                    onPressed: () {},
                    icon: Icon(
                      FontAwesomeIcons.inbox,
                      color: Theme.of(context).iconTheme.color,
                    )),
              ),
            ),
            invites.isNotEmpty
                ? Animate(
                    effects: const [
                      ShakeEffect(
                          duration: Duration(seconds: 1),
                          hz: 2,
                          offset: Offset(-0.1, 1.0),
                          rotation: 1),
                      // ScaleEffect(),
                      // SlideEffect(
                      //   begin: Offset(0.5, 0.5),
                      //   end: Offset(0, 0),
                      // )
                    ],
                    child: Positioned(
                      top: 8,
                      left: 4,
                      child: CircleAvatar(
                        radius: 10.0,
                        backgroundColor: Colors.blueAccent,
                        child: Text(
                          '${invites.length}',
                          style: const TextStyle(
                              fontWeight: FontWeight.bold, fontSize: 12),
                        ),
                      ),
                    ),
                  )
                : const SizedBox(),
          ],
        );
      },
    );
  }
}

class InviteList extends StatelessWidget {
  const InviteList({
    Key? key,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<InviteBloc, InviteState>(
      builder: (context, state) {
        if (state == InviteState.loading()) {
          return LoadingAnimationWidget.fourRotatingDots(
              color: Colors.blue, size: 20.0);
        }
        if (state.inviteStatus == InviteStatus.sent) {
          return Center(
            child: Wrap(
              spacing: 8.0,
              children: [
                Icon(
                  Icons.check_circle_rounded,
                  color: Colors.green.shade400,
                ),
                const Text('Invite Sent'),
              ],
            ),
          );
        }
        if (state.inviteStatus == InviteStatus.accepted) {
          return Center(
            child: Wrap(
              spacing: 8.0,
              children: [
                Icon(
                  Icons.check_circle_rounded,
                  color: Colors.green.shade400,
                ),
                const Text('Invite Accepted'),
              ],
            ),
          );
        }
        if (state.inviteStatus == InviteStatus.denied) {
          return Center(
            child: Wrap(
              spacing: 8.0,
              children: const [
                Icon(
                  Icons.remove_circle_rounded,
                  color: Colors.redAccent,
                ),
                Text('Invite Declined'),
              ],
            ),
          );
        }
        if (state == InviteState.loaded(state.invites)) {
          return ListView.builder(
              shrinkWrap: true,
              itemCount: state.invites.isNotEmpty ? state.invites.length : 1,
              itemBuilder: (context, index) {
                if (state.invites.isNotEmpty) {
                  Invite thisInvite = state.invites[index];
                  if (thisInvite.status == 'declined') {
                    return DeclinedGroupInvite(thisInvite: thisInvite);
                  }
                  if (thisInvite.status == 'accepted') {
                    return AcceptedGroupInvite(thisInvite: thisInvite);
                  }
                  if (thisInvite.status == 'sent' &&
                      context.read<ProfileBloc>().state.user.type ==
                          'manager') {
                    return SentGroupInvite(thisInvite: thisInvite);
                  } else {
                    return GroupInvite(thisInvite: thisInvite);
                  }
                }
                return SizedBox(
                  height: 100,
                  child: Center(
                    child: Padding(
                      padding: const EdgeInsets.only(bottom: 36.0),
                      child: Text(
                        'No Invites!',
                        style: Theme.of(context)
                            .textTheme
                            .titleSmall!
                            .copyWith(color: Colors.grey.shade600),
                      ),
                    ),
                  ),
                );
              });
        } else {
          return const Center(
            child: Text('Something Went Wrong..'),
          );
        }
      },
    );
  }
}

class GroupInvite extends StatelessWidget {
  const GroupInvite({
    Key? key,
    required this.thisInvite,
  }) : super(key: key);

  final Invite thisInvite;

  @override
  Widget build(BuildContext context) {
    return Card(
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12.0)),
      child: Padding(
        padding: const EdgeInsets.only(left: 16.0, top: 12.0, bottom: 16.0),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Column(
              mainAxisSize: MainAxisSize.min,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Row(
                  mainAxisAlignment: MainAxisAlignment.start,
                  children: [
                    Text(
                      '${thisInvite.inviterName.split(' ')[0]} ',
                      style: Theme.of(context)
                          .textTheme
                          .titleSmall!
                          .copyWith(color: Colors.blue),
                    ),
                    Text(
                      'invited you to:',
                      style: Theme.of(context).textTheme.titleSmall,
                    ),
                  ],
                ),
                Padding(
                  padding: const EdgeInsets.symmetric(vertical: 4.0),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      FittedBox(
                        child: Text(
                          thisInvite.groupName,
                          style: Theme.of(context).textTheme.titleLarge,
                        ),
                      ),
                    ],
                  ),
                ),
                Row(
                  mainAxisAlignment: MainAxisAlignment.start,
                  children: [
                    Text(
                      'As a',
                      style: Theme.of(context).textTheme.titleSmall!,
                    ),
                    Text(
                      ' ${thisInvite.inviteType}',
                      style: Theme.of(context).textTheme.titleSmall!.copyWith(
                            color: Colors.blue,
                          ),
                    ),
                  ],
                ),
              ],
            ),
            Padding(
              padding: const EdgeInsets.only(right: 20.0),
              child: Container(
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(12.0),
                  color: Colors.grey.shade100,
                ),
                child: Padding(
                  padding: const EdgeInsets.all(4.0),
                  child: Column(mainAxisSize: MainAxisSize.min, children: [
                    Padding(
                      padding: const EdgeInsets.only(bottom: 12.0),
                      child: InkWell(
                        onTap: () {
                          context
                              .read<InviteBloc>()
                              .add(InviteAccepted(invite: thisInvite));
                        },
                        child: Icon(
                          color: Colors.green.shade400,
                          Icons.check_circle_rounded,
                          size: 20,
                        ),
                      ),
                    ),
                    Padding(
                      padding: const EdgeInsets.only(top: 12.0),
                      child: InkWell(
                        onTap: () {
                          context
                              .read<InviteBloc>()
                              .add(InviteDenied(invite: thisInvite));
                        },
                        child: const Icon(
                          Icons.cancel_rounded,
                          color: Colors.redAccent,
                          size: 20,
                        ),
                      ),
                    ),
                  ]),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class DeclinedGroupInvite extends StatelessWidget {
  const DeclinedGroupInvite({
    Key? key,
    required this.thisInvite,
  }) : super(key: key);

  final Invite thisInvite;

  @override
  Widget build(BuildContext context) {
    return Card(
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12.0)),
      elevation: 0,
      child: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            FittedBox(
              child: Row(
                mainAxisSize: MainAxisSize.min,
                mainAxisAlignment: MainAxisAlignment.start,
                children: [
                  const Icon(
                    Icons.cancel_rounded,
                    color: Colors.redAccent,
                    size: 14,
                  ),
                  const SizedBox(
                    width: 6.0,
                  ),
                  Text.rich(TextSpan(children: [
                    TextSpan(
                      text: '${thisInvite.inviterName.split(' ')[0]} ',
                      style: Theme.of(context)
                          .textTheme
                          .titleSmall!
                          .copyWith(color: Colors.blue),
                    ),
                    TextSpan(
                      text: 'declined your invite to:',
                      style: Theme.of(context).textTheme.titleSmall,
                    ),
                  ])),
                ],
              ),
            ),
            Padding(
              padding: const EdgeInsets.only(left: 0.0, right: 0),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  FittedBox(
                    child: Text(
                      thisInvite.groupName,
                      style: Theme.of(context).textTheme.titleLarge,
                    ),
                  ),
                  Padding(
                    padding: const EdgeInsets.only(right: 1.0, top: 4.0),
                    child: Row(mainAxisSize: MainAxisSize.min, children: [
                      IconButton(
                        splashRadius: 18,
                        iconSize: 18,
                        visualDensity: VisualDensity.compact,
                        padding: EdgeInsets.zero,
                        onPressed: () {
                          context
                              .read<InviteBloc>()
                              .add(InviteDeleted(invite: thisInvite));
                        },
                        icon: Icon(
                          Icons.close,
                          color: Colors.grey.shade500,
                        ),
                      ),
                    ]),
                  ),
                ],
              ),
            ),
            // Row(
            //   mainAxisAlignment: MainAxisAlignment.start,
            //   children: [
            //     Text(
            //       'As a',
            //       style: Theme.of(context).textTheme.subtitle2!,
            //     ),
            //     Text(
            //       ' ${thisInvite.inviteType}',
            //       style: Theme.of(context).textTheme.subtitle2!.copyWith(
            //             color: Colors.blue,
            //           ),
            //     ),
            //   ],
            // ),
            // const Padding(
            //   padding: EdgeInsets.all(8.0),
            //   child: Divider(),
            // )
          ],
        ),
      ),
    );
  }
}

class AcceptedGroupInvite extends StatelessWidget {
  const AcceptedGroupInvite({
    Key? key,
    required this.thisInvite,
  }) : super(key: key);

  final Invite thisInvite;

  @override
  Widget build(BuildContext context) {
    return Card(
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12.0)),
      elevation: 0,
      child: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            FittedBox(
              child: Row(
                mainAxisSize: MainAxisSize.min,
                mainAxisAlignment: MainAxisAlignment.start,
                children: [
                  Icon(
                    Icons.check_circle_rounded,
                    color: Colors.green.shade400,
                    size: 14,
                  ),
                  const SizedBox(
                    width: 6.0,
                  ),
                  Text.rich(TextSpan(children: [
                    TextSpan(
                      text: '${thisInvite.inviterName.split(' ')[0]} ',
                      style: Theme.of(context)
                          .textTheme
                          .titleSmall!
                          .copyWith(color: Colors.blue),
                    ),
                    TextSpan(
                      text: 'accepted your invite to:',
                      style: Theme.of(context).textTheme.titleSmall,
                    ),
                  ])),
                ],
              ),
            ),
            Padding(
              padding: const EdgeInsets.only(left: 0.0, right: 0),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  FittedBox(
                    child: Text(
                      thisInvite.groupName,
                      style: Theme.of(context).textTheme.titleLarge,
                    ),
                  ),
                  Padding(
                    padding: const EdgeInsets.only(right: 1.0, top: 4.0),
                    child: Row(mainAxisSize: MainAxisSize.min, children: [
                      IconButton(
                        splashRadius: 18,
                        iconSize: 18,
                        visualDensity: VisualDensity.compact,
                        padding: EdgeInsets.zero,
                        onPressed: () {
                          context
                              .read<InviteBloc>()
                              .add(InviteDeleted(invite: thisInvite));
                        },
                        icon: Icon(
                          Icons.close,
                          color: Colors.grey.shade500,
                        ),
                      ),
                    ]),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class SentGroupInvite extends StatelessWidget {
  const SentGroupInvite({
    Key? key,
    required this.thisInvite,
  }) : super(key: key);

  final Invite thisInvite;

  @override
  Widget build(BuildContext context) {
    return Card(
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12.0)),
      elevation: 0,
      child: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.center,
          mainAxisSize: MainAxisSize.min,
          children: [
            FittedBox(
              child: Row(
                mainAxisSize: MainAxisSize.min,
                mainAxisAlignment: MainAxisAlignment.start,
                children: [
                  Icon(
                    Icons.check_circle_rounded,
                    color: Colors.grey.shade400,
                    size: 14,
                  ),
                  const SizedBox(
                    width: 6.0,
                  ),
                  Text.rich(TextSpan(children: [
                    TextSpan(
                      text: '${thisInvite.invitedUserName.split(' ')[0]} ',
                      style: Theme.of(context)
                          .textTheme
                          .titleSmall!
                          .copyWith(color: Colors.blue),
                    ),
                    TextSpan(
                      text: 'has been invited to:',
                      style: Theme.of(context).textTheme.titleSmall,
                    ),
                  ])),
                ],
              ),
            ),
            Padding(
              padding: const EdgeInsets.symmetric(vertical: 4.0),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  FittedBox(
                    child: Text(
                      thisInvite.groupName,
                      style: Theme.of(context).textTheme.titleLarge,
                    ),
                  ),
                ],
              ),
            ),
            Padding(
              padding: const EdgeInsets.only(right: 1.0, top: 4.0),
              child: Row(
                  mainAxisSize: MainAxisSize.min,
                  mainAxisAlignment: MainAxisAlignment.start,
                  children: [
                    ElevatedButton.icon(
                      style: ElevatedButton.styleFrom(
                          backgroundColor: Colors.red,
                          fixedSize: const Size(150, 30)),
                      label: const Text('Cancel Invite'),
                      onPressed: () {
                        context
                            .read<InviteBloc>()
                            .add(InviteDeleted(invite: thisInvite));
                      },
                      icon: const Icon(
                        Icons.close,
                        size: 18,
                        color: Colors.white,
                      ),
                    ),
                  ]),
            ),
          ],
        ),
      ),
    );
  }
}
