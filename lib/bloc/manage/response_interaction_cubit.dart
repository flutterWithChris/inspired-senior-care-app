import 'package:bloc/bloc.dart';
import 'package:equatable/equatable.dart';
import 'package:meta/meta.dart';

part 'response_interaction_state.dart';

class ResponseInteractionCubit extends Cubit<ResponseInteractionState> {
  ResponseInteractionCubit() : super(ResponseInteractionState.initial());
  void likeResponse() => emit(ResponseInteractionState.liked());
  void unlikeResponse() => emit(ResponseInteractionState.unliked());
}
