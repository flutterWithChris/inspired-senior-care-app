import 'package:flutter/material.dart';
import 'package:flutter_animate/flutter_animate.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:inspired_senior_care_app/bloc/comment_notifications/comment_notification_bloc.dart';
import 'package:inspired_senior_care_app/bloc/invite/invite_bloc.dart';
import 'package:inspired_senior_care_app/data/models/comment_notification.dart';
import 'package:inspired_senior_care_app/data/repositories/database/database_repository.dart';
import 'package:inspired_senior_care_app/view/widget/notifications/comment_notification_widget.dart';
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
        if (state.inviteStatus == InviteStatus.loading ||
            state.inviteStatus == InviteStatus.initial ||
            state.inviteStatus == InviteStatus.sending) {
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
                            'Notifications',
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

              Positioned(
                top: 8,
                left: 4,
                child: CircleAvatar(
                  radius: 10.0,
                  backgroundColor: Colors.blueAccent,
                  child: LoadingAnimationWidget.discreteCircle(
                      color: Colors.white, size: 8.0),
                ),
              )

              // invites.isNotEmpty
              //     ? Animate(
              //         effects: const [
              //           ShakeEffect(
              //               duration: Duration(seconds: 1),
              //               hz: 2,
              //               offset: Offset(-0.1, 1.0),
              //               rotation: 1),
              //           // ScaleEffect(),
              //           // SlideEffect(
              //           //   begin: Offset(0.5, 0.5),
              //           //   end: Offset(0, 0),
              //           // )
              //         ],
              //         child: Positioned(
              //           top: 8,
              //           left: 4,
              //           child: CircleAvatar(
              //             radius: 10.0,
              //             backgroundColor: Colors.blueAccent,
              //             child: Text(
              //               '${invites.length}',
              //               style: const TextStyle(
              //                   fontWeight: FontWeight.bold, fontSize: 12),
              //             ),
              //           ),
              //         ),
              //       )
              //     : const SizedBox(),
            ],
          );
        }
        if (state.inviteStatus == InviteStatus.loaded ||
            state.inviteStatus == InviteStatus.sent ||
            state.inviteStatus == InviteStatus.accepted ||
            state.inviteStatus == InviteStatus.denied ||
            state.inviteStatus == InviteStatus.cancelled) {
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
                            'Notifications',
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
              FutureBuilder<int>(
                future: context.read<DatabaseRepository>().getInviteCount(),
                builder: (context, snapshot) {
                  var data = snapshot.data;
                  if (data == null) {
                    print('data is null');
                    return const SizedBox();
                  }
                  if (snapshot.hasData) {
                    print('data is not null');
                    // if (state.invites == null || state.invites!.isEmpty) {
                    //   return const SizedBox();
                    // }
                    int invitesCount = data;

                    return FutureBuilder<int>(
                        future: context
                            .read<DatabaseRepository>()
                            .getNotificationCount(),
                        builder: (context, snapshot) {
                          var count = snapshot.data;
                          if (count == null) {
                            return const SizedBox();
                          }
                          if (snapshot.hasData) {
                            int commentCount = count;
                            int totalNotifications =
                                invitesCount + commentCount;
                            return Animate(
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
                                    '$totalNotifications',
                                    style: const TextStyle(
                                        fontWeight: FontWeight.bold,
                                        fontSize: 12),
                                  ),
                                ),
                              ),
                            );
                          } else {
                            return const SizedBox();
                          }
                        });
                  }
                  if (state.inviteStatus == InviteStatus.failed) {
                    return Animate(
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
                      child: const Positioned(
                        top: 8,
                        left: 4,
                        child: CircleAvatar(
                            radius: 10.0,
                            backgroundColor: Colors.white,
                            child: Icon(
                              Icons.error,
                              color: Colors.red,
                              size: 20,
                            )),
                      ),
                    );
                  } else {
                    return const SizedBox();
                  }
                },
              ),
              // invites.isNotEmpty
              //     ? Animate(
              //         effects: const [
              //           ShakeEffect(
              //               duration: Duration(seconds: 1),
              //               hz: 2,
              //               offset: Offset(-0.1, 1.0),
              //               rotation: 1),
              //           // ScaleEffect(),
              //           // SlideEffect(
              //           //   begin: Offset(0.5, 0.5),
              //           //   end: Offset(0, 0),
              //           // )
              //         ],
              //         child: Positioned(
              //           top: 8,
              //           left: 4,
              //           child: CircleAvatar(
              //             radius: 10.0,
              //             backgroundColor: Colors.blueAccent,
              //             child: Text(
              //               '${invites.length}',
              //               style: const TextStyle(
              //                   fontWeight: FontWeight.bold, fontSize: 12),
              //             ),
              //           ),
              //         ),
              //       )
              //     : const SizedBox(),
            ],
          );
        } else {
          return const SizedBox(
            child: Text('Something Went Wrong...'),
          );
        }
      },
    );
  }
}

