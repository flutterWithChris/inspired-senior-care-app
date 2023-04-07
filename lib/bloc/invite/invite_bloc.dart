import 'dart:async';

import 'package:bloc/bloc.dart';
import 'package:equatable/equatable.dart';
import 'package:flutter/foundation.dart';
import 'package:inspired_senior_care_app/bloc/auth/auth_bloc.dart';
import 'package:inspired_senior_care_app/bloc/profile/profile_bloc.dart';
import 'package:inspired_senior_care_app/data/models/group.dart';
import 'package:inspired_senior_care_app/data/models/invite.dart';
import 'package:inspired_senior_care_app/data/models/user.dart';
import 'package:inspired_senior_care_app/data/repositories/auth/auth_repository.dart';
import 'package:inspired_senior_care_app/data/repositories/database/database_repository.dart';
import 'package:rxdart/rxdart.dart';

part 'invite_event.dart';
part 'invite_state.dart';

class InviteBloc extends Bloc<InviteEvent, InviteState> {
  final DatabaseRepository _databaseRepository;
  final AuthRepository _authRepository;
  final AuthBloc _authBloc;
  final ProfileBloc _profileBloc;
  Stream<List<Invite>?>? sentInviteStream;
  Stream<List<Invite>?>? inviteStream;
  Stream<List<Invite>?>? combinedInviteStreamController;
  StreamSubscription? authStream;
  StreamSubscription? _profileStream;
  StreamSubscription? _inviteStreamSubscription;
  StreamSubscription? _sentInviteStreamSubscription;
  late final BehaviorSubject<List<Invite>?> inviteSubject;
  Set<String> addedInviteIds = {};

  BehaviorSubject<List<Invite>?>? sentInviteSubject;
  BehaviorSubject<List<Invite>?>? combinedSubject;
  List<Invite> invites = [];
  List<Invite> newInvites = [];

