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
  List<Object?> get props => [group];
}

class EditGroup extends GroupEvent {}

class DeleteGroup extends GroupEvent {}

class UpdateGroup extends GroupEvent {
  Group group;
  UpdateGroup({
    required this.group,
  });

  @override
  // TODO: implement props
  List<Object?> get props => [group];
}

class RemoveFromGroup extends GroupEvent {}
