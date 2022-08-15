part of 'response_bloc.dart';

@immutable
abstract class ResponseEvent extends Equatable {}

class FetchResponse extends ResponseEvent {
  final User user;
  final Category category;
  final int cardNumber;
  FetchResponse({
    required this.user,
    required this.category,
    required this.cardNumber,
  });
  @override
  // TODO: implement props
  List<Object?> get props => [user, category, cardNumber];
}
