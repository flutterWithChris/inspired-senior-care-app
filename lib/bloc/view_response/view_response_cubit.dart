import 'package:bloc/bloc.dart';
import 'package:equatable/equatable.dart';

part 'view_response_state.dart';

class ViewResponseCubit extends Cubit<ViewResponseState> {
  ViewResponseCubit() : super(const ViewResponseState.initial());
  void scroll(int cardIndex) => emit(ViewResponseState.scrolling(cardIndex));
}
