part of 'member_bloc.dart';

@immutable
abstract class MemberState extends Equatable {
  final User? user;
  MemberState({
    this.user,
  });
  @override
  // TODO: implement props
  List<Object?> get props => [user];
}

class MemberInitial extends MemberState {}

class MemberLoaded extends MemberState {
  final Group group;
  final User user;
  MemberLoaded({
    required this.group,
    required this.user,
  });
  @override
  // TODO: implement props
  List<Object?> get props => [group, user];
}

class MemberLoading extends MemberState {}

class MemberFailed extends MemberState {}

class MemberRemoved extends MemberState {}
