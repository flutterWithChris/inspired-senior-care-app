import 'dart:async';

import 'package:bloc/bloc.dart';
import 'package:equatable/equatable.dart';
import 'package:inspired_senior_care_app/data/models/category.dart';
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
        super(CardsInitial()) {
    on<LoadCards>(_onCardsLoaded);
    on<ResetCards>((event, emit) => emit(CardsInitial()));
  }
  void _onCardsLoaded(LoadCards event, Emitter<CardState> emit) async {
    emit(CardsLoading());
    _databaseSubscription?.cancel();
    var cardImageUrls =
        await _storageRepository.getCategoryCards(event.category.name);
    emit(CardsLoaded(
      cardImageUrls: cardImageUrls,
      category: event.category,
    ));
  }
}
