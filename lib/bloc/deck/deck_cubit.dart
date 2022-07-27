import 'package:bloc/bloc.dart';
import 'package:equatable/equatable.dart';
import 'package:meta/meta.dart';

part 'deck_state.dart';

class DeckCubit extends Cubit<DeckState> {
  int currentCardNumber = 1;
  DeckCubit() : super(DeckState.loaded());
  void resetDeck() => emit(DeckState.loaded());
  void zoomDeck() => emit(DeckState.zoomed());
  void unzoomDeck() => emit(DeckState.unzoomed());
  void swipeDeck() => emit(DeckState.swiped());
  void completeDeck() => emit(DeckState.completed());
  void incrementCardNumber() => currentCardNumber++;
  void derementCardNumber() => currentCardNumber--;
}
