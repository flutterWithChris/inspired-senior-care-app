part of 'group_bloc.dart';

@immutable
abstract class GroupEvent extends Equatable {
  String? userId;
  User? manager;
  Group? group;
  GroupEvent({
    this.userId,
    this.manager,
    this.group,
  });
  @override
  List<Object?> get props => [userId, manager, group];
}

class LoadGroups extends GroupEvent {
  @override
  final String userId;
  LoadGroups({
    required this.userId,
  });
}

class CreateGroup extends GroupEvent {
  @override
  final User manager;
  @override
  final Group group;
  CreateGroup({
    required this.manager,
    required this.group,
  });

  @override
  List<Object?> get props => [group, manager];
}

class EditGroup extends GroupEvent {}

class DeleteGroup extends GroupEvent {
  @override
  final Group group;
  @override
  final User manager;
  DeleteGroup({
    required this.group,
    required this.manager,
  });

  @override
  List<Object?> get props => [group, manager];
}

class UpdateGroup extends GroupEvent {
  @override
  final User manager;
  @override
  final Group group;
  UpdateGroup({
    required this.group,
    required this.manager,
  });

  @override
  List<Object?> get props => [group];
}

class RemoveFromGroup extends GroupEvent {}
