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
  List<Response> responses = [];
  final DatabaseRepository _databaseRepository;
  ResponseBloc({required DatabaseRepository databaseRepository})
      : _databaseRepository = databaseRepository,
        super(ResponseLoading()) {
    on<FetchResponse>((event, emit) async {
      responses.clear();
      if (event.user.currentCard![event.category.name] != null) {
        int responseCount = event.user.currentCard![event.category.name] ?? 0;
        for (int i = 1; i < responseCount; i++) {
          _responseStream = _databaseRepository
              .viewResponse(event.user, event.category, i)
              .listen((response) {
            responses.add(response);
          });
        }
      }
      await Future.delayed(const Duration(seconds: 1));
      emit(ResponseLoaded(responses: responses));
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
