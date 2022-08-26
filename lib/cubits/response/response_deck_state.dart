part of 'response_deck_cubit.dart';

enum ScrollStatus { initial, scrolled, stopped }

@immutable
class ResponseDeckState extends Equatable {
  final ScrollStatus status;
  final int index;
  const ResponseDeckState({required this.index, required this.status});

  factory ResponseDeckState.initial() {
    return const ResponseDeckState(index: 1, status: ScrollStatus.initial);
  }

  factory ResponseDeckState.scrolled(int index) {
    return ResponseDeckState(index: index, status: ScrollStatus.scrolled);
  }
  factory ResponseDeckState.stopped(int index) {
    return ResponseDeckState(index: index, status: ScrollStatus.stopped);
  }

  @override
  // TODO: implement props
  List<Object?> get props => [status, index];
}
