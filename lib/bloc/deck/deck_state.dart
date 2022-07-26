part of 'deck_cubit.dart';

enum DeckStatus { loading, loaded, zoomed, unzoomed, failed, swiped }

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

  @override
  // TODO: implement props
  List<Object?> get props => [status];
}
