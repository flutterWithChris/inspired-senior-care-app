import 'dart:async';

import 'package:bloc/bloc.dart';
import 'package:equatable/equatable.dart';
import 'package:inspired_senior_care_app/data/models/category.dart';
import 'package:inspired_senior_care_app/data/models/response.dart';
import 'package:inspired_senior_care_app/data/models/user.dart';
import 'package:inspired_senior_care_app/data/repositories/database/database_repository.dart';
import 'package:meta/meta.dart';

part 'response_event.dart';
part 'response_state.dart';

class ResponseBloc extends Bloc<ResponseEvent, ResponseState> {
  StreamSubscription? _responseStream;
  List<Response>? responses;
  final DatabaseRepository _databaseRepository;
  ResponseBloc({required DatabaseRepository databaseRepository})
      : _databaseRepository = databaseRepository,
        super(ResponseInitial()) {
    on<FetchResponse>((event, emit) async {
      String? response;
      emit(ResponseLoading());
      if (event.user.currentCard![event.category.name] != null) {
        try {
          response = await _databaseRepository.viewResponse(
              event.user, event.category, event.cardNumber);
        } catch (e) {
          emit(ResponseFailed());
        }
      }
      emit(
        ResponseLoaded(
          response: response,
          responseCount: event.user.currentCard?[event.category.name] ?? 0,
          cardNumber: event.cardNumber,
        ),
      );
    });
  }

  void _onFetchResponse(
      FetchResponse event, Emitter<ResponseState> emit) async {}

  @override
  Future<void> close() {
    // TODO: implement close
    _responseStream?.cancel();
    return super.close();
  }
}
