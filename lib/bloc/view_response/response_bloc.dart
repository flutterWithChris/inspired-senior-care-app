import 'package:bloc/bloc.dart';
import 'package:equatable/equatable.dart';
import 'package:inspired_senior_care_app/data/models/response.dart';
import 'package:inspired_senior_care_app/data/repositories/database/database_repository.dart';
import 'package:meta/meta.dart';
import 'package:rxdart/rxdart.dart';

part 'response_event.dart';
part 'response_state.dart';

class ResponseBloc extends Bloc<ResponseEvent, ResponseState> {
  BehaviorSubject<String> responseStream = BehaviorSubject<String>();
  final DatabaseRepository _databaseRepository;
  ResponseBloc({required DatabaseRepository databaseRepository})
      : _databaseRepository = databaseRepository,
        super(ResponseLoading()) {
    on<FetchResponse>((event, emit) {
      _databaseRepository
          .viewResponse(event.userId, event.categoryName, event.cardNumber)
          .listen((response) {
        emit(ResponseLoaded(response: response));
      });
    });
  }

  void _onFetchResponse(
      FetchResponse event, Emitter<ResponseState> emit) async {}
}
