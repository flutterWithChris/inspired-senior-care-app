part of 'response_comment_bloc.dart';

abstract class ResponseCommentEvent extends Equatable {
  const ResponseCommentEvent();

  @override
  List<Object?> get props => [];
}

class LoadResponseComment extends ResponseCommentEvent {
  final String userId;
  final String categoryName;
  final int cardNumber;
  const LoadResponseComment({
    required this.userId,
    required this.categoryName,
    required this.cardNumber,
  });
  @override
  // TODO: implement props
  List<Object?> get props => [userId, categoryName, cardNumber];
}

class LoadResponseComments extends ResponseCommentEvent {
  final String userId;
  final String categoryName;
  final int cardNumber;
  const LoadResponseComments({
    required this.userId,
    required this.categoryName,
    required this.cardNumber,
  });
  @override
  // TODO: implement props
  List<Object?> get props => [userId, categoryName];
}

class CreateResponseComment extends ResponseCommentEvent {
  final ResponseComment responseComment;

  const CreateResponseComment(this.responseComment);

  @override
  List<Object> get props => [responseComment];

  @override
  String toString() =>
      'ResponseComment Created {responseComment: $responseComment}';
}

class UpdateResponseComment extends ResponseCommentEvent {
  final ResponseComment responseComment;

  const UpdateResponseComment(this.responseComment);

  @override
  List<Object> get props => [responseComment];

  @override
  String toString() =>
      'ResponseComment Updated {responseComment: $responseComment}';
}

class DeleteResponseComment extends ResponseCommentEvent {
  final ResponseComment responseComment;

  const DeleteResponseComment(this.responseComment);

  @override
  List<Object> get props => [responseComment];

  @override
  String toString() =>
      'ResponseComment Deleted {responseComment: $responseComment}';
}
