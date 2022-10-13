import 'package:flutter/material.dart';
import 'package:flutter_animate/flutter_animate.dart';

import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:inspired_senior_care_app/bloc/invite/invite_bloc.dart';
import 'package:loading_animation_widget/loading_animation_widget.dart';

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
        // TextButton.icon(
        //     onPressed: () {
        //       context.read<LoginCubit>().signOut();
        //     },
        //     icon: const Icon(Icons.logout_rounded),
        //     label: const Text('Logout'))
        Padding(
          padding: EdgeInsets.only(right: 8.0),
          child: InboxButton(),
        )
      ],
      title: title != null
          ? Text(title!)
          : Image.asset(
              'lib/assets/Inspired-Senior-care.png',
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
                      BlocBuilder<InviteBloc, InviteState>(
                        builder: (context, state) {
                          print(state.toString());
                          if (state == InviteState.loading()) {
                            return LoadingAnimationWidget.fourRotatingDots(
                                color: Colors.blue, size: 20.0);
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
                                itemCount: state.invites.isNotEmpty
                                    ? state.invites.length
                                    : 1,
                                itemBuilder: (context, index) {
                                  if (state.invites.isNotEmpty) {
                                    print(
                                        'Invite 1: ${state.invites[0].inviteId}}');

                                    Invite thisInvite = state.invites[index];

                                    return Padding(
                                      padding: const EdgeInsets.all(8.0),
                                      child: Flex(
                                        direction: Axis.vertical,
                                        children: [
                                          Row(
                                            mainAxisAlignment:
                                                MainAxisAlignment.start,
                                            children: [
                                              Text(
                                                '${thisInvite.inviterName.split(' ')[0]} ',
                                                style: Theme.of(context)
                                                    .textTheme
                                                    .subtitle2!
                                                    .copyWith(
                                                        color: Colors.blue),
                                              ),
                                              Text(
                                                'invited you to:',
                                                style: Theme.of(context)
                                                    .textTheme
                                                    .subtitle2,
                                              ),
                                            ],
                                          ),
                                          Padding(
                                            padding: const EdgeInsets.only(
                                                left: 0.0, right: 0),
                                            child: Row(
                                              mainAxisAlignment:
                                                  MainAxisAlignment
                                                      .spaceBetween,
                                              children: [
                                                FittedBox(
                                                  child: Text(
                                                    thisInvite.groupName,
                                                    style: Theme.of(context)
                                                        .textTheme
                                                        .titleLarge,
                                                  ),
                                                ),
                                                Padding(
                                                  padding:
                                                      const EdgeInsets.only(
                                                          right: 1.0),
                                                  child: Flexible(
                                                    child: Row(
                                                        mainAxisSize:
                                                            MainAxisSize.min,
                                                        children: [
                                                          IconButton(
                                                            splashRadius: 18,
                                                            iconSize: 18,
                                                            visualDensity:
                                                                VisualDensity
                                                                    .compact,
                                                            padding:
                                                                const EdgeInsets
                                                                    .all(0),
                                                            onPressed: () {
                                                              context
                                                                  .read<
                                                                      InviteBloc>()
                                                                  .add(InviteAccepted(
                                                                      invite:
                                                                          thisInvite));
                                                            },
                                                            icon: Icon(
                                                              color: Colors
                                                                  .green
                                                                  .shade400,
                                                              Icons
                                                                  .check_circle_rounded,
                                                            ),
                                                          ),
                                                          IconButton(
                                                            splashRadius: 18,
                                                            iconSize: 18,
                                                            visualDensity:
                                                                VisualDensity
                                                                    .compact,
                                                            padding:
                                                                EdgeInsets.zero,
                                                            onPressed: () {
                                                              context
                                                                  .read<
                                                                      InviteBloc>()
                                                                  .add(InviteDenied(
                                                                      invite:
                                                                          thisInvite));
                                                            },
                                                            icon: const Icon(
                                                              Icons
                                                                  .cancel_rounded,
                                                              color: Colors
                                                                  .redAccent,
                                                            ),
                                                          ),
                                                        ]),
                                                  ),
                                                ),
                                              ],
                                            ),
                                          ),
                                          Row(
                                            mainAxisAlignment:
                                                MainAxisAlignment.start,
                                            children: [
                                              Text(
                                                'As a',
                                                style: Theme.of(context)
                                                    .textTheme
                                                    .subtitle2!,
                                              ),
                                              Text(
                                                ' ${thisInvite.inviteType}',
                                                style: Theme.of(context)
                                                    .textTheme
                                                    .subtitle2!
                                                    .copyWith(
                                                      color: Colors.blue,
                                                    ),
                                              ),
                                            ],
                                          ),
                                          const Padding(
                                            padding: EdgeInsets.all(8.0),
                                            child: Divider(),
                                          )
                                        ],
                                      ),
                                    );
                                  }

                                  print('no invtites!!!');
                                  return SizedBox(
                                    height: 100,
                                    child: Center(
                                      child: Text(
                                        'No Invites!',
                                        style: Theme.of(context)
                                            .textTheme
                                            .subtitle2!
                                            .copyWith(
                                                color: Colors.grey.shade600),
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
                      )
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
