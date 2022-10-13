import 'dart:async';

import 'package:bloc/bloc.dart';
import 'package:equatable/equatable.dart';
import 'package:flutter/material.dart';
import 'package:inspired_senior_care_app/bloc/auth/auth_bloc.dart';
import 'package:inspired_senior_care_app/bloc/invite/invite_bloc.dart';
import 'package:inspired_senior_care_app/bloc/profile/profile_bloc.dart';
import 'package:inspired_senior_care_app/data/models/group.dart';
import 'package:inspired_senior_care_app/data/models/user.dart';
import 'package:inspired_senior_care_app/data/repositories/database/database_repository.dart';

part 'group_event.dart';
part 'group_state.dart';

class GroupBloc extends Bloc<GroupEvent, GroupState> {
  List<Group> groups = [];
  final DatabaseRepository _databaseRepository;
  final AuthBloc _authBloc;
  final InviteBloc _inviteBloc;
  final ProfileBloc _profileBloc;
  StreamSubscription? authSubscription;
  StreamSubscription? _inviteSubscription;
  GroupBloc(
      {required DatabaseRepository databaseRepository,
      required InviteBloc inviteBloc,
      required ProfileBloc profileBloc,
      required AuthBloc authBloc})
      : _databaseRepository = databaseRepository,
        _authBloc = authBloc,
        _inviteBloc = inviteBloc,
        _profileBloc = profileBloc,
        super(GroupLoading()) {
    StreamSubscription memberStream;
    StreamSubscription managerStream;
    authSubscription = authBloc.stream.listen((state) {
      if (state.authStatus == AuthStatus.authenticated) {
        groups.clear();

        add(LoadGroups(userId: state.user!.uid));
      }
    });

    _inviteSubscription = _inviteBloc.stream.listen(
      (event) {
        if (state is InviteAccepted) {
          groups.clear();
          add(LoadGroups(userId: _profileBloc.state.user.id!));
        }
      },
    );

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
    add(LoadGroups(userId: event.manager.id!));
  }

  void _onDeleteGroup(DeleteGroup event, Emitter<GroupState> emit) async {
    try {
      _databaseRepository.deleteGroup(event.group, event.manager);
      groups.remove(event.group);
      emit(GroupDeleted());
      await Future.delayed(const Duration(seconds: 1));
      emit(GroupLoading());
      add(LoadGroups(userId: event.manager.id!));
    } catch (e) {
      print(e);
    }
  }

  void _onUpdateGroup(UpdateGroup event, Emitter<GroupState> emit) async {
    _databaseRepository.updateGroup(event.group);
    emit(GroupUpdated());
    await Future.delayed(const Duration(milliseconds: 500));
    add(LoadGroups(userId: event.manager.id!));
  }

  void _onGroupLoaded(LoadGroups event, Emitter<GroupState> emit) async {
    // await emit.forEach(_databaseRepository.getGroup(groupId), onData:(group) {
    //   groups.add(group);
    // },)
    emit(GroupLoading());
    User currentUser = _profileBloc.state.user;
    print('***LOADING GROUPS***');
    int groupCount = currentUser.groups?.length ?? 0;
    print('Group Array Length: $groupCount; User: ${currentUser.name}');
    groups.clear();
    //int groupCount = event.currentUser.groups!.length ?? 0;
    if (groupCount > 0) {
      for (int i = 0; i < groupCount; i++) {
        currentUser.type == 'user'
            ? await emit.forEach(
                _databaseRepository.getMemberGroups(currentUser.id!),
                onData: (List<Group> data) {
                  print('Bloc received ${data.length} groups***');
                  return GroupLoaded(myGroups: data);
                },
              )
            : await emit.forEach(
                _databaseRepository.getManagerGroups(currentUser.id!),
                onData: (List<Group> data) {
                  print('Bloc received ${data.length} groups***');
                  return GroupLoaded(myGroups: data);
                },
              );

        print('Adding ${currentUser.groups![i]}');
        await Future.delayed(const Duration(milliseconds: 500));
      }
    } else {
      emit(const GroupLoaded(myGroups: []));
    }
  }

  @override
  Future<void> close() {
    // TODO: implement close
    _inviteSubscription?.cancel();
    authSubscription?.cancel();
    return super.close();
  }
}
