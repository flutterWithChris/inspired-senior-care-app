import 'dart:async';

import 'package:bloc/bloc.dart';
import 'package:equatable/equatable.dart';
import 'package:inspired_senior_care_app/bloc/invite/invite_bloc.dart';
import 'package:inspired_senior_care_app/data/models/group.dart';
import 'package:inspired_senior_care_app/data/models/user.dart';
import 'package:inspired_senior_care_app/data/repositories/database/database_repository.dart';
import 'package:meta/meta.dart';

part 'group_member_event.dart';
part 'group_member_state.dart';

class GroupMemberBloc extends Bloc<GroupMemberEvent, GroupMemberState> {
  List<User> members = [];
  Group? currentGroup;
  final DatabaseRepository _databaseRepository;
  final InviteBloc _inviteBloc;

  GroupMemberBloc(
      {required DatabaseRepository databaseRepository,
      required InviteBloc inviteBloc})
      : _databaseRepository = databaseRepository,
        _inviteBloc = inviteBloc,
        super(GroupMemberInitial()) {
    on<LoadGroupMembers>(_onLoadGroupMembers);
    on<UpdateGroupMembers>((event, emit) async {
      emit(GroupMembersLoading());
      await Future.delayed(const Duration(microseconds: 500));
      add(LoadGroupMembers(
          userIds: event.group.groupMemberIds!, group: event.group));
    });
  }

  void _onLoadGroupMembers(
      LoadGroupMembers event, Emitter<GroupMemberState> emit) async {
    emit(GroupMembersLoading());
    print('Got ${event.userIds.length} users');
    await emit.forEach(_databaseRepository.getGroup(event.group.groupId!),
        onData: (Group group) {
      members.clear();
      currentGroup = group;
      for (String userId in group.groupMemberIds!) {
        _databaseRepository.getUser(userId).listen((user) {
          print('${user.name} received from Firebase');
          members.add(user);
        });
      }
      return GroupMembersLoaded(groupMembers: members, group: group);
    });
  }

  @override
  Future<void> close() {
    // TODO: implement close

    return super.close();
  }
}
