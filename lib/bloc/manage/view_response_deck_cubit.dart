import 'package:bloc/bloc.dart';
import 'package:equatable/equatable.dart';
import 'package:meta/meta.dart';

part 'view_response_deck_state.dart';

class ViewResponseDeckCubit extends Cubit<ViewResponseDeckState> {
  int currentCardNumber = 1;
  ViewResponseDeckCubit() : super(ViewResponseDeckState.loaded());
  void resetDeck() => emit(ViewResponseDeckState.loaded());
  void zoomDeck() => emit(ViewResponseDeckState.zoomed());
  void unzoomDeck() => emit(ViewResponseDeckState.unzoomed());
  void swipeDeck() => emit(ViewResponseDeckState.swiped());
  void unswipeDeck() => emit(ViewResponseDeckState.unswiped());
  void incrementCardNumber() => currentCardNumber++;
  void derementCardNumber() => currentCardNumber--;
}
