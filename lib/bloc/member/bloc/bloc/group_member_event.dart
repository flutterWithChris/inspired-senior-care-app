part of 'group_member_bloc.dart';

@immutable
abstract class GroupMemberEvent {}

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
