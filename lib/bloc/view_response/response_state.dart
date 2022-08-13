part of 'response_bloc.dart';

@immutable
abstract class ResponseState extends Equatable {
  @override
  // TODO: implement props
  List<Object?> get props => [];
}

class ResponseInitial extends ResponseState {}

class ResponseLoading extends ResponseState {}

class ResponseLoaded extends ResponseState {
  final Response response;
  ResponseLoaded({
    required this.response,
  });
  @override
  // TODO: implement props
  List<Object?> get props => [response];
}

class ResponseFailed extends ResponseState {}
