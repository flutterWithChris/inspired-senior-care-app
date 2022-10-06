import 'package:bloc/bloc.dart';
import 'package:equatable/equatable.dart';
import 'package:flutter/material.dart';
import 'package:inspired_senior_care_app/data/models/group.dart';
import 'package:inspired_senior_care_app/data/models/user.dart';
import 'package:inspired_senior_care_app/data/repositories/database/database_repository.dart';

part 'group_event.dart';
part 'group_state.dart';

class GroupBloc extends Bloc<GroupEvent, GroupState> {
  final DatabaseRepository _databaseRepository;
  GroupBloc({required DatabaseRepository databaseRepository})
      : _databaseRepository = databaseRepository,
        super(GroupLoading()) {
    on<LoadGroups>(_onGroupLoaded);
    on<CreateGroup>(_onCreateGroup);
    on<UpdateGroup>(_onUpdateGroup);
  }

  void _onCreateGroup(CreateGroup event, Emitter<GroupState> emit) async {
    emit(GroupSubmitting());
    await Future.delayed(const Duration(milliseconds: 500));
    _databaseRepository.addNewGroup(event.group, event.manager);
    emit(GroupSubmitted());
    emit(GroupCreated(group: event.group));
    await Future.delayed(const Duration(milliseconds: 500));
    emit(GroupInitial());
  }

  void _onUpdateGroup(UpdateGroup event, Emitter<GroupState> emit) async {
    _databaseRepository.updateGroup(event.group);
    emit(GroupUpdated());
    await Future.delayed(const Duration(milliseconds: 500));
    emit(GroupInitial());
  }

  void _onGroupLoaded(LoadGroups event, Emitter<GroupState> emit) async {
    List<Group> groups = [];
    for (int i = 0; i < event.currentUser.groups!.length; i++) {
      _databaseRepository
          .getGroup(event.currentUser.groups![i])
          .listen((group) {
        groups.add(group);
      });
      print('Adding ${event.currentUser.groups![i]}');
      await Future.delayed(const Duration(milliseconds: 500));
    }
    emit(GroupLoaded(myGroups: groups));
  }
}
