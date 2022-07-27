part of 'view_response_deck_cubit.dart';

enum ViewResponseDeckStatus {
  loading,
  loaded,
  zoomed,
  unzoomed,
  failed,
  swiped,
  unswiped
}

@immutable
class ViewResponseDeckState extends Equatable {
  int? currentCardNumber;
  final ViewResponseDeckStatus? status;

  ViewResponseDeckState({
    this.currentCardNumber,
    this.status,
  });

  factory ViewResponseDeckState.loading() {
    return ViewResponseDeckState(status: ViewResponseDeckStatus.loading);
  }

  factory ViewResponseDeckState.loaded() {
    return ViewResponseDeckState(status: ViewResponseDeckStatus.loaded);
  }

  factory ViewResponseDeckState.zoomed() {
    return ViewResponseDeckState(status: ViewResponseDeckStatus.zoomed);
  }

  factory ViewResponseDeckState.unzoomed() {
    return ViewResponseDeckState(status: ViewResponseDeckStatus.unzoomed);
  }

  factory ViewResponseDeckState.swiped() {
    return ViewResponseDeckState(status: ViewResponseDeckStatus.swiped);
  }

  factory ViewResponseDeckState.unswiped() {
    return ViewResponseDeckState(status: ViewResponseDeckStatus.unswiped);
  }

  factory ViewResponseDeckState.failed() {
    return ViewResponseDeckState(status: ViewResponseDeckStatus.failed);
  }

  @override
  // TODO: implement props
  List<Object?> get props => [status];
}
