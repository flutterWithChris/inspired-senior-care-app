part of 'deck_cubit.dart';

enum DeckStatus { loading, loaded, zoomed, unzoomed, failed, swiped, completed }

@immutable
class DeckState extends Equatable {
  int? currentCardNumber;
  final DeckStatus? status;

  DeckState({
    this.currentCardNumber,
    this.status,
  });

  factory DeckState.loading() {
    return DeckState(status: DeckStatus.loading);
  }

  factory DeckState.loaded() {
    return DeckState(status: DeckStatus.loaded);
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