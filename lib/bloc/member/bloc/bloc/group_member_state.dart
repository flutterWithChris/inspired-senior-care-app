part of 'group_member_bloc.dart';

abstract class GroupMemberState extends Equatable {
  final List<User>? groupMembers;
  final Group? group;
  const GroupMemberState({
    this.groupMembers,
    this.group,
  });
  @override
  // TODO: implement props
  List<Object?> get props => [group, groupMembers];
}

class GroupMemberInitial extends GroupMemberState {}

class GroupMembersLoaded extends GroupMemberState {
  @override
  final List<User> groupMembers;
  @override
  final Group group;
  const GroupMembersLoaded({
    required this.groupMembers,
    required this.group,
  });
  @override
  // TODO: implement props
  List<Object?> get props => [groupMembers, group];
}

class GroupMembersLoading extends GroupMemberState {}

class GroupMembersFailed extends GroupMemberState {}
