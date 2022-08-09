import 'package:bloc/bloc.dart';
import 'package:equatable/equatable.dart';
import 'package:inspired_senior_care_app/data/models/user.dart';
import 'package:inspired_senior_care_app/data/repositories/database/database_repository.dart';
import 'package:meta/meta.dart';

part 'deck_state.dart';

class DeckCubit extends Cubit<DeckState> {
  final DatabaseRepository _databaseRepository;
  int currentCardNumber = 1;
  DeckCubit({required DatabaseRepository databaseRepository})
      : _databaseRepository = databaseRepository,
        super(DeckState.loaded());
  void resetDeck() => emit(DeckState.loaded());
  void zoomDeck() => emit(DeckState.zoomed());
  void unzoomDeck() => emit(DeckState.unzoomed());
  void swipeDeck() => emit(DeckState.swiped());
  void completeDeck() => emit(DeckState.completed());
  void incrementCardNumber(User user, String categoryName) {
    currentCardNumber++;
    _databaseRepository.updateProgress(user, categoryName, currentCardNumber);
  }

  void derementCardNumber(User user, String categoryName) {
    currentCardNumber--;
    _databaseRepository.updateProgress(user, categoryName, currentCardNumber);
  }
}
