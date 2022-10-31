import 'package:bloc/bloc.dart';
import 'package:equatable/equatable.dart';
import 'package:inspired_senior_care_app/bloc/profile/profile_bloc.dart';
import 'package:inspired_senior_care_app/data/models/category.dart';
import 'package:inspired_senior_care_app/data/models/user.dart';
import 'package:inspired_senior_care_app/data/repositories/database/database_repository.dart';

part 'deck_state.dart';

class DeckCubit extends Cubit<DeckState> {
  final DatabaseRepository _databaseRepository;
  final ProfileBloc _profileBloc;
  int currentCardNumber = 1;
  DeckCubit(
      {required DatabaseRepository databaseRepository,
      required ProfileBloc profileBloc})
      : _databaseRepository = databaseRepository,
        _profileBloc = profileBloc,
        super(DeckState.initial());
  void loadDeck(Category category) {
    User currentUser = _profileBloc.state.user;
    currentCardNumber = currentUser.currentCard![category.name] ?? 1;
    emit(DeckState.loaded(currentCardNumber));
  }

  void resetDeck() => emit(DeckState.loaded(1));
  void zoomDeck() => emit(DeckState.zoomed());
  void unzoomDeck() => emit(DeckState.unzoomed());
  void swipeDeck() => emit(DeckState.swiped());
  void completeDeck() => emit(DeckState.completed());
  void updateCardNumber(int index) => currentCardNumber = index;
  void incrementCardNumber(User user, String categoryName) {
    currentCardNumber++;
    _databaseRepository.updateProgress(user, categoryName, currentCardNumber);
  }

  void derementCardNumber(User user, String categoryName) {
    currentCardNumber--;
    _databaseRepository.updateProgress(user, categoryName, currentCardNumber);
  }
}