  InviteBloc({
    required DatabaseRepository databaseRepository,
    required AuthRepository authRepository,
    required AuthBloc authBloc,
    required ProfileBloc profileBloc,
  })  : _databaseRepository = databaseRepository,
        _authRepository = authRepository,
        _profileBloc = profileBloc,
        _authBloc = authBloc,
        inviteSubject = BehaviorSubject(),
        super(InviteState.loading()) {
    _profileStream = _profileBloc.stream.listen((state) async {
      if (state is ProfileLoaded && state.user.type == 'user') {
        await _inviteStreamSubscription?.cancel();
        invites.clear();
        _inviteStreamSubscription =
            _databaseRepository.listenForInvites().listen((event) async {
          newInvites.clear();

          if (event != null && !listEquals(invites, event)) {
            // Check for any duplicates and remove them
            for (final Invite invite in event) {
              if (!addedInviteIds.contains(invite.inviteId) &&
                  invites.contains(invite) == false) {
                addedInviteIds.add(invite.inviteId!);
                newInvites.add(invite);
              }
            }
            invites.addAll(newInvites);
          }
          await Future.delayed(const Duration(seconds: 2));
          add(LoadInvites(user: state.user));
        });
      } else if (state is ProfileLoaded && state.user.type == 'manager') {
        await _inviteStreamSubscription?.cancel();
        _inviteStreamSubscription = MergeStream([
          _databaseRepository.listenForInvites(),
          _databaseRepository.listenForSentInvites()
        ]).listen((event) async {
          newInvites.clear();
          if (event != null && !listEquals((invites), event)) {
            invites.clear();
            // Check for any duplicates and remove them
            final List<Invite> newInvites = [];
            for (final Invite invite in event) {
              if (!addedInviteIds.contains(invite.inviteId) &&
                  invites.contains(invite) == false) {
                addedInviteIds.add(invite.inviteId!);
                newInvites.add(invite);
              }
            }
            invites.addAll(newInvites);
          }
          await Future.delayed(const Duration(seconds: 2));
          add(LoadInvites(user: state.user));
        });
      }
    });
    on<InviteEvent>((event, emit) async {
      if (event is LoadInvites) {
        if (state != InviteState.loading()) {
          emit(InviteState.loading());
        }
        await Future.delayed(const Duration(seconds: 1));

        emit(InviteState.loaded(invites: invites));
      }
      if (event is MemberInviteSent) {
        emit(InviteState.sending());
        // Query User
        // If Users exists ? Add User to Group : Alert message.
        User? invitedUser;
        Invite? invite;
        var currentUser = _profileBloc.state.user;
        _databaseRepository
            .getUserByEmail(event.emailAddress)
            .listen((user) async {
          if (user != null) {
            invitedUser = user;

            invite = Invite(
                inviterName: currentUser.name!,
                groupName: event.group.groupName!,
                groupId: event.group.groupId!,
                inviterId: currentUser.id!,
                invitedUserId: user.id!,
                invitedUserName: user.name!,
                inviteType: 'member',
                status: 'sent');
          }
        });
        await Future.delayed(const Duration(seconds: 2));
        if (invitedUser != null) {
          await _databaseRepository.inviteMemberToGroup(invite!);
          emit(InviteState.sent());
          await Future.delayed(const Duration(seconds: 2));
          add(LoadInvites(user: currentUser));
        } else {
          emit(InviteState.failed());
          await Future.delayed(const Duration(seconds: 2));
          add(LoadInvites(user: currentUser));
        }
      }
      if (event is ManagerInviteSent) {
        var user;
        Invite? invite;
        emit(InviteState.sending());
        var currentUser = _profileBloc.state.user;
        // Query User
        // If Users exists ? Add User to Group : Alert message.
        _databaseRepository.getUserByEmail(event.emailAddress).listen((user) {
          if (user != null) {
            user = user;
            invite = Invite(
                inviterName: currentUser.name!,
                groupName: event.group.groupName!,
                groupId: event.group.groupId!,
                inviterId: currentUser.id!,
                invitedUserName: user.name!,
                invitedUserId: user.id!,
                inviteType: 'manager',
                status: 'sent');
          }
        });
        if (user != null) {
          await _databaseRepository.inviteMemberToGroup(invite!);
          emit(InviteState.sent());
          await Future.delayed(const Duration(seconds: 2));
          add(LoadInvites(user: currentUser));
        } else {
          emit(InviteState.failed());
          await Future.delayed(const Duration(seconds: 2));
          add(LoadInvites(user: currentUser));
        }
      }
      if (event is InviteAccepted) {
        event.invite.inviteType == 'member'
            ? _databaseRepository.addMemberToGroup(
                event.invite.invitedUserId, event.invite.groupId, event.invite)
            : _databaseRepository.addManagerToGroup(
                event.invite.invitedUserId, event.invite.groupId, event.invite);
        try {
          await _databaseRepository.acceptInvite(event.invite);
        } catch (e) {
          emit(InviteState.failed());
        }
        invites.remove(event.invite);
        emit(InviteState.accepted());
        await Future.delayed(const Duration(seconds: 2));
        add(LoadInvites(user: event.user));
      }

      if (event is InviteReceived) {
        emit(InviteState.receieved());
      }
      if (event is InviteDeleted) {
        await _databaseRepository.deleteInvite(event.invite);
        invites.remove(event.invite);
        add(LoadInvites(user: event.user));
      }
      if (event is InviteDenied) {
        await _databaseRepository.declineInvite(event.invite);
        invites.remove(event.invite);

        emit(InviteState.denied());

        await Future.delayed(const Duration(seconds: 2));
        add(LoadInvites(user: event.user));
      }
    });
  }

  @override
  Future<void> close() async {
    await authStream?.cancel();
    await inviteSubject.close();
    await sentInviteSubject?.close();
    await combinedSubject?.close();
    await _inviteStreamSubscription?.cancel();
    await _sentInviteStreamSubscription?.cancel();
    return super.close();
  }
}
