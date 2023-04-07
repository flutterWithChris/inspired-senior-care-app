part of 'comment_notification_bloc.dart';

abstract class CommentNotificationEvent extends Equatable {
  const CommentNotificationEvent();

  @override
  List<Object> get props => [];
}

class LoadCommentNotifications extends CommentNotificationEvent {
  final String userId;
  const LoadCommentNotifications({required this.userId});
}

class ClickCommentNotification extends CommentNotificationEvent {
  final String userId;
  final CommentNotification commentNotification;
  final BuildContext context;
  const ClickCommentNotification(
      {required this.userId,
      required this.commentNotification,
      required this.context});
}
