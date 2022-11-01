part of 'card_bloc.dart';

abstract class CardEvent extends Equatable {
  Category? category;
  @override
  List<Object?> get props => [category];
}

class LoadCards extends CardEvent {
  final Category category;
  LoadCards({
    required this.category,
  });
  @override
  List<Object?> get props => [category];
}

class ResetCards extends CardEvent {}
