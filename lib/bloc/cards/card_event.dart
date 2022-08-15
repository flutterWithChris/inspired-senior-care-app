part of 'card_bloc.dart';

abstract class CardEvent extends Equatable {
  @override
  // TODO: implement props
  List<Object?> get props => throw UnimplementedError();
}

class LoadCards extends CardEvent {
  final Category category;

  LoadCards({
    required this.category,
  });
  @override
  // TODO: implement props
  List<Object?> get props => [category];
}

class ResetCards extends CardEvent {}
