import 'dart:async';

import 'package:bloc/bloc.dart';
import 'package:equatable/equatable.dart';
import 'package:flutter/material.dart';
import 'package:inspired_senior_care_app/data/models/group.dart';
import 'package:inspired_senior_care_app/data/models/user.dart';
import 'package:inspired_senior_care_app/data/repositories/database/database_repository.dart';

part 'group_event.dart';
part 'group_state.dart';

class GroupBloc extends Bloc<GroupEvent, GroupState> {
  List<Group> groups = [];
  final DatabaseRepository _databaseRepository;

  GroupBloc({required DatabaseRepository databaseRepository})
      : _databaseRepository = databaseRepository,
        super(GroupLoading()) {
    StreamSubscription memberStream;
    StreamSubscription managerStream;

    on<LoadGroups>(_onGroupLoaded);
    on<CreateGroup>(_onCreateGroup);
    on<UpdateGroup>(_onUpdateGroup);
    on<DeleteGroup>(_onDeleteGroup);
  }

  void _onCreateGroup(CreateGroup event, Emitter<GroupState> emit) async {
    await Future.delayed(const Duration(milliseconds: 500));
    _databaseRepository.addNewGroup(event.group, event.manager);
    groups.add(event.group);
    // event.manager.groups!.add(event.group.groupId!);

    emit(GroupCreated(group: event.group));
    await Future.delayed(const Duration(milliseconds: 500));
    emit(GroupLoading());
    add(LoadGroups(currentUser: event.manager));
  }

  void _onDeleteGroup(DeleteGroup event, Emitter<GroupState> emit) async {
    try {
      _databaseRepository.deleteGroup(event.group, event.manager);
      groups.remove(event.group);
      emit(GroupDeleted());
      await Future.delayed(const Duration(seconds: 1));
      emit(GroupLoading());
      add(LoadGroups(currentUser: event.manager));
    } catch (e) {
      print(e);
    }
  }

  void _onUpdateGroup(UpdateGroup event, Emitter<GroupState> emit) async {
    _databaseRepository.updateGroup(event.group);
    emit(GroupUpdated());
    await Future.delayed(const Duration(milliseconds: 500));
    add(LoadGroups(currentUser: event.manager));
  }

  void _onGroupLoaded(LoadGroups event, Emitter<GroupState> emit) async {
    // await emit.forEach(_databaseRepository.getGroup(groupId), onData:(group) {
    //   groups.add(group);
    // },)
    int groupCount = await _databaseRepository.getGroupCount();
    groups.clear();
    //int groupCount = event.currentUser.groups!.length ?? 0;
    if (groupCount > 0) {
      for (int i = 0; i < groupCount; i++) {
        event.currentUser.type == 'user'
            ? await emit.forEach(
                _databaseRepository.getMemberGroups(event.currentUser),
                onData: (List<Group> data) {
                  return GroupLoaded(myGroups: data);
                },
              )
            : await emit.forEach(
                _databaseRepository.getManagerGroups(event.currentUser),
                onData: (List<Group> data) {
                  return GroupLoaded(myGroups: data);
                },
              );

        print('Adding ${event.currentUser.groups![i]}');
        await Future.delayed(const Duration(milliseconds: 500));
      }
    } else {
      emit(const GroupLoaded(myGroups: []));
    }
  }

  @override
  Future<void> close() {
    // TODO: implement close

    return super.close();
  }
}
