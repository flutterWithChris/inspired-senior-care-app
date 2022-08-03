part of 'card_bloc.dart';

abstract class CardState extends Equatable {
  @override
  // TODO: implement props
  List<Object?> get props => throw UnimplementedError();
}

class CardsInitial extends CardState {}

class CardsLoading extends CardState {}

class CardsLoaded extends CardState {
  final List<String> cardImageUrls;
  final String categoryName;
  CardsLoaded({
    required this.cardImageUrls,
    required this.categoryName,
  });
  @override
  // TODO: implement props
  List<Object?> get props => [cardImageUrls, categoryName];
}
