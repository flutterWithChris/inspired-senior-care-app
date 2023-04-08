part of 'comment_notification_bloc.dart';

abstract class CommentNotificationState extends Equatable {
  const CommentNotificationState();

  @override
  List<Object> get props => [];
}

class CommentNotificationInitial extends CommentNotificationState {}

class CommentNotificationLoading extends CommentNotificationState {}

class CommentNotificationLoaded extends CommentNotificationState {
  final List<CommentNotification> commentNotifications;
  const CommentNotificationLoaded({required this.commentNotifications});
}

class CommentNotificationError extends CommentNotificationState {}

class CommentNotificationClicked extends CommentNotificationState {}
