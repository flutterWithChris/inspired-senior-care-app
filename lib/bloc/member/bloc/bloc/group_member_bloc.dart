import 'dart:async';

import 'package:bloc/bloc.dart';
import 'package:equatable/equatable.dart';
import 'package:inspired_senior_care_app/data/models/group.dart';
import 'package:inspired_senior_care_app/data/models/user.dart';
import 'package:inspired_senior_care_app/data/repositories/database/database_repository.dart';
import 'package:meta/meta.dart';

part 'group_member_event.dart';
part 'group_member_state.dart';

class GroupMemberBloc extends Bloc<GroupMemberEvent, GroupMemberState> {
  List<User> members = [];
  final DatabaseRepository _databaseRepository;
  GroupMemberBloc({required DatabaseRepository databaseRepository})
      : _databaseRepository = databaseRepository,
        super(GroupMemberInitial()) {
    on<LoadGroupMembers>(_onLoadGroupMembers);
    on<UpdateGroupMembers>((event, emit) async {
      emit(GroupMembersLoading());
      await Future.delayed(const Duration(seconds: 1));
      add(LoadGroupMembers(
          userIds: event.group.groupMemberIds!, group: event.group));
    });
  }

  void _onLoadGroupMembers(
      LoadGroupMembers event, Emitter<GroupMemberState> emit) async {
    StreamSubscription? userSubscription;
    emit(GroupMembersLoading());
    print('Got ${event.userIds.length} users');
    members.clear();
    for (String userId in event.group.groupMemberIds!) {
      userSubscription = _databaseRepository.getUser(userId).listen((user) {
        print('${user.name} received from Firebase');
        members.add(user);
      });
    }
    await Future.delayed(const Duration(milliseconds: 500));
    emit(GroupMembersLoaded(groupMembers: members, group: event.group));
    userSubscription?.cancel();
  }

  @override
  Future<void> close() {
    // TODO: implement close
    return super.close();
  }
}
