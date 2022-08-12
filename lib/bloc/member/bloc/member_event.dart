part of 'member_bloc.dart';

@immutable
abstract class MemberEvent extends Equatable {}

class LoadMember extends MemberEvent {
  final String userId;
  LoadMember({
    required this.userId,
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
