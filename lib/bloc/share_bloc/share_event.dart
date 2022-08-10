part of 'share_bloc.dart';

@immutable
abstract class ShareEvent extends Equatable {}

class SubmitPressed extends ShareEvent {
  final String categoryName;
  final int cardNumber;
  final String response;
  SubmitPressed({
    required this.categoryName,
    required this.cardNumber,
    required this.response,
  });
  @override
  // TODO: implement props
  List<Object?> get props => [categoryName, cardNumber, response];
}

class ResponseSubmitted extends ShareEvent {
  @override
  // TODO: implement props
  List<Object?> get props => throw UnimplementedError();
}
