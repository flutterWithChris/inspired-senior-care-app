part of 'card_bloc.dart';

abstract class CardEvent extends Equatable {
  @override
  // TODO: implement props
  List<Object?> get props => throw UnimplementedError();
}

class LoadCards extends CardEvent {
  final String categoryName;
  LoadCards({
    required this.categoryName,
  });
  @override
  // TODO: implement props
  List<Object?> get props => [categoryName];
}

class ResetCards extends CardEvent {}
