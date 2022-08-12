part of 'member_bloc.dart';

@immutable
abstract class MemberState extends Equatable {
  @override
  // TODO: implement props
  List<Object?> get props => [];
}

class MemberInitial extends MemberState {}

class MemberLoaded extends MemberState {
  final User user;
  MemberLoaded({
    required this.user,
  });
}

class MemberLoading extends MemberState {}

class MemberFailed extends MemberState {}
