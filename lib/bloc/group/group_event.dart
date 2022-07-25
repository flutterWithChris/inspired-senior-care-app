part of 'group_bloc.dart';

@immutable
abstract class GroupEvent {}

class CreateGroup extends GroupEvent {}

class EditGroup extends GroupEvent {}

class DeleteGroup extends GroupEvent {}

class AddToGroup extends GroupEvent {}

class RemoveFromGroup extends GroupEvent {}
