part of 'profile_bloc.dart';

@immutable
abstract class ProfileState extends Equatable {
  final User user;
  const ProfileState({
    this.user = User.empty,
  });
  @override
  // TODO: implement props
  List<Object?> get props => [user];
}

class ProfileInitial extends ProfileState {}

class ProfileLoading extends ProfileState {}

class ProfileLoaded extends ProfileState {
  @override
  final User user;
  const ProfileLoaded({
    required this.user,
  });
  @override
  // TODO: implement props
  List<Object?> get props => [user];
}
