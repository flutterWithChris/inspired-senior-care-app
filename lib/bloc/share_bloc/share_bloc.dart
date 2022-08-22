import 'package:bloc/bloc.dart';
import 'package:equatable/equatable.dart';
import 'package:inspired_senior_care_app/data/repositories/database/database_repository.dart';
import 'package:meta/meta.dart';

part 'share_event.dart';
part 'share_state.dart';

class ShareBloc extends Bloc<ShareEvent, ShareState> {
  final DatabaseRepository _databaseRepository;
  ShareBloc({required DatabaseRepository databaseRepository})
      : _databaseRepository = databaseRepository,
        super(ShareState.initial()) {
    on<ShareEvent>((event, emit) async {
      if (event is SubmitPressed) {
        await _databaseRepository.submitResponse(
          event.categoryName,
          event.cardNumber,
          event.response,
        );
        emit(ShareState.submitting());
        await Future.delayed(const Duration(seconds: 1));
        emit(ShareState.submitted());
        await Future.delayed(const Duration(seconds: 1));
        emit(ShareState.initial());
      }
    });
  }
}
