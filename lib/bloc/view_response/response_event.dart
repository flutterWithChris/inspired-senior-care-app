part of 'response_bloc.dart';

@immutable
abstract class ResponseEvent extends Equatable {}

class FetchResponse extends ResponseEvent {
  final String userId;
  final String categoryName;
  final int cardNumber;
  FetchResponse({
    required this.userId,
    required this.categoryName,
    required this.cardNumber,
  });
  @override
  // TODO: implement props
  List<Object?> get props => [userId, categoryName, cardNumber];
}
