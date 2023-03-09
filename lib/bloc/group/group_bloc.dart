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
import 'package:jiffy/jiffy.dart';

part 'group_event.dart';
part 'group_state.dart';

class GroupBloc extends Bloc<GroupEvent, GroupState> {
  List<Group> groups = [];
  final DatabaseRepository _databaseRepository;
  final InviteBloc _inviteBloc;
  final ProfileBloc _profileBloc;
  StreamSubscription? _profileSubscription;
  StreamSubscription? _inviteSubscription;
  GroupBloc(
      {required DatabaseRepository databaseRepository,
      required InviteBloc inviteBloc,
      required ProfileBloc profileBloc,
      required AuthBloc authBloc})
      : _databaseRepository = databaseRepository,
        _inviteBloc = inviteBloc,
        _profileBloc = profileBloc,
        super(GroupLoading()) {
    _profileSubscription = profileBloc.stream.listen((state) {
      if (state is ProfileLoaded) {
        groups.clear();

        add(LoadGroups(userId: state.user.id!));
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
    Map<int, String> monthlyCategories = {
      1: 'Genuine Relationships',
      2: 'Brain Change',
      3: 'What If',
      4: 'Supportive Environment',
      5: 'Language Matters',
      6: 'Well Being',
      7: 'Meaningful Engagement',
      8: 'Communication',
      9: 'Damaging Interactions',
      10: 'Positive Interactions',
      11: 'Wildly Curious',
      12: 'Strengths Based'
    };
    int month = Jiffy().month;
    String thisMonthsCategory = monthlyCategories[month]!;
    await Future.delayed(const Duration(milliseconds: 500));
    Group groupWithCategory =
        event.group.copyWith(featuredCategory: thisMonthsCategory);
    _databaseRepository.addNewGroup(groupWithCategory, event.manager);
    groups.add(groupWithCategory);

    emit(GroupCreated(group: groupWithCategory));
    await Future.delayed(const Duration(milliseconds: 500));
    emit(GroupLoading());
    add(LoadGroups(userId: event.manager.id!));
  }

  void _onDeleteGroup(DeleteGroup event, Emitter<GroupState> emit) async {
    _databaseRepository.deleteGroup(event.group, event.manager);
    groups.remove(event.group);
    emit(GroupDeleted());
    await Future.delayed(const Duration(seconds: 1));
    emit(GroupLoading());
    add(LoadGroups(userId: event.manager.id!));
  }

  void _onUpdateGroup(UpdateGroup event, Emitter<GroupState> emit) async {
    _databaseRepository.updateGroup(event.group);
    emit(GroupUpdated());
    await Future.delayed(const Duration(milliseconds: 500));
    add(LoadGroups(userId: event.manager.id!));
  }

  void _onGroupLoaded(LoadGroups event, Emitter<GroupState> emit) async {
    emit(GroupLoading());
    User currentUser = _profileBloc.state.user;

    int groupCount = await _databaseRepository.getGroupCount(currentUser.id!);

    // groups.clear();
    currentUser.type == 'user'
        ? groups =
            await _databaseRepository.getMemberGroupsAsFuture(currentUser.id!)
        : groups =
            await _databaseRepository.getManagerGroupsAsFuture(currentUser.id!);

    groups.isEmpty
        ? emit(const GroupLoaded(myGroups: []))
        : emit(GroupLoaded(myGroups: groups));
  }

  @override
  Future<void> close() {
    _inviteSubscription?.cancel();
    _profileSubscription?.cancel();
    return super.close();
  }
}
