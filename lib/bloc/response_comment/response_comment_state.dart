part of 'response_comment_bloc.dart';

abstract class ResponseCommentState extends Equatable {
  final ResponseComment? responseComment;
  const ResponseCommentState({this.responseComment});

  @override
  List<Object?> get props => [responseComment];
}

class ResponseCommentInitial extends ResponseCommentState {}

class ResponseCommentLoading extends ResponseCommentState {}

class ResponseCommentLoaded extends ResponseCommentState {
  @override
  final ResponseComment? responseComment;
  const ResponseCommentLoaded({
    required this.responseComment,
  });
  @override
  // TODO: implement props
  List<Object?> get props => [responseComment];
}

class ResponseCommentsLoaded extends ResponseCommentState {
  @override
  final List<ResponseComment>? responseComments;
  const ResponseCommentsLoaded({
    required this.responseComments,
  });
  @override
  // TODO: implement props
  List<Object?> get props => [responseComments];
}

class ResponseCommentError extends ResponseCommentState {}

class ResponseCommentSending extends ResponseCommentState {}

class ResponseCommentSent extends ResponseCommentState {}
