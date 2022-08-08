part of 'group_bloc.dart';

@immutable
abstract class GroupState extends Equatable {
  @override
  // TODO: implement props
  List<Object?> get props => throw UnimplementedError();
}

class GroupInitial extends GroupState {}

class GroupSubmitting extends GroupState {}

class GroupSubmitted extends GroupState {}

class GroupFailed extends GroupState {}

class GroupUpdated extends GroupState {}

class GroupCreated extends GroupState {
  final Group group;
  GroupCreated({
    required this.group,
  });
}

class GroupDeleted extends GroupState {}

class GroupEdited extends GroupState {}
