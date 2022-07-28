part of 'view_response_cubit.dart';

enum ScrollStatus { initial, scrolling }

class ViewResponseState extends Equatable {
  final ScrollStatus scrollStatus;
  final int currentCardIndex;
  const ViewResponseState._(
      {required this.scrollStatus, required this.currentCardIndex});

  const ViewResponseState.initial()
      : this._(scrollStatus: ScrollStatus.initial, currentCardIndex: 1);

  const ViewResponseState.scrolling(int cardIndex)
      : this._(
            scrollStatus: ScrollStatus.scrolling, currentCardIndex: cardIndex);

  @override
  List<Object> get props => [scrollStatus, currentCardIndex];
}
