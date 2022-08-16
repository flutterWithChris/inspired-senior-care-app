import 'package:bloc/bloc.dart';
import 'package:equatable/equatable.dart';
import 'package:inspired_senior_care_app/data/models/category.dart';
import 'package:inspired_senior_care_app/data/models/response.dart';
import 'package:inspired_senior_care_app/data/models/user.dart';
import 'package:inspired_senior_care_app/data/repositories/database/database_repository.dart';
import 'package:meta/meta.dart';
import 'package:rxdart/rxdart.dart';

part 'response_event.dart';
part 'response_state.dart';

class ResponseBloc extends Bloc<ResponseEvent, ResponseState> {
  BehaviorSubject<String> responseStream = BehaviorSubject<String>();
  List<Response> responses = [];
  final DatabaseRepository _databaseRepository;
  ResponseBloc({required DatabaseRepository databaseRepository})
      : _databaseRepository = databaseRepository,
        super(ResponseLoading()) {
    on<FetchResponse>((event, emit) async {
      if (event.user.progress![event.category.name] != null) {
        int responseCount = event.user.progress![event.category.name] ?? 0;
        for (int i = 1; i < responseCount; i++) {
          _databaseRepository
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
}
