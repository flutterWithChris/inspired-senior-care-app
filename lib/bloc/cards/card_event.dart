part of 'card_bloc.dart';

abstract class CardEvent extends Equatable {
  @override
  // TODO: implement props
  List<Object?> get props => throw UnimplementedError();
}

class LoadCards extends CardEvent {
  final String categoryName;
  final Color categoryColor;
  LoadCards({
    required this.categoryName,
    required this.categoryColor,
  });
  @override
  // TODO: implement props
  List<Object?> get props => [categoryName, categoryColor];
}

class ResetCards extends CardEvent {}
