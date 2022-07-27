import 'package:bloc/bloc.dart';
import 'package:equatable/equatable.dart';
import 'package:meta/meta.dart';

part 'share_event.dart';
part 'share_state.dart';

class ShareBloc extends Bloc<ShareEvent, ShareState> {
  ShareBloc() : super(ShareState.initial()) {
    on<ShareEvent>((event, emit) async {
      if (event is SubmitPressed) {
        emit(ShareState.submitting());
        // await Future.delayed(const Duration(seconds: 2));
        add(ResponseSubmitted());
      }

      if (event is ResponseSubmitted) {
        print('TSETSTEETs');
        emit(ShareState.submitted());
        // await Future.delayed(const Duration(seconds: 2));
        emit(ShareState.initial());
      }
    });
  }
  _submitShareResponse(SubmitPressed event, Emitter<ShareState> emit) {
    emit(ShareState.submitted());
    print('Submitted');
  }
}
