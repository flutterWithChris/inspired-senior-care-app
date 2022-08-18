part of 'card_bloc.dart';

abstract class CardState extends Equatable {
  final Category? category;
  final List<String>? cardImageUrls;
  CardState({
    this.category,
    this.cardImageUrls,
  });
  @override
  // TODO: implement props
  List<Object?> get props => [category, cardImageUrls];
}

class CardsInitial extends CardState {}

class CardsLoading extends CardState {}

class CardsLoaded extends CardState {
  final Category category;
  final List<String> cardImageUrls;

  CardsLoaded({
    required this.category,
    required this.cardImageUrls,
  });
  @override
  // TODO: implement props
  List<Object?> get props => [cardImageUrls, category];
}
