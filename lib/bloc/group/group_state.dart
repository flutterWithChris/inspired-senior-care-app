part of 'group_bloc.dart';

@immutable
abstract class GroupState extends Equatable {
  final Group? group;
  const GroupState({
    this.group,
  });
  @override
  List<Object?> get props => [group];
}

class GroupInitial extends GroupState {}

class GroupLoading extends GroupState {}

class GroupLoaded extends GroupState {
  final List<Group> myGroups;
  const GroupLoaded({
    required this.myGroups,
  });
}

class GroupSubmitting extends GroupState {}

class GroupSubmitted extends GroupState {}

class GroupFailed extends GroupState {}

class GroupUpdated extends GroupState {}

class GroupCreated extends GroupState {
  @override
  final Group group;
  const GroupCreated({
    required this.group,
  });
  @override
  List<Object?> get props => [group];
}

class GroupDeleted extends GroupState {}

class GroupEdited extends GroupState {}
