import 'dart:async';

import 'package:bloc/bloc.dart';
import 'package:equatable/equatable.dart';
import 'package:inspired_senior_care_app/bloc/auth/auth_bloc.dart';
import 'package:inspired_senior_care_app/bloc/profile/profile_bloc.dart';
import 'package:inspired_senior_care_app/data/models/group.dart';
import 'package:inspired_senior_care_app/data/models/invite.dart';
import 'package:inspired_senior_care_app/data/models/user.dart';
import 'package:inspired_senior_care_app/data/repositories/auth/auth_repository.dart';
import 'package:inspired_senior_care_app/data/repositories/database/database_repository.dart';
import 'package:meta/meta.dart';

part 'invite_event.dart';
part 'invite_state.dart';

class InviteBloc extends Bloc<InviteEvent, InviteState> {
  final DatabaseRepository _databaseRepository;
  final AuthRepository _authRepository;
  final AuthBloc _authBloc;
  final ProfileBloc _profileBloc;
  StreamSubscription? _inviteStream;
  StreamSubscription? _authStream;

  InviteBloc({
    required DatabaseRepository databaseRepository,
    required AuthRepository authRepository,
    required AuthBloc authBloc,
    required ProfileBloc profileBloc,
  })  : _databaseRepository = databaseRepository,
        _authRepository = authRepository,
        _profileBloc = profileBloc,
        _authBloc = authBloc,
        super(InviteState.loading()) {
    _authStream = _authBloc.stream.listen((event) {
      if (event.authStatus == AuthStatus.authenticated) {
        add(LoadInvites());
      }
    });
    _inviteStream = _databaseRepository.getInvites()!.listen((event) {
      if (event != null) {
        add(LoadInvites());
      }
    });

    on<InviteEvent>((event, emit) async {
      List<Invite> invites = [];
      if (event is LoadInvites) {
        invites.clear();
        await emit.forEach(
          _databaseRepository.getInvites()!,
          onData: (data) {
            if (data != null) {
              List<Invite> invites = data as List<Invite>;

              print('Fetched ${invites.length} invites.');
              return InviteState.loaded(invites);
            } else {
              print('No invites Fetched.');
              return InviteState.loaded(invites);
            }
          },
        );
      }
      if (event is MemberInviteSent) {
        emit(InviteState.sending());
        // Query User
        // If Users exists ? Add User to Group : Alert message.

        await emit.forEach(
          _databaseRepository.getUserByEmail(event.emailAddress),
          onData: (User? user) {
            var currentUser = _profileBloc.state.user;

            Invite invite = Invite(
                inviterName: currentUser.name!,
                groupName: event.group.groupName!,
                groupId: event.group.groupId!,
                inviterId: currentUser.id!,
                invitedUserId: user!.id!,
                inviteType: 'member',
                status: 'sent');
            _databaseRepository.inviteMemberToGroup(invite);
            if (user != null) {
              return InviteState.sent();
            } else {
              return InviteState.failed();
            }
          },
          onError: (error, stackTrace) {
            return InviteState.failed();
          },
        );
        await Future.delayed(const Duration(seconds: 3));
        emit(InviteState.initial());
      }
      if (event is ManagerInviteSent) {
        emit(InviteState.sending());
        // Query User
        // If Users exists ? Add User to Group : Alert message.

        await emit.forEach(
          _databaseRepository.getUserByEmail(event.emailAddress),
          onData: (User? user) {
            var currentUser = _profileBloc.state.user;
            Invite invite = Invite(
                inviterName: currentUser.name!,
                groupName: event.group.groupName!,
                groupId: event.group.groupId!,
                inviterId: currentUser.id!,
                invitedUserId: user!.id!,
                inviteType: 'manager',
                status: 'sent');
            if (user != null) {
              _databaseRepository.inviteMemberToGroup(invite);
              return InviteState.sent();
            } else {
              return InviteState.failed();
            }
          },
          onError: (error, stackTrace) {
            return InviteState.failed();
          },
        );
        await Future.delayed(const Duration(seconds: 3));
        emit(InviteState.initial());
      }
      if (event is InviteAccepted) {
        event.invite.inviteType == 'member'
            ? _databaseRepository.addMemberToGroup(
                event.invite.invitedUserId, event.invite.groupId, event.invite)
            : _databaseRepository.addManagerToGroup(
                event.invite.invitedUserId, event.invite.groupId, event.invite);
        emit(InviteState.accepted());
        _databaseRepository.deleteInvite(event.invite);
        await Future.delayed(const Duration(seconds: 2));
        add(LoadInvites());
      }
      if (event is InviteCancelled) {
        emit(InviteState.cancelled());
      }
      if (event is InviteReceived) {
        emit(InviteState.receieved());
      }
      if (event is InviteDenied) {
        _databaseRepository.deleteInvite(event.invite);
        emit(InviteState.denied());
        await Future.delayed(const Duration(seconds: 2));
        add(LoadInvites());
      }
      // TODO: implement event handler
    });
  }
  @override
  Future<void> close() {
    // TODO: implement close
    _authStream?.cancel();
    _inviteStream?.cancel();
    return super.close();
  }
}
