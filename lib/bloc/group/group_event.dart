part of 'group_bloc.dart';

@immutable
abstract class GroupEvent extends Equatable {
  @override
  // TODO: implement props
  List<Object?> get props => throw UnimplementedError();
}

class LoadGroups extends GroupEvent {
  final User currentUser;
  LoadGroups({
    required this.currentUser,
  });
}

class CreateGroup extends GroupEvent {
  User manager;
  Group group;
  CreateGroup({
    required this.manager,
    required this.group,
  });

  @override
  // TODO: implement props
  List<Object?> get props => [group, manager];
}

class EditGroup extends GroupEvent {}

class DeleteGroup extends GroupEvent {
  final Group group;
  final User manager;
  DeleteGroup({
    required this.group,
    required this.manager,
  });

  @override
  // TODO: implement props
  List<Object?> get props => [group, manager];
}

class UpdateGroup extends GroupEvent {
  User manager;
  Group group;
  UpdateGroup({
    required this.group,
    required this.manager,
  });

  @override
  // TODO: implement props
  List<Object?> get props => [group];
}

class RemoveFromGroup extends GroupEvent {}
