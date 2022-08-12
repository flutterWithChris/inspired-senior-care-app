part of 'group_member_bloc.dart';

@immutable
abstract class GroupMemberState extends Equatable {
  @override
  // TODO: implement props
  List<Object?> get props => throw UnimplementedError();
}

class GroupMemberInitial extends GroupMemberState {}

class GroupMembersLoaded extends GroupMemberState {
  final List<User> groupMembers;
  final Group group;
  GroupMembersLoaded({
    required this.groupMembers,
    required this.group,
  });
  @override
  // TODO: implement props
  List<Object?> get props => [groupMembers, group];
}

class GroupMembersLoading extends GroupMemberState {}

class GroupMembersFailed extends GroupMemberState {}
