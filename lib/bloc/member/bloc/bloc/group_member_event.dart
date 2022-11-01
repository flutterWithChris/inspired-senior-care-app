part of 'group_member_bloc.dart';

abstract class GroupMemberEvent extends Equatable {}

class LoadGroupMembers extends GroupMemberEvent {
  final List<String> userIds;
  final Group group;
  LoadGroupMembers({
    required this.userIds,
    required this.group,
  });
  @override
  // TODO: implement props
  List<Object?> get props => [userIds, group];
}

class UpdateGroupMembers extends GroupMemberEvent {
  final Group group;
  UpdateGroupMembers({required this.group});
  @override
  // TODO: implement props
  List<Object?> get props => [group];
}
