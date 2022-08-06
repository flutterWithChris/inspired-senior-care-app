part of 'group_bloc.dart';

@immutable
abstract class GroupEvent extends Equatable {
  @override
  // TODO: implement props
  List<Object?> get props => throw UnimplementedError();
}

class CreateGroup extends GroupEvent {
  Group group;
  CreateGroup({
    required this.group,
  });

  @override
  // TODO: implement props
  List<Object?> get props => [group];
}

class EditGroup extends GroupEvent {}

class DeleteGroup extends GroupEvent {}

class AddToGroup extends GroupEvent {}

class RemoveFromGroup extends GroupEvent {}
