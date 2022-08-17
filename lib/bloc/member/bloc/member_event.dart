part of 'member_bloc.dart';

@immutable
abstract class MemberEvent extends Equatable {}

class LoadMember extends MemberEvent {
  final String userId;
  final Group group;
  LoadMember({
    required this.userId,
    required this.group,
  });
  @override
  // TODO: implement props
  List<Object?> get props => [userId];
}

class ResetMember extends MemberEvent {
  @override
  // TODO: implement props
  List<Object?> get props => throw UnimplementedError();
}

class RemoveMemberFromGroup extends MemberEvent {
  final User user;
  final Group group;
  RemoveMemberFromGroup({
    required this.user,
    required this.group,
  });
  @override
  // TODO: implement props
  List<Object?> get props => [user, group];
}
