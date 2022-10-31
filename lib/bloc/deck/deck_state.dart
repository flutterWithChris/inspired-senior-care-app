part of 'deck_cubit.dart';

enum DeckStatus {
  initial,
  loading,
  loaded,
  zoomed,
  unzoomed,
  failed,
  swiped,
  completed
}

class DeckState extends Equatable {
  int? currentCardNumber;
  final DeckStatus? status;

  DeckState({
    this.currentCardNumber,
    this.status,
  });

  factory DeckState.initial() {
    return DeckState(status: DeckStatus.initial);
  }

  factory DeckState.loading() {
    return DeckState(status: DeckStatus.loading);
  }

  factory DeckState.loaded(int currentCard) {
    return DeckState(status: DeckStatus.loaded, currentCardNumber: currentCard);
  }

  factory DeckState.zoomed() {
    return DeckState(status: DeckStatus.zoomed);
  }

  factory DeckState.unzoomed() {
    return DeckState(status: DeckStatus.unzoomed);
  }

  factory DeckState.swiped() {
    return DeckState(status: DeckStatus.swiped);
  }

  factory DeckState.failed() {
    return DeckState(status: DeckStatus.failed);
  }

  factory DeckState.completed() {
    return DeckState(status: DeckStatus.completed);
  }

  @override
  // TODO: implement props
  List<DeckStatus?> get props => [status];
}
