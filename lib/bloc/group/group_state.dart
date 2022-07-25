part of 'group_bloc.dart';

@immutable
abstract class GroupState {}

class GroupInitial extends GroupState {}

class GroupSubmitting extends GroupState {}

class GroupSubmitted extends GroupState {}

class GroupFailed extends GroupState {}

class GroupCreated extends GroupState {}

class GroupDeleted extends GroupState {}

class GroupEdited extends GroupState {}
