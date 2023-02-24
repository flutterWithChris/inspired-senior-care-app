import 'package:bloc/bloc.dart';
import 'package:equatable/equatable.dart';
import 'package:inspired_senior_care_app/data/repositories/database/database_repository.dart';

import '../../data/models/response_comment.dart';

part 'response_comment_event.dart';
part 'response_comment_state.dart';

class ResponseCommentBloc
    extends Bloc<ResponseCommentEvent, ResponseCommentState> {
  final DatabaseRepository _databaseRepository;
  ResponseCommentBloc({required DatabaseRepository databaseRepository})
      : _databaseRepository = databaseRepository,
        super(ResponseCommentInitial()) {
    on<LoadResponseComment>((event, emit) async {
      emit(ResponseCommentLoading());
      try {
        final responseComment = await _databaseRepository.fetchResponseComment(
            event.userId, event.categoryName, event.cardNumber);
        emit(ResponseCommentLoaded(responseComment: responseComment));
      } catch (_) {
        emit(ResponseCommentError());
      }
    });
    on<CreateResponseComment>((event, emit) async {
      emit(ResponseCommentSending());
      try {
        await _databaseRepository.sendResponseComment(event.responseComment);
        emit(ResponseCommentSent());
        await Future.delayed(const Duration(seconds: 2));
        add(LoadResponseComment(
            userId: event.responseComment.userId!,
            categoryName: event.responseComment.categoryName!,
            cardNumber: event.responseComment.cardNumber!));
      } catch (_) {
        emit(ResponseCommentError());
      }
    });
    on<UpdateResponseComment>((event, emit) async {
      emit(ResponseCommentSending());
      try {
        await _databaseRepository.sendResponseComment(event.responseComment);
        emit(ResponseCommentSent());
        await Future.delayed(const Duration(seconds: 2));
        add(LoadResponseComment(
            userId: event.responseComment.userId!,
            categoryName: event.responseComment.categoryName!,
            cardNumber: event.responseComment.cardNumber!));
      } catch (_) {
        emit(ResponseCommentError());
      }
    });
    on<DeleteResponseComment>((event, emit) async {
      emit(ResponseCommentSending());
      try {
        await _databaseRepository.deleteResponseComment(event.responseComment);
        emit(ResponseCommentSent());
        await Future.delayed(const Duration(seconds: 2));
        add(LoadResponseComment(
            userId: event.responseComment.userId!,
            categoryName: event.responseComment.categoryName!,
            cardNumber: event.responseComment.cardNumber!));
      } catch (_) {
        emit(ResponseCommentError());
      }
    });
    on<LoadResponseComments>((event, emit) async {
      emit(ResponseCommentLoading());
      try {
        final responseComments =
            await _databaseRepository.fetchAllResponseComments(
                event.userId, event.categoryName, event.cardNumber);
        emit(ResponseCommentsLoaded(responseComments: responseComments));
      } catch (_) {
        emit(ResponseCommentError());
      }
    });
  }
}