class InviteList extends StatefulWidget {
  const InviteList({
    Key? key,
  }) : super(key: key);

  @override
  State<InviteList> createState() => _InviteListState();
}

class _InviteListState extends State<InviteList> {
  late Stream<List<Invite>?>? inviteStream;
  @override
  void initState() {
    // TODO: implement initState
    // inviteStream = context.read<InviteBloc>().state.inviteStream;
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<InviteBloc, InviteState>(
      builder: (context, state) {
        if (state.inviteStatus == InviteStatus.loading) {
          return SizedBox(
            height: 100,
            child: Center(
              child: LoadingAnimationWidget.inkDrop(
                  color: Theme.of(context).primaryColor, size: 30.0),
            ),
          );
        }
        if (state.inviteStatus == InviteStatus.failed) {
          return SizedBox(
            height: 150,
            child: Column(
              mainAxisAlignment: MainAxisAlignment.start,
              children: [
                const Padding(
                  padding: EdgeInsets.only(bottom: 8.0),
                  child: Icon(Icons.error, color: Colors.red, size: 50),
                ),
                const Text('Error Loading Invites!'),
                TextButton(
                    onPressed: () {
                      context.read<InviteBloc>().add(LoadInvites(
                          user: context.read<ProfileBloc>().state.user));
                    },
                    child: const Text('Try Again')),
              ],
            ),
          );
        }
        if (state.inviteStatus == InviteStatus.accepted) {
          return SizedBox(
            height: 120,
            child: Center(
              child: Padding(
                padding: const EdgeInsets.only(bottom: 24.0),
                child: Wrap(
                    crossAxisAlignment: WrapCrossAlignment.center,
                    spacing: 10,
                    children: [
                      CircleAvatar(
                          backgroundColor: Colors.green[400],
                          radius: 12,
                          child: const Icon(
                            Icons.check,
                            color: Colors.white,
                            size: 14,
                          )),
                      const Text('Invite Accepted!')
                    ]),
              ),
            ),
          );
        }
        if (state.inviteStatus == InviteStatus.denied) {
          return SizedBox(
            height: 120,
            child: Center(
              child: Padding(
                padding: const EdgeInsets.only(bottom: 24.0),
                child: Wrap(
                    crossAxisAlignment: WrapCrossAlignment.center,
                    spacing: 10,
                    children: const [
                      CircleAvatar(
                          backgroundColor: Colors.redAccent,
                          radius: 12,
                          child: Icon(
                            Icons.cancel,
                            color: Colors.white,
                            size: 14,
                          )),
                      Text('Invite Declined!')
                    ]),
              ),
            ),
          );
        }

        if (state.inviteStatus == InviteStatus.loaded) {
          print('Trying to render invites');
          // List<Invite> invites = [];
          //  print('invites: $invites');

          List<Invite> invites = state.invites!;
          List<Widget> inviteWidgets = [];
          List<Widget> commentNotificationWidgets = [];

          for (var invite in invites) {
            if (invite.status == 'declined') {
              inviteWidgets.add(DeclinedGroupInvite(thisInvite: invite));
            }
            if (invite.status == 'accepted') {
              inviteWidgets.add(AcceptedGroupInvite(thisInvite: invite));
            }
            if (invite.status == 'sent' &&
                context.read<ProfileBloc>().state.user.type == 'manager') {
              inviteWidgets.add(SentGroupInvite(thisInvite: invite));
            } else {
              inviteWidgets.add(GroupInvite(thisInvite: invite));
            }
          }
          return BlocBuilder<CommentNotificationBloc, CommentNotificationState>(
              builder: (context, state) {
            if (state is CommentNotificationLoading) {
              commentNotificationWidgets.clear();
              return Center(
                child: LoadingAnimationWidget.inkDrop(
                    color: Theme.of(context).primaryColor, size: 30.0),
              );
            }
            if (state is CommentNotificationLoaded) {
              List<CommentNotification> commentNotifications =
                  state.commentNotifications;
              print('commentNotifications Not Null: $commentNotifications');

              for (var commentNotification in commentNotifications) {
                commentNotificationWidgets.add(CommentNotificationWidget(
                    commentNotification: commentNotification));
              }
            }
            // Combine inviteWidgets and commentNotificationWidgets
            List<Widget> combinedWidgets = [];
            combinedWidgets.addAll(inviteWidgets);
            combinedWidgets.addAll(commentNotificationWidgets);
            return ListView.builder(
                padding: const EdgeInsets.only(bottom: 0),
                shrinkWrap: true,
                itemCount:
                    combinedWidgets.isNotEmpty ? combinedWidgets.length : 1,
                itemBuilder: (context, index) {
                  if (combinedWidgets.isNotEmpty) {
                    return combinedWidgets[index];
                  }
                  return SizedBox(
                    height: 100,
                    child: Center(
                      child: Padding(
                        padding: const EdgeInsets.only(bottom: 36.0),
                        child: Text(
                          'No Notifications!',
                          style: Theme.of(context)
                              .textTheme
                              .titleSmall!
                              .copyWith(color: Colors.grey.shade600),
                        ),
                      ),
                    ),
                  );
                });
          });
        } else {
          return const Center(
            child: Text('Something Went Wrong..'),
          );
        }
      },
    );

    SizedBox(
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
        padding: const EdgeInsets.only(
            left: 16.0, top: 12.0, bottom: 16.0, right: 16.0),
        child: Column(
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
            Padding(
              padding: const EdgeInsets.only(top: 8.0),
              child: Padding(
                padding: const EdgeInsets.all(4.0),
                child: Row(
                    mainAxisSize: MainAxisSize.max,
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Flexible(
                        child: Padding(
                          padding: const EdgeInsets.only(top: 0.0),
                          child: OutlinedButton(
                            style: IconButton.styleFrom(
                              shape: const StadiumBorder(
                                  side: BorderSide(
                                      color: Colors.redAccent, width: 4.0)),
                              side: const BorderSide(
                                  color: Colors.redAccent, width: 2.0),
                            ),
                            onPressed: () {
                              context.read<InviteBloc>().add(InviteDenied(
                                  invite: thisInvite,
                                  user:
                                      context.read<ProfileBloc>().state.user));
                            },
                            child: const Icon(
                              Icons.cancel_rounded,
                              color: Colors.redAccent,
                              size: 20,
                            ),
                          ),
                        ),
                      ),
                      Flexible(
                        flex: 3,
                        child: Padding(
                          padding: const EdgeInsets.symmetric(horizontal: 8.0),
                          child: ElevatedButton(
                            style: ElevatedButton.styleFrom(
                                // fixedSize: const Size(80, 20),
                                backgroundColor: Colors.green[400]),
                            onPressed: () {
                              context.read<InviteBloc>().add(InviteAccepted(
                                  invite: thisInvite,
                                  user:
                                      context.read<ProfileBloc>().state.user));
                            },
                            child: const Icon(
                              //  color: Colors.green.shade400,
                              Icons.check_circle_rounded,
                              size: 20,
                            ),
                          ),
                        ),
                      ),
                    ]),
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
                      text: '${thisInvite.invitedUserName.split(' ')[0]} ',
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
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Flexible(
                  flex: 3,
                  child: FittedBox(
                    child: Text(
                      thisInvite.groupName,
                      style: Theme.of(context).textTheme.titleLarge,
                    ),
                  ),
                ),
                Flexible(
                  child: Padding(
                    padding: const EdgeInsets.only(top: 4.0),
                    child: Row(
                        mainAxisSize: MainAxisSize.max,
                        mainAxisAlignment: MainAxisAlignment.end,
                        children: [
                          IconButton(
                            splashRadius: 18,
                            iconSize: 18,
                            visualDensity: VisualDensity.compact,
                            padding: EdgeInsets.zero,
                            onPressed: () {
                              context.read<InviteBloc>().add(InviteDeleted(
                                  invite: thisInvite,
                                  user:
                                      context.read<ProfileBloc>().state.user));
                            },
                            icon: Icon(
                              Icons.close,
                              color: Colors.grey.shade500,
                            ),
                          ),
                        ]),
                  ),
                ),
              ],
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
                      text: '${thisInvite.invitedUserName.split(' ')[0]} ',
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
                  Flexible(
                    flex: 3,
                    child: FittedBox(
                      child: Text(
                        thisInvite.groupName,
                        style: Theme.of(context).textTheme.titleLarge,
                      ),
                    ),
                  ),
                  Flexible(
                    child: Padding(
                      padding: const EdgeInsets.only(right: 1.0, top: 4.0),
                      child: Row(
                          mainAxisSize: MainAxisSize.min,
                          mainAxisAlignment: MainAxisAlignment.end,
                          children: [
                            IconButton(
                              splashRadius: 18,
                              iconSize: 18,
                              visualDensity: VisualDensity.compact,
                              padding: EdgeInsets.zero,
                              onPressed: () {
                                context.read<InviteBloc>().add(InviteDeleted(
                                    invite: thisInvite,
                                    user: context
                                        .read<ProfileBloc>()
                                        .state
                                        .user));
                              },
                              icon: Icon(
                                Icons.close,
                                color: Colors.grey.shade500,
                              ),
                            ),
                          ]),
                    ),
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
                  const Icon(
                    Icons.check_circle_rounded,
                    color: Colors.blue,
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
                        context.read<InviteBloc>().add(InviteDeleted(
                            invite: thisInvite,
                            user: context.read<ProfileBloc>().state.user));
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
