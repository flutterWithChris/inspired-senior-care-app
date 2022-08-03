part of 'profile_bloc.dart';

@immutable
abstract class ProfileEvent extends Equatable {
  @override
  // TODO: implement props
  List<Object?> get props => throw UnimplementedError();
}

class LoadProfile extends ProfileEvent {
  final String userId;
  LoadProfile({
    required this.userId,
  });
  @override
  // TODO: implement props
  List<Object?> get props => [userId];
}

class UpdateProfile extends ProfileEvent {
  final User user;
  UpdateProfile({
    required this.user,
  });
  @override
  // TODO: implement props
  List<Object?> get props => [user];
}
