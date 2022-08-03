part of 'profile_bloc.dart';

@immutable
abstract class ProfileState extends Equatable {
  @override
  // TODO: implement props
  List<Object?> get props => throw UnimplementedError();
}

class ProfileInitial extends ProfileState {}

class ProfileLoading extends ProfileState {}

class ProfileLoaded extends ProfileState {
  final User user;
  ProfileLoaded({
    required this.user,
  });
  @override
  // TODO: implement props
  List<Object?> get props => [user];
}
