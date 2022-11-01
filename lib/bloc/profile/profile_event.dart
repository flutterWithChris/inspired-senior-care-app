part of 'profile_bloc.dart';

abstract class ProfileEvent extends Equatable {
  String? userId;
  User? user;
  @override
  List<Object?> get props => [user, userId];
}

class LoadProfile extends ProfileEvent {
  final String userId;
  LoadProfile({
    required this.userId,
  });
  @override
  List<Object?> get props => [userId];
}

class UpdateProfile extends ProfileEvent {
  final User user;
  UpdateProfile({
    required this.user,
  });
  @override
  List<Object?> get props => [user];
}

class ResetProfile extends ProfileEvent {}
