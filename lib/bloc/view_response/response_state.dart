part of 'response_bloc.dart';

@immutable
abstract class ResponseState extends Equatable {
  final String? response;
  final int? responseCount;
  final int? cardNumber;
  const ResponseState({
    this.response,
    this.responseCount,
    this.cardNumber,
  });
  @override
  // TODO: implement props
  List<Object?> get props => [response, responseCount, cardNumber];
}

class ResponseInitial extends ResponseState {}

class ResponseLoading extends ResponseState {}

class ResponseLoaded extends ResponseState {
  @override
  final String? response;
  @override
  final int responseCount;
  @override
  final int? cardNumber;
  const ResponseLoaded({
    this.response,
    required this.responseCount,
    this.cardNumber,
  });
  @override
  // TODO: implement props
  List<Object?> get props => [response, responseCount, cardNumber];
}

class ResponseFailed extends ResponseState {}
