import 'dart:async';

import 'package:bloc/bloc.dart';
import 'package:equatable/equatable.dart';
import 'package:inspired_senior_care_app/data/repositories/database/database_repository.dart';
import 'package:inspired_senior_care_app/data/repositories/storage/storage_repository.dart';

part 'card_event.dart';
part 'card_state.dart';

class CardBloc extends Bloc<CardEvent, CardState> {
  final DatabaseRepository _databaseRepository;
  final StorageRepository _storageRepository;
  StreamSubscription? _databaseSubscription;
  CardBloc(
      {required DatabaseRepository databaseRepository,
      required StorageRepository storageRepository})
      : _databaseRepository = databaseRepository,
        _storageRepository = storageRepository,
        super(CardsLoading()) {
    on<LoadCards>(_onCardsLoaded);
    on<ResetCards>((event, emit) => emit(CardsLoading()));
  }
  void _onCardsLoaded(LoadCards event, Emitter<CardState> emit) async {
    _databaseSubscription?.cancel();
    var cardImageUrls =
        await _storageRepository.getCategoryCards(event.categoryName);
    emit(CardsLoaded(
      cardImageUrls: cardImageUrls,
      categoryName: event.categoryName,
    ));
  }
}
